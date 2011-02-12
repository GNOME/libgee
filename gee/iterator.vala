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
	public delegate A FoldFunc<A, G> (G g, owned A a);
	public delegate void ForallFunc<G> (G g);
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
	 */
	public virtual A fold<A> (FoldFunc<A, G> f, owned A seed)
	{
		if (valid)
			seed = f (get (), (owned) seed);
		while (next ())
			seed = f (get (), (owned) seed);
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
}

