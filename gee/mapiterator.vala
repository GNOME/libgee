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
 * except before the first call to {@link next} or {@link first}, or, when an
 * item has been removed, until the next call to {@link next} or {@link first}.
 *
 * Please note that when the iterator is out of track, neither {@link get} nor
 * {@link remove} are defined and both will fail. After the next call to
 * {@link next} or {@link first}, they will be defined again.
 */
public interface Gee.MapIterator<K,V> : GLib.Object {
	/**
	 * Advances to the next entry in the iteration.
	 *
	 * @return true if the iterator has a next entry
	 */
	public abstract bool next ();

	/**
	 * Checks whether there is a next entry in the iteration.
	 *
	 * @return true if the iterator has a next entry
	 */
	public abstract bool has_next ();

	/**
	 * Rewinds to the first entry in the iteration.
	 *
	 * @return true if the iterator has a first entry
	 */
	public abstract bool first ();

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
	 * in-between state. Both {@link get} and {@link unset} will fail until
	 * the next move of the cursor (calling {@link next} or {@link first}).
	 */
	public abstract void unset ();
}

