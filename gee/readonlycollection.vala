/* readonlycollection.vala
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
 * Read-only view for {@link Gee.Collection} collections.
 *
 * This class decorates any class which implements the {@link Gee.Collection}
 * interface by making it read only. Any method which normally modify data will
 * throw an error.
 *
 * @see Gee.Collection
 */
public class Gee.ReadOnlyCollection<G> : Object, Iterable<G>, Collection<G> {

	/**
	 * @inheritDoc
	 */
	public int size {
		get { return _collection.size; }
	}

	/**
	 * @inheritDoc
	 */
	public bool is_empty {
		get { return _collection.is_empty; }
	}

	/**
	 * The decorated collection.
	 */
	public Collection<G> collection {
		construct { _collection = value; }
	}

	private Collection<G> _collection;

	/**
	 * Constructs a read-only collection that mirrors the content of the
	 * specified collection.
	 *
	 * @param collection the collection to decorate (may be null).
	 */
	public ReadOnlyCollection (Collection<G>? collection = null) {
		this.collection = collection;
	}

	/**
	 * @inheritDoc
	 */
	public Type element_type {
		get { return typeof (G); }
	}

	/**
	 * @inheritDoc
	 */
	public Gee.Iterator<G> iterator () {
		if (_collection == null) {
			return new Iterator<G> ();
		}

		return _collection.iterator ();
	}

	/**
	 * @inheritDoc
	 */
	public bool contains (G item) {
		if (_collection == null) {
			return false;
		}

		return _collection.contains (item);
	}

	/**
	 * Unimplemented method (read only collection).
	 */
	public bool add (G item) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only collection).
	 */
	public bool remove (G item) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only collection).
	 */
	public void clear () {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only collection).
	 */
	public bool add_all (Collection<G> collection) {
		assert_not_reached ();
	}

	/**
	 * @inheritDoc
	 */
	public bool contains_all (Collection<G> collection) {
		foreach (G element in collection) {
			if (!contains (element)) {
				return false;
			}
		}
		return true;
	}

	/**
	 * Unimplemented method (read only collection).
	 */
	public bool remove_all (Collection<G> collection) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only collection).
	 */
	public bool retain_all(Collection<G> collection) {
		assert_not_reached ();
	}

	/**
	 * @inheritDoc
	 */
	public G[] to_array() {
		return _collection.to_array ();
	}

	private class Iterator<G> : Object, Gee.Iterator<G> {
		public bool next () {
			return false;
		}

		public new G? get () {
			return null;
		}
	}
}

