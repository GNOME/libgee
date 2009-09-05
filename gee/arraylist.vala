/* arraylist.vala
 *
 * Copyright (C) 2004-2005  Novell, Inc
 * Copyright (C) 2005  David Waite
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
 * Resizable array implementation of the {@link Gee.List} interface.
 *
 * The storage array grows automatically when needed.
 *
 * This implementation is pretty good for rarely modified data. Because they are
 * stored in an array this structure does not fit for highly mutable data. For an
 * alternative implementation see {@link Gee.LinkedList}.
 *
 * @see Gee.LinkedList
 */
public class Gee.ArrayList<G> : AbstractList<G> {
	/**
	 * @inheritDoc
	 */
	public override int size {
		get { return _size; }
	}

	/**
	 * The elements' equality testing function.
	 */
	public EqualFunc equal_func { private set; get; }

	private G[] _items = new G[4];
	private int _size;

	// concurrent modification protection
	private int _stamp = 0;

	/**
	 * Constructs a new, empty array list.
	 *
	 * @param equal_func an optional elements equality testing function.
	 */
	public ArrayList (EqualFunc? equal_func = null) {
		if (equal_func == null) {
			equal_func = Functions.get_equal_func_for (typeof (G));
		}
		this.equal_func = equal_func;
	}

	/**
	 * @inheritDoc
	 */
	public override Gee.Iterator<G> iterator () {
		return new Iterator<G> (this);
	}

	/**
	 * @inheritDoc
	 */
	public override bool contains (G item) {
		return (index_of (item) != -1);
	}

	/**
	 * @inheritDoc
	 */
	public override int index_of (G item) {
		for (int index = 0; index < _size; index++) {
			if (equal_func (_items[index], item)) {
				return index;
			}
		}
		return -1;
	}

	/**
	 * @inheritDoc
	 */
	public override G? get (int index) {
		assert (index >= 0);
		assert (index < _size);

		return _items[index];
	}

	/**
	 * @inheritDoc
	 */
	public override void set (int index, G item) {
		assert (index >= 0);
		assert (index < _size);

		_items[index] = item;
	}

	/**
	 * @inheritDoc
	 */
	public override bool add (G item) {
		if (_size == _items.length) {
			grow_if_needed (1);
		}
		_items[_size++] = item;
		_stamp++;
		return true;
	}

	/**
	 * @inheritDoc
	 */
	public override void insert (int index, G item) {
		assert (index >= 0);
		assert (index <= _size);

		if (_size == _items.length) {
			grow_if_needed (1);
		}
		shift (index, 1);
		_items[index] = item;
		_stamp++;
	}

	/**
	 * @inheritDoc
	 */
	public override bool remove (G item) {
		for (int index = 0; index < _size; index++) {
			if (equal_func (_items[index], item)) {
				remove_at (index);
				return true;
			}
		}
		return false;
	}

	/**
	 * @inheritDoc
	 */
	public override void remove_at (int index) {
		assert (index >= 0);
		assert (index < _size);

		_items[index] = null;

		shift (index + 1, -1);

		_stamp++;
	}

	/**
	 * @inheritDoc
	 */
	public override void clear () {
		for (int index = 0; index < _size; index++) {
			_items[index] = null;
		}
		_size = 0;
		_stamp++;
	}

	/**
	 * @inheritDoc
	 */
	public override List<G>? slice (int start, int stop) {
		return_val_if_fail (start <= stop, null);
		return_val_if_fail (start >= 0, null);
		return_val_if_fail (stop <= _size, null);

		var slice = new ArrayList<G> (this.equal_func);
		for (int i = start; i < stop; i++) {
			slice.add (this[i]);
		}

		return slice;
	}

	/**
	 * @inheritDoc
	 */
	public override bool add_all (Collection<G> collection) {
		if (collection.is_empty) {
			return false;
		}

		grow_if_needed (collection.size);
		foreach (G item in collection) {
			_items[_size++] = item;
		}
		_stamp++;
		return true;
	}

	/**
	 * @inheritDoc
	 */
	public override bool remove_all (Collection<G> collection) {
		bool changed = false;
		for (int index = 0; index < _size; index++) {
			if (collection.contains (_items[index])) {
				remove_at (index);
				index--;
				changed = true;
			}
		}
		return changed;
	}

	/**
	 * @inheritDoc
	 */
	public override bool retain_all (Collection<G> collection) {
		bool changed = false;
		for (int index = 0; index < _size; index++) {
			if (!collection.contains (_items[index])) {
				remove_at (index);
				index--;
				changed = true;
			}
		}
		return changed;
	}

	private void shift (int start, int delta) {
		assert (start >= 0);
		assert (start <= _size);
		assert (start >= -delta);

		_items.move (start, start + delta, _size - start);

		_size += delta;
	}

	private void grow_if_needed (int new_count) {
		assert (new_count >= 0);

		int minimum_size = _size + new_count;
		if (minimum_size > _items.length) {
			// double the capacity unless we add even more items at this time
			set_capacity (new_count > _items.length ? minimum_size : 2 * _items.length);
		}
	}

	private void set_capacity (int value) {
		assert (value >= _size);

		_items.resize (value);
	}

	private class Iterator<G> : Object, Gee.Iterator<G> {
		public ArrayList<G> list {
			construct {
				_list = value;
				_stamp = _list._stamp;
			}
		}

		private ArrayList<G> _list;
		private int _index = -1;

		// concurrent modification protection
		private int _stamp = 0;

		public Iterator (ArrayList list) {
			this.list = list;
		}

		public bool next () {
			assert (_stamp == _list._stamp);
			if (_index < _list._size) {
				_index++;
			}
			return (_index < _list._size);
		}

		public new G? get () {
			assert (_stamp == _list._stamp);

			if (_index < 0 || _index >= _list._size) {
				return null;
			}

			return _list.get (_index);
		}
	}
}

