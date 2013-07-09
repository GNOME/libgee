/* zipfuture.vala
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

internal class Gee.ZipFuture<A, B, C> : GLib.Object, Gee.Future<C> {
	public ZipFuture (Future.ZipFunc<A, B, C> func, Future<A> left, Future<B> right) {
		_left = left;
		_right = right;
		_func = func;
		_left.when_done ((l) => {
			_right.when_done ((r) => {
				_mutex.lock ();
				if (_progress == Progress.INIT) {
					go_join (l, r);
				} else {
					_mutex.unlock ();
				}
			});
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

	public unowned C wait () {
		_mutex.lock ();
		Progress progress = _progress;
		if (progress == Progress.INIT) {
			Future<A> left = _left;
			Future<B> right = _right;
			_mutex.unlock ();
			left.wait ();
			right.wait ();
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

	public unowned bool wait_until (int64 end_time, out unowned C? value = null) {
		_mutex.lock ();
		Progress progress = _progress;
		if (progress == Progress.INIT) {
			Future<A> left = _left;
			Future<B> right = _right;
			_mutex.unlock ();
			if (!left.wait_until (end_time)) {
				return false;
			}
			if (!right.wait_until (end_time)) {
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

	public async unowned C wait_async () {
		_mutex.lock ();
		Progress progress = _progress;
		if (progress == Progress.INIT) {
			Future<A> left = _left;
			Future<B> right = _right;
			_mutex.unlock ();
			yield left.wait_async ();
			yield right.wait_async ();
			_mutex.lock ();
			progress = Progress.PROGRESS;
		}
		if (progress == Progress.PROGRESS) {
			unowned A result = null;
			_when_done += Future.WhenDoneArrayElement<C>((res) => {
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

	public void when_done (Future.WhenDoneFunc<C> func) {
		_mutex.lock ();
		if (_progress == Progress.READY) {
			_mutex.unlock ();
			func (_value);
		} else {
			_when_done += Future.WhenDoneArrayElement<C>(func);
			_mutex.unlock ();
		}
	}

	private inline unowned C go_join (A left, B right) {
		_progress = Progress.PROGRESS;
		_mutex.unlock ();

		C tmp_value = _func (left, right);
		unowned C value = tmp_value;

		_mutex.lock ();
		_value = (owned)tmp_value;
		_progress = Progress.READY;
		_cond.broadcast ();
		_mutex.unlock ();

		Future.WhenDoneArrayElement<C>[] when_done = (owned)_when_done;
		for (int i = 0; i < when_done.length; i++) {
			when_done[i].func (value);
		}
		_left = null;
		_right = null;
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
	private Future<A> _left;
	private Future<B> _right;
	private Future.ZipFunc<A, B, C> _func;
	private C _value;
	private Future.WhenDoneArrayElement<C>[]? _when_done = new Future.WhenDoneArrayElement<C>[0];
	private Progress _progress = Progress.INIT;
}

