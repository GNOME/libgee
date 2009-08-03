/* readonlylist.vala
 *
 * Copyright (C) 2007-2008  Jürg Billeter
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

using GLib;

/**
 * Read-only view for {@link Gee.List} collections.
 *
 * This class decorates any class which implements the {@link Gee.List}
 * interface by making it read only. Any method which normally modify data will
 * throw an error.
 *
 * @see Gee.List
 */
public class Gee.ReadOnlyList<G> : Gee.ReadOnlyCollection<G>, List<G> {

	/**
	 * Constructs a read-only list that mirrors the content of the specified
	 * list.
	 *
	 * @param list the list to decorate (may be null).
	 */
	public ReadOnlyList (List<G>? list = null) {
		base (list);
	}

	/**
	 * @inheritDoc
	 */
	public int index_of (G item) {
		if (_collection == null) {
			return -1;
		}

		return ((Gee.List<G>) _collection).index_of (item);
	}

	/**
	 * Unimplemented method (read only list).
	 */
	public void insert (int index, G item) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only list).
	 */
	public void remove_at (int index) {
		assert_not_reached ();
	}

	/**
	 * @inheritDoc
	 */
	public new G? get (int index) {
		if (_collection == null) {
			return null;
		}

		return ((Gee.List<G>) _collection).get (index);
	}

	/**
	 * Unimplemented method (read only list).
	 */
	public new void set (int index, G o) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only list).
	 */
	public List<G>? slice (int start, int stop) {
		assert_not_reached ();
	}

	/**
	 * @inheritDoc
	 */
	public G? first () {
		if (_collection == null) {
			return null;
		}

		return ((Gee.List<G>) _collection).first ();
	}

	/**
	 * @inheritDoc
	 */
	public G? last () {
		if (_collection == null) {
			return null;
		}

		return ((Gee.List<G>) _collection).last ();
	}

	/**
	 * Unimplemented method (read only list).
	 */
	public void insert_all (int index, Collection<G> collection) {
		assert_not_reached ();
	}
}

