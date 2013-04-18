/* promise.vala
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

using GLib;

/**
 * Promise allows to set a value with associated {@link Future}. Please note that
 * value can be stored only once.
 *
 * Typically the producer will create promise and return {@link future} while
 * keeping the promise to itself. Then when value is ready it can call {@link set_value}.
 */
public class Gee.Promise<G> {
	/**
	 * {@link Future} value of this promise
	 */
	public Gee.Future<G> future {
		get {
			return _future;
		}
	}

	/**
	 * Sets the value of the future.
	 *
	 * @params value Value of future
	 */
	public void set_value (owned G value) {
		_future.set_value (value);
	}

	private class Future<G> : Object, Gee.Future<G> {
		public bool ready {
			get {
				_mutex.lock();
				bool result = _ready;
				_mutex.unlock();
				return result;
			}
		}

		public unowned G wait () {
			_mutex.lock();
			if (!_ready) {
				_set.wait (_mutex);
			}
			_mutex.unlock();
			return _value;
		}

		public bool wait_until (int64 end_time, out unowned G? value = null) {
			bool result = true;
			_mutex.lock();
			if (!_ready) {
				if (!_set.wait_until (_mutex, end_time)) {
					result = false;
				}
			}
			_mutex.unlock();
			if (result) {
				value = _value;
			} else {
				value = null;
			}
			return result;
		}

		public void when_done (Gee.Future.WhenDoneFunc<G> func) {
			_mutex.lock ();
			if (_ready) {
				_mutex.unlock ();
				func (_value);
			} else {
				_when_done += Gee.Future.WhenDoneArrayElement<G>(func);
				_mutex.unlock ();
			}
		}

		internal void set_value (owned G value) {
			unowned G value_copy = value;

			_mutex.lock ();
			assert (!_ready);
			_value = (owned)value;
			_ready = true;
			_set.broadcast ();
			_mutex.unlock ();

			Gee.Future.WhenDoneArrayElement<G>[] when_done = (owned)_when_done;
			for (int i = 0; i < when_done.length; i++) {
				when_done[i].func (value_copy);
			}
		}

		private Mutex _mutex = Mutex ();
		private Cond _set = Cond ();
		private G _value;
		private bool _ready;
		private Gee.Future.WhenDoneArrayElement<G>[]? _when_done = new Gee.Future.WhenDoneArrayElement<G>[0];
	}

	private Future<G> _future = new Future<G>();
}

