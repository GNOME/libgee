/* abstractset.vala
 *
 * Copyright (C) 2007  Jürg Billeter
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
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

/**
 * Skeletal implementation of the {@link Set} interface.
 *
 * Contains common code shared by all set implementations.
 *
 * @see HashSet
 * @see TreeSet
 */
public abstract class Gee.AbstractSet<G> : Gee.AbstractCollection<G>, Set<G> {

	private WeakRef _read_only_view;
	construct {
		_read_only_view = WeakRef(null);
	}

	/**
	 * {@inheritDoc}
	 */
	public virtual new Set<G> read_only_view {
		owned get {
			Set<G>? instance = (Set<G>?)_read_only_view.get ();
			if (instance == null) {
				instance = new ReadOnlySet<G> (this);
				_read_only_view.set (instance);
			}
			return instance;
		}
	}

	// Future-proofing
	internal new virtual void reserved0() {}
	internal new virtual void reserved1() {}
	internal new virtual void reserved2() {}
	internal new virtual void reserved3() {}
	internal new virtual void reserved4() {}
	internal new virtual void reserved5() {}
	internal new virtual void reserved6() {}
	internal new virtual void reserved7() {}
	internal new virtual void reserved8() {}
	internal new virtual void reserved9() {}
}
