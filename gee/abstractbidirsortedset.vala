/* abstractbidirsortedset.vala
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
 * Skeletal implementation of the {@link BidirSortedSet} interface.
 *
 * Contains common code shared by all set implementations.
 *
 * @see TreeSet
 */
public abstract class Gee.AbstractBidirSortedSet<G> : Gee.AbstractSortedSet<G>, BidirSortedSet<G> {
	/**
	 * {@inheritDoc}
	 */
	public abstract BidirIterator<G> bidir_iterator ();

	private weak BidirSortedSet<G> _read_only_view;

	/**
	 * {@inheritDoc}
	 */
	public virtual new BidirSortedSet<G> read_only_view {
		owned get {
			BidirSortedSet<G> instance = _read_only_view;
			if (_read_only_view == null) {
				instance = new ReadOnlyBidirSortedSet<G> (this);
				_read_only_view = instance;
				instance.add_weak_pointer ((void**) (&_read_only_view));
			}
			return instance;
		}
	}

	// Future-proofing
	internal virtual void reserved0() {}
	internal virtual void reserved1() {}
	internal virtual void reserved2() {}
	internal virtual void reserved3() {}
	internal virtual void reserved4() {}
	internal virtual void reserved5() {}
	internal virtual void reserved6() {}
	internal virtual void reserved7() {}
	internal virtual void reserved8() {}
	internal virtual void reserved9() {}
}

