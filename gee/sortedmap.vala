/* sortedset.vala
 *
 * Copyright (C) 2009-2011  Maciej Piechotka
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

public interface Gee.SortedMap<K,V> : Gee.Map<K,V> {
	/**
	 * Returns map containing pairs with key strictly lower the the argument.
	 */
	public abstract SortedMap<K,V> head_map (K before);
	/**
	 * Returns map containing pairs with key equal or larger then the argument.
	 */
	public abstract SortedMap<K,V> tail_map (K after);
	/**
	 * Returns right-open map (i.e. containing all pair which key is strictly
	 * lower then the second argument and equal or bigger then the first one).
	 *
	 * Null as one parameter means that it should include all from this side.
	 */
	public abstract SortedMap<K,V> sub_map (K before, K after);
	/**
	 * Returns the keys in ascending order.
	 */
	public abstract SortedSet<K> ascending_keys { owned get; }
	/**
	 * Returns the entries in ascending order.
	 */
	public abstract SortedSet<Map.Entry<K,V>> ascending_entries { owned get; }
	/**
	 * Returns a bi-directional iterator for this map.
	 *
	 * @return a bi-directional map iterator
	 */
	public abstract BidirMapIterator<K,V> bidir_map_iterator ();
}

