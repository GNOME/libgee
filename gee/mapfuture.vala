/* mapfuture.vala
 *
 * Copyright (C) 2013  Maciej Piechotka
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Maciej Piechotka <uzytkownik2@gmail.com>
 */

internal class Gee.MapFuture<A, G> : Object, Future<A> {
	public MapFuture (Future<G> future_base, MapFunc<A, G> func) {
		_base = future_base;
		_func = func;
		_base.when_done (() => {
			_mutex.lock ();
			if (_progress == Progress.INIT) {
				go_map ();
			} else {
				_mutex.unlock ();
			}
		});
	}

	public bool ready {
		get {
			_mutex.lock ();
			bool locked = _progress == Progress.READY;
			_mutex.unlock ();
			return locked;
		}
	}

	public unowned A wait () {
		unowned A ret_value;
		_mutex.lock ();
		switch (_progress) {
		case Progress.INIT:
			ret_value = go_map ();
			break;
		case Progress.PROGRESS:
			_cond.wait (_mutex);
			_mutex.unlock ();
			ret_value = _value;
			break;
		case Progress.READY:
			_mutex.unlock ();
			ret_value = _value;
			break;
		default:
			assert_not_reached ();
		}
		return ret_value;
	}

	public unowned bool wait_until (int64 end_time, out unowned G? value = null) {
		bool ret_value;
		_mutex.lock ();
		switch (_progress) {
		case Progress.INIT:
			value = go_map ();
			ret_value = true;
			break;
		case Progress.PROGRESS:
			if (ret_value = _cond.wait_until (_mutex, end_time)) {
				_mutex.unlock ();
				value = _value;
			} else {
				_mutex.unlock ();
			}
			break;
		case Progress.READY:
			_mutex.unlock ();
			value = _value;
			ret_value = true;
			break;
		default:
			assert_not_reached ();
		}
		return ret_value;
	}

	public void when_done (Future.WhenDoneFunc<A> func) {
		_mutex.lock ();
		if (_progress == Progress.READY) {
			_mutex.unlock ();
			func (_value);
		} else {
			_when_done += Future.WhenDoneArrayElement<G>(func);
			_mutex.unlock ();
		}
	}

	private unowned A go_map () {
		_progress = Progress.PROGRESS;
		_mutex.unlock ();

		A tmp_value = _func (_base.value);
		unowned A value = tmp_value;

		_mutex.lock ();
		_value = (owned)tmp_value;
		_progress = Progress.READY;
		_cond.broadcast ();
		_mutex.unlock ();

		Future.WhenDoneArrayElement<G>[] when_done = (owned)_when_done;
		for (int i = 0; i < when_done.length; i++) {
			when_done[i].func (value);
		}
		_base = null;
		_func = null;
		return value;
	}

	private enum Progress {
		INIT,
		PROGRESS,
		READY
	}

	private Mutex _mutex = Mutex ();
	private Cond _cond = Cond ();
	private Future<G> _base;
	private MapFunc<A, G> _func;
	private A _value;
	private Progress _progress = Progress.INIT;
	private Future.WhenDoneArrayElement<G>[]? _when_done = new Future.WhenDoneArrayElement<G>[0];
}

