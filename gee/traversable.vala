/* traversable.vala
 *
 * Copyright (C) 2011  Maciej Piechotka
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



namespace Gee {
	public delegate A FoldFunc<A, G> (owned G g, owned A a);
	public delegate void ForallFunc<G> (owned G g);
	public delegate Lazy<A>? UnfoldFunc<A> ();
	public delegate Traversable.Stream StreamFunc<G, A> (Traversable.Stream state, owned Lazy<G>? g, out Lazy<A>? lazy);
	public delegate A MapFunc<A, G> (owned G g);
	public delegate bool Predicate<G> (G g);
}

public interface Gee.Traversable<G> : Object
{	
	/**
	 * Apply function to each element returned by iterator. 
	 *
	 * Operation moves the iterator to last element in iteration. If iterator
	 * points at some element it will be included in iteration.
	 */
	public new abstract void foreach (ForallFunc<G> f);

	/**
	 * Stream function is an abstract function allowing writing many
	 * operations.
	 *
	 * The stream function accepts three parameter:
	 *
	 *   1. state. It is usually the last returned value from function but
	 *      it may be Stream.END when the previous value was Stream.CONTINUE
	 *      and threre was no next element.
	 *   2. input. It is valid only if first argument is Stream.CONTINUE
	 *   3. output. It is valid only if result is Stream.YIELD
	 *
	 * It may return one of 3 results:
	 *
	 *   1. Stream.YIELD. It means that value was yielded and can be passed
	 *      to outgoint iterator
	 *   2. Stream.CONTINUE. It means that the function needs to be rerun
	 *      with next element (or Stream.END if it is end of stream). If
	 *      the state argument is Stream.END the function MUST NOT return
	 *      this value.
	 *   3. Stream.END. It means that the last argument was yielded.
	 *
	 * If the function yields the value immidiatly then the returning iterator
	 * is {@link valid} and points to this value as well as in case when the
	 * parent iterator is {@link valid} and function yields after consuming
	 * 1 input. In other case returned iterator is invalid.
	 *
	 * Usage of the parent is invalid before the {@link next} or
	 * {@link has_next} returns false and the value will be force-evaluated.
	 *
	 * @param f function generating stream
	 * @return iterator containing values yielded by stream
	 */
	public abstract Iterator<A> stream<A> (owned StreamFunc<G, A> f_);

	/**
	 * Standard aggragation function.
	 *
	 * It takes a function, seed and first element, returns the new seed and
	 * progress to next element when the operation repeats.
	 *
	 * Operation moves the iterator to last element in iteration. If iterator
	 * points at some element it will be included in iteration.
	 *
	 * Note: Default implementation uses {@link foreach}.
	 */
	public virtual A fold<A> (FoldFunc<A, G> f, owned A seed)
	{
		this.foreach ((item) => {seed = f ((owned) item, (owned) seed);});
		return (owned) seed;
	}

	/**
	 * Maps the iterator. It produces iterator that is get by applying
	 * map function to the values of this iterator.
	 *
	 * The value is lazy evaluated but previous value is guaranteed to be
	 * evaluated before {@link next} call.
	 *
	 * If the current iterator is {@link valid} so is the resulting. Using
	 * the iterator after this called is not allowed.
	 *
	 * @param f Mapping function
	 * @return Iterator listing mapped value
	 */
	public virtual Iterator<A> map<A> (MapFunc<A, G> f) {
		return stream<A>((state, item, out val) => {
			switch (state) {
			case Stream.YIELD:
				return Stream.CONTINUE;
			case Stream.CONTINUE:
				val = new Lazy<A>(() => {
					A tmp = item.get ();
					item = null;
					return (f ((owned)tmp));
				});
				return Stream.YIELD;
			case Stream.END:
				return Stream.END;
			default:
				assert_not_reached ();
			}
		});
	}

	/**
	 * Creates a new iterator that is initialy pointing to seed. Then
	 * subsequent values are obtained after applying the function to previous
	 * value and the current item.
	 *
	 * The resulting iterator is always valid and it contains the seed value.
	 *
	 * @param f Folding function
	 * @param seed original seed value
	 * @return Iterator containing values of subsequent values of seed
	 */
	public virtual Iterator<A> scan<A> (FoldFunc<A, G> f, owned A seed) {
		bool seed_emitted = false;
		return stream<A>((state, item, out val) => {
			switch (state) {
			case Stream.YIELD:
				if (seed_emitted) {
					return Stream.CONTINUE;
				} else {
					val = new Lazy<A>.from_value (seed);
					seed_emitted = true;
					return Stream.YIELD;
				}
			case Stream.CONTINUE:
				val = new Lazy<A> (() => {
					A tmp = item.get ();
					item = null;
					seed = f ((owned) tmp, (owned) seed);
					return seed;
				});
				return Stream.YIELD;
			case Stream.END:
				return Stream.END;
			default:
				assert_not_reached ();
			}
		});
	}

	public abstract Iterator<G> filter (owned Predicate<G> f);

	public static Iterator<G> filter_impl<G> (Traversable<G> input, owned Predicate<G> pred) {
		return input.stream<G> ((state, item, out val) => {
			switch (state) {
			case Stream.YIELD:
				return Stream.CONTINUE;
			case Stream.CONTINUE:
				G g = item.get ();
				if (pred (g)) {
					val = item;
					return Stream.YIELD;
				} else {
					return Stream.CONTINUE;
				}
			case Stream.END:
				return Stream.END;
			default:
				assert_not_reached ();
			};
		});
	}

	public enum Stream {
		YIELD,
		CONTINUE,
		END
	}

}

