/* collection.vala
 *
 * Copyright (C) 2007-2009  Jürg Billeter
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
 */

/**
 * A generic collection of objects.
 */
public interface Gee.Collection<G> : Iterable<G> {
	/**
	 * The number of items in this collection.
	 */
	public abstract int size { get; }

	/**
	 * Specifies whether this collection is empty.
	 */
	public abstract bool is_empty { get; }
	
	/**
	 * Specifies whether this collection can change - i.e. wheather {@link add},
	 * {@link remove} etc. are legal operations.
	 */
	public abstract bool read_only { get; }

	/**
	 * Determines whether this collection contains the specified item.
	 *
	 * @param item the item to locate in the collection
	 *
	 * @return     `true` if item is found, `false` otherwise
	 */
	public abstract bool contains (G item);

	/**
	 * Adds an item to this collection. Must not be called on read-only
	 * collections.
	 *
	 * @param item the item to add to the collection
	 *
	 * @return     `true` if the collection has been changed, `false` otherwise
	 */
	public abstract bool add (G item);

	/**
	 * Removes the first occurence of an item from this collection. Must not
	 * be called on read-only collections.
	 *
	 * @param item the item to remove from the collection
	 *
	 * @return     `true` if the collection has been changed, `false` otherwise
	 */
	public abstract bool remove (G item);

	/**
	 * Removes all items from this collection. Must not be called on
	 * read-only collections.
	 */
	public abstract void clear ();

	/**
	 * Adds all items in the input collection to this collection.
	 *
	 * @param collection the collection which items will be added to this
	 *                   collection.
	 *
	 * @return     `true` if the collection has been changed, `false` otherwise
	 */
	public abstract bool add_all (Collection<G> collection);

	/**
	 * Returns `true` it this collection contains all items as the input
	 * collection.
	 *
	 * @param collection the collection which items will be compared with
	 *                   this collection.
	 *
	 * @return     `true` if the collection has been changed, `false` otherwise
	 */
	public abstract bool contains_all (Collection<G> collection);

	/**
	 * Removes the subset of items in this collection corresponding to the
	 * elments in the input collection. If there is several occurrences of
	 * the same value in this collection they are decremented of the number
	 * of occurrences in the input collection.
	 *
	 * @param collection the collection which items will be compared with
	 *                   this collection.
	 *
	 * @return     `true` if the collection has been changed, `false` otherwise
	 */
	public abstract bool remove_all (Collection<G> collection);

	/**
	 * Removes all items in this collection that are not contained in the input
	 * collection. In other words all common items of both collections are
	 * retained in this collection.
	 *
	 * @param collection the collection which items will be compared with
	 *                   this collection.
	 *
	 * @return     `true` if the collection has been changed, `false` otherwise
	 */
	public abstract bool retain_all (Collection<G> collection);

	/**
	 * Returns an array containing all of items from this collection.
	 *
	 * @return an array containing all of items from this collection
	 */
	public abstract G[] to_array();

	/**
	 * The read-only view of this collection.
	 */
	public abstract Collection<G> read_only_view { owned get; }

	/**
	 * Returns an immutable empty collection.
	 *
	 * @return an immutable empty collection
	 */
	public static Collection<G> empty<G> () {
		return new HashSet<G> ().read_only_view;
	}
}

