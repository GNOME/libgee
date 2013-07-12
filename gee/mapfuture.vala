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
	public MapFuture (Future<G> future_base, owned Future.MapFunc<A, G> func) {
		_base = future_base;
		_func = (owned)func;
		_base.when_done ((val) => {
			_mutex.lock ();
			if (_progress == Progress.INIT) {
				go_map (val);
			} else {
				_mutex.unlock ();
			}
		});
	}

	public bool ready {
		get {
			_mutex.lock ();
			bool result = _progress == Progress.READY;
			_mutex.unlock ();
			return result;
		}
	}

	public unowned A wait () {
		_mutex.lock ();
		Progress progress = _progress;
		if (progress == Progress.INIT) {
			Future<G> base_future = _base;
			_mutex.unlock ();
			base_future.wait ();
			_mutex.lock ();
			progress = Progress.PROGRESS;
		}
		if (progress == Progress.PROGRESS) {
			_cond.wait (_mutex);
			progress = Progress.READY;
		}
		if (progress == Progress.READY) {
			_mutex.unlock ();
			return _value;
		}
		assert_not_reached ();
	}

	public unowned bool wait_until (int64 end_time, out unowned A? value = null) {
		_mutex.lock ();
		Progress progress = _progress;
		if (progress == Progress.INIT) {
			Future<G> base_future = _base;
			_mutex.unlock ();
			if (!base_future.wait_until (end_time)) {
				return false;
			}
			_mutex.lock ();
			progress = Progress.PROGRESS;
		}
		if (progress == Progress.PROGRESS) {
			if (!_cond.wait_until (_mutex, end_time)) {
				_mutex.unlock ();
				return false;
			}
			progress = Progress.READY;
		}
		if (progress == Progress.READY) {
			_mutex.unlock ();
			value = _value;
			return true;
		}
		assert_not_reached ();
	}

	public async unowned A wait_async () {
		_mutex.lock ();
		Progress progress = _progress;
		if (progress == Progress.INIT) {
			Future<G> base_future = _base;
			_mutex.unlock ();
			yield base_future.wait_async ();
			_mutex.lock ();
			progress = Progress.PROGRESS;
		}
		if (progress == Progress.PROGRESS) {
			unowned A result = null;
			_when_done += Future.WhenDoneArrayElement<G>((res) => {
				wait_async.callback ();
			});
			_mutex.unlock ();
			yield;
			return _value;
		}
		if (progress == Progress.READY) {
			_mutex.unlock ();
			return _value;
		}
		assert_not_reached ();
	}

	public void when_done (owned Future.WhenDoneFunc<A> func) {
		_mutex.lock ();
		if (_progress == Progress.READY) {
			_mutex.unlock ();
			func (_value);
		} else {
			_when_done += Future.WhenDoneArrayElement<G>((owned)func);
			_mutex.unlock ();
		}
	}

	private inline unowned A go_map (G val) {
		_progress = Progress.PROGRESS;
		_mutex.unlock ();

		A tmp_value = _func (val);
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
	private Future.MapFunc<A, G> _func;
	private A _value;
	private Progress _progress = Progress.INIT;
	private Future.WhenDoneArrayElement<G>[]? _when_done = new Future.WhenDoneArrayElement<G>[0];
}

