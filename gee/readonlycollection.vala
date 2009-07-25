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
 * Represents a read-only collection of items.
 */
public class Gee.ReadOnlyCollection<G> : Object, Iterable<G>, Collection<G> {
	public int size {
		get { return _collection.size; }
	}

	public bool is_empty {
		get { return _collection.is_empty; }
	}

	public Collection<G> collection {
		construct { _collection = value; }
	}

	private Collection<G> _collection;

	public ReadOnlyCollection (Collection<G>? collection = null) {
		this.collection = collection;
	}

	public Type element_type {
		get { return typeof (G); }
	}

	public Gee.Iterator<G> iterator () {
		if (_collection == null) {
			return new Iterator<G> ();
		}

		return _collection.iterator ();
	}

	public bool contains (G item) {
		if (_collection == null) {
			return false;
		}

		return _collection.contains (item);
	}

	public bool add (G item) {
		assert_not_reached ();
	}

	public bool remove (G item) {
		assert_not_reached ();
	}

	public void clear () {
		assert_not_reached ();
	}

	public bool add_all (Collection<G> collection) {
		assert_not_reached ();
	}

	public bool contains_all (Collection<G> collection) {
		foreach (G element in collection) {
			if (!contains (element)) {
				return false;
			}
		}
		return true;
	}

	public bool remove_all (Collection<G> collection) {
		assert_not_reached ();
	}

	public bool retain_all(Collection<G> collection) {
		assert_not_reached ();
	}

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

