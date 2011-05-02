/* iterator.vala
 *
 * Copyright (C) 2007-2008  Jürg Billeter
 * Copyright (C) 2009  Didier Villevalois, Maciej Piechotka
 * Copyright (C) 2010-2011  Maciej Piechotka
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
 * 	Jürg Billeter <j@bitron.ch>
 * 	Maciej Piechotka <uzytkownik2@gmail.com>
 * 	Didier 'Ptitjes Villevalois <ptitjes@free.fr>
 */

namespace Gee {
	public delegate A FoldFunc<A, G> (owned G g, owned A a);
	public delegate void ForallFunc<G> (owned G g);
	public delegate Lazy<A>? UnfoldFunc<A> ();
	public delegate Iterator.Stream StreamFunc<A, G> (Iterator.Stream state, owned G? g, out Lazy<A>? lazy);
	public delegate A MapFunc<A, G> (owned G g);
}

/**
 * An iterator over a collection.
 *
 * Gee's iterators are "on-track" iterators. They always point to an item
 * except before the first call to {@link next}, or, when an
 * item has been removed, until the next call to {@link next}.
 *
 * Please note that when the iterator is out of track, neither {@link get} nor
 * {@link remove} are defined and both will fail. After the next call to
 * {@link next}, they will be defined again.
 */
public interface Gee.Iterator<G> : Object {
	/**
	 * Advances to the next element in the iteration.
	 *
	 * @return ``true`` if the iterator has a next element
	 */
	public abstract bool next ();

	/**
	 * Checks whether there is a next element in the iteration.
	 *
	 * @return ``true`` if the iterator has a next element
	 */
	public abstract bool has_next ();

	/**
	 * Returns the current element in the iteration.
	 *
	 * @return the current element in the iteration
	 */
	public abstract G get ();

	/**
	 * Removes the current element in the iteration. The cursor is set in an
	 * in-between state. Both {@link get} and {@link remove} will fail until
	 * the next move of the cursor (calling {@link next}).
	 */
	public abstract void remove ();
	
	/**
	 * Determines wheather the call to {@link get} is legal. It is false at the
	 * beginning and after {@link remove} call and true otherwise.
	 */
	public abstract bool valid { get; }
	
	/**
	 * Determines wheather the call to {@link remove} is legal assuming the
	 * iterator is valid. The value must not change in runtime hence the user
	 * of iterator may cache it.
	 */
	public abstract bool read_only { get; }
	
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
	 * Apply function to each element returned by iterator. 
	 *
	 * Operation moves the iterator to last element in iteration. If iterator
	 * points at some element it will be included in iteration.
	 */
	public new virtual void foreach (ForallFunc<G> f) {
		if (valid)
			f (get ());
		while (next ())
			f (get ());
	}


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
	public virtual Iterator<A> stream<A> (owned StreamFunc<A, G> f_) {
		Stream str;
		Lazy<A>? initial = null;
		bool need_next = true;
		StreamFunc<A, G> f = (owned)f_;
		str = f (Stream.YIELD, null, out initial);
		switch (str) {
		case Stream.CONTINUE:
			if (valid) {
				str = f (Stream.CONTINUE, get (), out initial);
				switch (str) {
				case Stream.YIELD:
				case Stream.CONTINUE:
					break;
				case Stream.END:
					return unfold<A> (() => {return null;});
				default:
					assert_not_reached ();
				}
			}
			break;
		case Stream.YIELD:
			if (valid)
				need_next = false;
			break;
		case Stream.END:
			return unfold<A> (() => {return null;});
		default:
			assert_not_reached ();
		}
		return unfold<A> (() => {
			Lazy<A>? val;
			str = f (Stream.YIELD, null, out val);
			while (str == Stream.CONTINUE) {
				if (need_next) {
					if (!next ()) {
						str = f (Stream.END, null, out val);
						assert (str != Stream.CONTINUE);
						break;
					}
				} else {
					need_next = true;
				}
				str = f (Stream.CONTINUE, get (), out val);
			}
			switch (str) {
			case Stream.YIELD:
				return val;
			case Stream.END:
				return null;
			default:
				assert_not_reached ();
			}
		}, initial);
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
				val = new Lazy<A>(() => {return (f ((owned)item));});
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
				val = new Lazy<A> (() => {seed = f ((owned)item, (owned) seed); return seed;});
				return Stream.YIELD;
			case Stream.END:
				return Stream.END;
			default:
				assert_not_reached ();
			}
		});
	}

	public enum Stream {
		YIELD,
		CONTINUE,
		END
	}

	/**
	 * Create iterator from unfolding function. The lazy value is
         * force-evaluated before progressing to next element.
         *
         * @param f Unfolding function
         * @param current If iterator is to be valid it contains the current value of it
	 */
	public static Iterator<A> unfold<A> (owned UnfoldFunc<A> f, owned Lazy<G>? current = null) {
		return new UnfoldIterator<A> ((owned) f, (owned) current);
	}

	/**
	 * Concatinate iterators.
	 *
	 * @param iters Iterators of iterators
	 * @return Iterator containg values of each iterator
	 */
	public static Iterator<G> concat<G> (Iterator<Iterator<G>> iters) {
		Iterator<G>? current = null;
		if (iters.valid)
			current = iters.get ();
		return unfold<G> (() => {
			while (true) {
				if (current == null) {
					if (iters.next ()) {
						current = iters.get ();
					} else {
						return null;
					}
				} else if (current.next ()) {
					return new Lazy<G>.from_value (current.get ());
				} else {
					current = null;
				}
			}
		});
	}
}

