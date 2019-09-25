/* readonlybidirsortedmap.vala
 *
 * Copyright (C) 2012  Maciej Piechotka
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

/**
 * Read-only view for {@link BidirSortedMap} collections.
 *
 * This class decorates any class which implements the {@link BidirSortedMap}
 * interface by making it read only. Any method which normally modify data will
 * throw an error.
 *
 * @see BidirSortedMap
 */
internal class Gee.ReadOnlyBidirSortedMap<K,V> : ReadOnlySortedMap<K,V>, BidirSortedMap<K,V> {
	/**
	 * Constructs a read-only map that mirrors the content of the specified map.
	 *
	 * @param set the set to decorate.
	 */
	public ReadOnlyBidirSortedMap (BidirSortedMap<K,V> map) {
		base (map);
	}

	/**
	 * {@inheritDoc}
	 */
	public Gee.BidirMapIterator<K,V> bidir_map_iterator () {
		return new BidirMapIterator<K,V> (((BidirSortedMap<K,V>) _map).bidir_map_iterator ());
	}

	/**
	 * {@inheritDoc}
	 */
	public new BidirSortedMap<K,V> read_only_view {
		owned get {
			return this;
		}
	}

	protected class BidirMapIterator<K,V> : Gee.ReadOnlyMap.MapIterator<K,V>, Gee.BidirMapIterator<K,V> {
		public BidirMapIterator (Gee.BidirMapIterator<K,V> iterator) {
			base (iterator);
		}

		public bool first () {
			return ((Gee.BidirMapIterator<K,V>) _iter).first ();
		}

		public bool previous () {
			return ((Gee.BidirMapIterator<K,V>) _iter).previous ();
		}

		public bool has_previous () {
			return ((Gee.BidirMapIterator<K,V>) _iter).has_previous ();
		}

		public bool last () {
			return ((Gee.BidirMapIterator<K,V>) _iter).last ();
		}
	}
}

