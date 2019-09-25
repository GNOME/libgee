/* readonlybidirsortedset.vala
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
 * Read-only view for {@link BidirSortedSet} collections.
 *
 * This class decorates any class which implements the {@link BidirSortedSet}
 * interface by making it read only. Any method which normally modify data will
 * throw an error.
 *
 * @see BidirSortedSet
 */
internal class Gee.ReadOnlyBidirSortedSet<G> : ReadOnlySortedSet<G>, BidirSortedSet<G> {
	/**
	 * Constructs a read-only set that mirrors the content of the specified set.
	 *
	 * @param set the set to decorate.
	 */
	public ReadOnlyBidirSortedSet (BidirSortedSet<G> set) {
		base (set);
	}

	/**
	 * {@inheritDoc}
	 */
	public Gee.BidirIterator<G> bidir_iterator () {
		return new BidirIterator<G> (((BidirSortedSet<G>) _collection).bidir_iterator ());
	}

	protected class BidirIterator<G> : Gee.ReadOnlyCollection.Iterator<G>, Gee.BidirIterator<G> {
		public BidirIterator (Gee.BidirIterator<G> iterator) {
			base (iterator);
		}

		public bool first () {
			return ((Gee.BidirIterator<G>) _iter).first ();
		}

		public bool previous () {
			return ((Gee.BidirIterator<G>) _iter).previous ();
		}

		public bool has_previous () {
			return ((Gee.BidirIterator<G>) _iter).has_previous ();
		}

		public bool last () {
			return ((Gee.BidirIterator<G>) _iter).last ();
		}
	}
}

