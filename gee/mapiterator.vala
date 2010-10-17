/* mapiterator.vala
 *
 * Copyright (C) 2009  Didier Villevalois
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
 * 	Didier 'Ptitjes Villevalois <ptitjes@free.fr>
 */

/**
 * An iterator over a map.
 *
 * Gee's iterators are "on-track" iterators. They always point to an item
 * except before the first call to {@link next}, or, when an
 * item has been removed, until the next call to {@link next}.
 *
 * Please note that when the iterator is out of track, neither {@link get_key},
 * {@link get_value}, {@link set_value} nor {@link unset} are defined and all
 * will fail. After the next call to {@link next}, they will
 * be defined again.
 */
public interface Gee.MapIterator<K,V> : Object {
	/**
	 * Advances to the next entry in the iteration.
	 *
	 * @return `true` if the iterator has a next entry
	 */
	public abstract bool next ();

	/**
	 * Checks whether there is a next entry in the iteration.
	 *
	 * @return `true` if the iterator has a next entry
	 */
	public abstract bool has_next ();

	/**
	 * Returns the current key in the iteration.
	 *
	 * @return the current key in the iteration
	 */
	public abstract K get_key ();

	/**
	 * Returns the value associated with the current key in the iteration.
	 *
	 * @return the value for the current key
	 */
	public abstract V get_value ();

	/**
	 * Sets the value associated with the current key in the iteration.
	 *
	 * @param value the new value for the current key
	 */
	public abstract void set_value (V value);

	/**
	 * Unsets the current entry in the iteration. The cursor is set in an
	 * in-between state. {@link get_key}, {@link get_value}, {@link set_value}
	 * and {@link unset} will fail until the next move of the cursor (calling
	 * {@link next}).
	 */
	public abstract void unset ();
	
	/**
	 * Determines wheather the call to {@link get_key}, {@link get_value} and 
	 * {@link set_value} is legal. It is false at the beginning and after
	 * {@link unset} call and true otherwise.
	 */
	public abstract bool at_element { get; }
}

