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
 * Represents a read-only collection of items in a well-defined order.
 */
public class Gee.ReadOnlyList<G> : Object, Iterable<G>, Collection<G>, List<G> {
	public int size {
		get { return _list.size; }
	}

	public bool is_empty {
		get { return _list.is_empty; }
	}

	public List<G> list {
		construct { _list = value; }
	}

	private List<G> _list;

	public ReadOnlyList (List<G>? list = null) {
		this.list = list;
	}

	public Type element_type {
		get { return typeof (G); }
	}

	public Gee.Iterator<G> iterator () {
		if (_list == null) {
			return new Iterator<G> ();
		}

		return _list.iterator ();
	}

	public bool contains (G item) {
		if (_list == null) {
			return false;
		}

		return _list.contains (item);
	}

	public int index_of (G item) {
		if (_list == null) {
			return -1;
		}

		return _list.index_of (item);
	}

	public bool add (G item) {
		assert_not_reached ();
	}

	public bool remove (G item) {
		assert_not_reached ();
	}

	public void insert (int index, G item) {
		assert_not_reached ();
	}

	public void remove_at (int index) {
		assert_not_reached ();
	}

	public new G? get (int index) {
		if (_list == null) {
			return null;
		}

		return _list.get (index);
	}

	public new void set (int index, G o) {
		assert_not_reached ();
	}

	public void clear () {
		assert_not_reached ();
	}

	public List<G>? slice (int start, int stop) {
		assert_not_reached ();
	}

	public bool add_all (Collection<G> collection) {
		assert_not_reached ();
	}

	public bool contains_all (Collection<G> collection) {
		if (_list == null) {
			return false;
		}
		return _list.contains_all (collection);
	}

	public bool remove_all (Collection<G> collection) {
		assert_not_reached ();
	}

	public bool retain_all (Collection<G> collection) {
		assert_not_reached ();
	}

	public G? first () {
		if (_list == null) {
			return null;
		}

		return _list.first ();
	}

	public G? last () {
		if (_list == null) {
			return null;
		}

		return _list.last ();
	}

	public void insert_all (int index, Collection<G> collection) {
		assert_not_reached ();
	}

	public G[] to_array() {
		return _list.to_array ();
	}

	class Iterator<G> : Object, Gee.Iterator<G> {
		public bool next () {
			return false;
		}

		public new G? get () {
			return null;
		}
	}
}

