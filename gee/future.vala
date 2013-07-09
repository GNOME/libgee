/* future.vala
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
 * Future is a value which might not yet be computed - for example it is calculated
 * in different thread or depends on I/O value.
 *
 * All methods can be called from many threads as part of interface.
 *
 * @see Promise
 * @see Lazy
 * @see task
 * @see async_task
 * @since 0.11.0
 *
 * Note: Statement that call does not block does not mean that it is lock-free.
 *   Internally the implementation is allowed to take mutex but it should guarantee
 *   that it is not for a long time (including blocking on anything else, I/O calls
 *   or callbacks).
 */
[GenericAccessors]
public interface Gee.Future<G> : Object {
	/**
	 * The value associated with Future. If value is not ready getting value
	 * will block until value is ready.
	 *
	 * Returned value is always the same and it is alive at least as long
	 * as the future.
	 */
	public virtual new G value {
		get {
			return wait ();
		}
	}

	/**
	 * Checks if value is ready. If it is calls to {@link wait} and
	 * {@link wait_until} will not block and value is returned immidiatly.
	 */
	public abstract bool ready {get;}

	/**
	 * Waits until the value is ready.
	 *
	 * @returns The {@link value} associated with future
	 * @see ready
	 * @see wait_until
	 * @see wait_async
	 */
	public abstract unowned G wait ();

	/**
	 * Waits until the value is ready or deadline have passed.
	 *
	 * @param end_time The time when the wait should finish
	 * @param value The {@link value} associated with future if the wait was successful
	 * @returns ``true`` if the value was ready within deadline or ``false`` otherwise
	 * @see ready
	 * @see wait
	 * @see wait_async
	 */
	public abstract bool wait_until (int64 end_time, out unowned G? value = null);

	/**
	 * Reschedules the callback until the {@link value} is available.
	 *
	 * @returns The {@link value} associated with future
	 * @see ready
	 * @see wait
	 * @see wait_until
	 */
	public virtual async unowned G wait_async () {
		unowned G? result = null;
		bool looped = true;
		RecMutex mutex = RecMutex();
		mutex.lock ();
		when_done ((value) => {
			mutex.lock ();
			bool looped_copy = looped;
			mutex.unlock ();
			result = value;
			if (looped_copy) {
				Idle.add (wait_async.callback);
			} else {
				wait_async.callback ();
			}
		});
		looped = false;
		mutex.unlock ();
		yield;
		return result;
	}

	[CCode (scope = "async")]
	public delegate void WhenDoneFunc<G>(G value);

	/**
	 * Registers a callback which is called once the future is {@link ready}.
	 *
	 * Note: As usually the callbacks are called from thread finishing the
	 *   future it is recommended to not include lengthly computation.
	 *   If one is needed please use {@link task}.
	 */
	public abstract void when_done (WhenDoneFunc<G> func);

	public delegate A MapFunc<A, G> (G value);

	/**
	 * Maps a future value to another value by a function and returns the
	 * another value in future.
	 *
	 * @param func Function applied to {@link value}
	 * @returns Value returned by function
	 *
	 * @see flat_map
	 * @see light_map
	 *
	 * Note: As time taken by function might not contribute to
	 *   {@link wait_until} and the implementation is allowed to compute
	 *   value eagerly by {@link when_done} it is recommended to use
	 *   {@link task} and {@link flat_map} for longer computation.
	 */
	public virtual Future<A> map<A> (MapFunc<A, G> func) {
		return new MapFuture<A, G> (this, func);
	}

	public delegate unowned A LightMapFunc<A, G> (G value);

	/**
	 * Maps a future value to another value by a function and returns the
	 * another value in future.
	 *
	 * @param func Function applied to {@link value}
	 * @returns Value returned by function
	 *
	 * @see flat_map
	 * @see map
	 * @since 0.11.4
	 *
	 * Note: The function may be reevaluated at any time and it might
	 *   be called lazily. Therefore it is recommended for it to be
	 *   idempotent. If the function needs to be called eagerly or have
	 *   side-effects it is recommended to use {@link map}.
	 *
	 * Note: As time taken by function does not contribute to
	 *   {@link wait_until} and the implementation is allowed to compute
	 *   value eagerly by {@link when_done} it is recommended to use
	 *   {@link task} and {@link flat_map} for longer computation.
	 */
	public virtual Future<A> light_map<A> (LightMapFunc<A, G> func) {
		return new LightMapFuture<A, G> (this, func);
	}

	[CCode (scope = "async")]
	public delegate C JoinFunc<A, B, C>(A a, B b);

	/**
	 * Combines values of two futures using a function returning the combined
	 * value in future (call does not block).
	 *
	 * @param join_func Function applied to values
	 * @param second Second parameter
	 * @returns A combine value
	 * @since 0.11.4
	 *
	 * Note: As time taken by function does not contribute to
	 *   {@link wait_until} and the implementation is allowed to compute
	 *   value eagerly by {@link when_done} it is recommended to return a
	 *   future from {@link task} and use {@link flat_map} for longer computation.
	 */
	public virtual Future<B> join<A, B> (JoinFunc<G, A, B> join_func, Future<A> second) {
		return new JoinFuture<G, A, B> (join_func, this, second);
	}

	[CCode (scope = "async")]
	public delegate Gee.Future<A> FlatMapFunc<A, G>(G value);

	/**
	 * Maps a future value to another future value which is returned (call does not block).
	 *
	 * @param func Function applied to {@link value}
	 * @returns Value of a future returned by function
	 *
	 * @see map
	 *
	 * Note: As time taken by function does not contribute to
	 *   {@link wait_until} and the implementation is allowed to compute
	 *   value eagerly by {@link when_done} it is recommended to put the
	 *   larger computation inside the returned future for example by
	 *   {@link task}
	 */
	public virtual Gee.Future<A> flat_map<A>(FlatMapFunc<A, G> func) {
		return new FlatMapFuture<A, G> (this, func);
	}

	internal struct WhenDoneArrayElement<G> {
		public WhenDoneArrayElement (WhenDoneFunc<G> func) {
			this.func = func;
		}
		public WhenDoneFunc<G> func;
	}
}

