/* hashmultiset.vala
 *
 * Copyright (C) 2009  Ali Sabil
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
 * 	Ali Sabil <ali.sabil@gmail.com>
 */

/**
 * A hash based implementation of the {@link Gee.MultiSet} interface.
 */
public class Gee.HashMultiSet<G> : AbstractCollection<G>, MultiSet<G> {
	public override int size {
		get { return _nitems; }
	}

	public HashFunc hash_func {
		get { return _items.key_hash_func; }
	}

	public EqualFunc equal_func {
		get { return _items.key_equal_func; }
	}

	private HashMap<G, int> _items;
	private int _nitems = 0;

	/**
	 * Constructs a new, empty hash multi set.
	 */
	public HashMultiSet (HashFunc? hash_func = null, EqualFunc? equal_func = null) {
		this._items = new HashMap<G, int> (hash_func, equal_func, int_equal);
	}

	public int count (G item) {
		int result = 0;
		if (_items.contains (item)) {
			result = _items.get (item);
		}
		return result;
	}

	public override bool contains (G item) {
		return _items.contains (item);
	}

	public override Gee.Iterator<G> iterator () {
		return new Iterator<G> (this);
	}

	public override bool add (G item) {
		if (_items.contains (item)) {
			int current_count = _items.get (item);
			_items.set (item, current_count + 1);
		} else {
			_items.set (item, 1);
		}
		_nitems++;
		return true;
	}

	public override bool remove (G item) {
		if (_nitems > 0 && _items.contains (item)) {
			int current_count = _items.get (item);
			if (current_count <= 1) {
				_items.remove (item);
			} else {
				_items.set (item, current_count - 1);
			}
			_nitems--;
			return true;
		}
		return false;
	}

	public override void clear () {
		_items.clear ();
		_nitems = 0;
	}

	private class Iterator<G> : Object, Gee.Iterator<G> {
		private HashMultiSet<G> _set;

		private MapIterator<G, int> _iter;
		private int _pending = 0;
		private bool _removed = false;

		public Iterator (HashMultiSet<G> set) {
			_set = set;
			_iter = _set._items.map_iterator ();
		}

		public bool next () {
			_removed = false;
			if (_pending == 0) {
				if (_iter.next ()) {
					_pending = _iter.get_value () - 1;
					return true;
				}
			} else {
				_pending--;
				return true;
			}
			return false;
		}

		public bool has_next () {
			return _pending > 0 || _iter.has_next ();
		}

		public bool first () {
			if (_set._nitems == 0) {
				return false;
			}
			_pending = 0;
			if (_iter.first ()) {
				_pending = _iter.get_value () - 1;
			}
			return true;
		}

		public new G get () {
			assert (! _removed);
			return _iter.get_key ();
		}

		public void remove () {
			assert (! _removed);
			_iter.set_value (_pending = _iter.get_value () - 1);
			if (_pending == 0) {
				_iter.unset ();
			}
			_removed = true;
		}
	}
}
