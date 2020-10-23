/* multiset.vala
 *
 * Copyright (C) 2009  Ali Sabil
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
 * 	Ali Sabil <ali.sabil@gmail.com>
 */

/**
 * A collection with duplicate elements.
 */
[GenericAccessors]
public interface Gee.MultiSet<G> : Collection<G> {
	/**
	 * Returns the number of occurrences of an item in this multiset.
	 *
	 * @param item the item to count occurrences of
	 *
	 * @return     the number of occurrences of the item in this multiset.
	 */
	public abstract int count (G item);

	/**
	 * The read-only view of this set.
	 */
	public virtual new MultiSet<G> read_only_view {
		owned get {
			return new ReadOnlyMultiSet<G> (this);
		}
	}

	/**
	 * Returns an immutable empty set.
	 *
	 * @return an immutable empty set
	 */
	public static Set<G> empty<G> () {
		return new HashSet<G> ().read_only_view;
	}
}

