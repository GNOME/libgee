/* readonlyset.vala
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
 * Represents a read-only collection of items without duplicates.
 */
public class Gee.ReadOnlySet<G> : Object, Iterable<G>, Collection<G>, Set<G> {

	/**
	 * @inheritDoc
	 */
	public int size {
		get { return _set.size; }
	}

	/**
	 * @inheritDoc
	 */
	public bool is_empty {
		get { return _set.is_empty; }
	}

	/**
	 * @inheritDoc
	 */
	public new Set<G> set {
		construct { _set = value; }
	}

	private Set<G> _set;

	/**
	 * Read only set implementation constructor.
	 *
	 * @param set the set to decorate.
	 */
	public ReadOnlySet (Set<G>? set = null) {
		this.set = set;
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
		if (_set == null) {
			return new Iterator<G> ();
		}

		return _set.iterator ();
	}

	/**
	 * @inheritDoc
	 */
	public bool contains (G item) {
		if (_set == null) {
			return false;
		}

		return _set.contains (item);
	}

	/**
	 * Unimplemented method (read only set).
	 */
	public bool add (G item) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only set).
	 */
	public bool remove (G item) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only set).
	 */
	public void clear () {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only set).
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
	 * Unimplemented method (read only set).
	 */
	public bool remove_all (Collection<G> collection) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only set).
	 */
	public bool retain_all (Collection<G> collection) {
		assert_not_reached ();
	}

	/**
	 * @inheritDoc
	 */
	public G[] to_array() {
		return _set.to_array ();
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

