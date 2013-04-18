/* flatmapfuture.vala
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

internal class Gee.FlatMapFuture<A, G> : Object, Future<A> {
	public FlatMapFuture (Future<G> base_future, Future.FlatMapFunc<A, G> func) {
		_base = base_future;
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
			bool ready = _progress == Progress.READY;
			_mutex.unlock ();
			return ready && _mapped.ready;
		}
	}

	public unowned G wait () {
		unowned Future<A> ret_future;
		_mutex.lock ();
		switch (_progress) {
		case Progress.INIT:
			ret_future = go_map ();
			break;
		case Progress.PROGRESS:
			_cond.wait (_mutex);
			_mutex.unlock ();
			ret_future = _mapped;
			break;
		case Progress.READY:
			_mutex.unlock ();
			ret_future = _mapped;
			break;
		default:
			assert_not_reached ();
		}
		return ret_future.wait ();
	}

	public unowned bool wait_until (int64 end_time, out unowned G? value = null) {
		bool ret_value;
		_mutex.lock ();
		switch (_progress) {
		case Progress.INIT:
			ret_value = go_map ().wait_until (end_time, out value);
			break;
		case Progress.PROGRESS:
			if (ret_value = _cond.wait_until (_mutex, end_time)) {
				_mutex.unlock ();
				ret_value = _mapped.wait_until (end_time, out value);
			} else {
				_mutex.unlock ();
				value = null;
			}
			break;
		case Progress.READY:
			_mutex.unlock ();
			ret_value = _mapped.wait_until (end_time, out value);
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
			_mapped.when_done (func);
		} else {
			_when_done += Future.WhenDoneArrayElement<A>(func);
			_mutex.unlock ();
		}
	}

	private unowned Future<A> go_map () {
		_progress = Progress.PROGRESS;
		_mutex.unlock ();

		Future<A> mapped = _func (_base.value);
		unowned Future<A> result = mapped;

		_mutex.lock ();
		_mapped = (owned)mapped;
		_progress = Progress.READY;
		_cond.broadcast ();
		_mutex.unlock ();

		Future.WhenDoneArrayElement<A>[] when_done = (owned)_when_done;
		for (int i = 0; i < _when_done.length; i++) {
			_mapped.when_done ((owned)when_done[i].func);
		}
		_base = null;
		_func = null;
		return result;
	}

	public enum Progress {
		INIT,
		PROGRESS,
		READY
	}

	private Mutex _mutex = Mutex ();
	private Cond _cond = Cond ();
	private Future<G> _base;
	private Future.FlatMapFunc<A, G> _func;
	private Future<A> _mapped;
	private Progress _progress = Progress.INIT;
	private Future.WhenDoneArrayElement<A>[]? _when_done = new Future.WhenDoneArrayElement<A>[0];
}

