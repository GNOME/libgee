/* abstractlist.vala
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
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 */

/**
 * Skeletal implementation of the {@link Gee.List} interface.
 *
 * Contains common code shared by all list implementations.
 *
 * @see Gee.ArrayList
 * @see Gee.LinkedList
 */
public abstract class Gee.AbstractList<G> : Gee.AbstractCollection<G>, List<G> {

	/**
	 * @inheritDoc
	 */
	public abstract new G? get (int index);

	/**
	 * @inheritDoc
	 */
	public abstract new void set (int index, G item);

	/**
	 * @inheritDoc
	 */
	public abstract int index_of (G item);

	/**
	 * @inheritDoc
	 */
	public abstract void insert (int index, G item);

	/**
	 * @inheritDoc
	 */
	public abstract G remove_at (int index);

	/**
	 * @inheritDoc
	 */
	public abstract List<G>? slice (int start, int stop);

	/**
	 * @inheritDoc
	 */
	public virtual G? first () {
		return get (0);
	}

	/**
	 * @inheritDoc
	 */
	public virtual G? last () {
		return get (size - 1);
	}

	/**
	 * @inheritDoc
	 */
	public virtual void insert_all (int index, Collection<G> collection) {
		foreach (G item in collection) {
			insert(index, item);
			index++;
		}
	}

	/**
	 * @inheritDoc
	 */
	public void sort (CompareFunc? compare = null) {
		if (compare == null) {
			compare = Functions.get_compare_func_for (typeof (G));
		}
		TimSort.sort<G> (this, compare);
	}

	private weak List<G> _read_only_view;

	/**
	 * @inheritDoc
	 */
	public virtual new List<G> read_only_view {
		owned get {
			List<G> instance = _read_only_view;
			if (_read_only_view == null) {
				instance = new ReadOnlyList<G> (this);
				_read_only_view = instance;
				instance.add_weak_pointer (&_read_only_view);
			}
			return instance;
		}
	}
}
