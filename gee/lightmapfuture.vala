/* lightmapfuture.vala
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

internal class Gee.LightMapFuture<A, G> : Object, Future<A> {
	public LightMapFuture (Future<G> base_future, Future.LightMapFunc<A, G> func) {
		_base = base_future;
		_func = func;
	}

	public bool ready {
		get {
			return _base.ready;
		}
	}

	public unowned A wait () {
		return _func (_base.wait ());
	}

	public bool wait_until (int64 end_time, out unowned G? value = null) {
		unowned A arg;
		bool result;
		if ((result = _base.wait_until (end_time, out arg))) {
			value = _func (arg);
		}
		return result;
	}

	public async unowned G wait_async () {
		unowned A arg = yield _base.wait_async ();
		return _func (arg);
	}

	public void when_done (owned Future.WhenDoneFunc<G> func) {
		_base.when_done ((a) => {_func (a);});
	}

	private Future<G> _base;
	private Future.LightMapFunc<A, G> _func;
}

