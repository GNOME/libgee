/* linkedlist.vala
 *
 * Copyright (C) 2004-2005  Novell, Inc
 * Copyright (C) 2005  David Waite
 * Copyright (C) 2007-2008  Jürg Billeter
 * Copyright (C) 2009  Mark Lee
 * Copyright (C) 2009  Julien Fontanet
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
 * 	Mark Lee <marklee@src.gnome.org>
 */

/**
 * A Gee.List implementation, using a doubly-linked list.
 */
public class Gee.LinkedList<G> : Object, Iterable<G>, Collection<G>, List<G> {
	private int _size = 0;
	private int _stamp = 0;
	private Node? _head = null;
	private Node? _tail = null;

	public EqualFunc equal_func { construct; get; }

	public LinkedList (EqualFunc equal_func = direct_equal) {
		this.equal_func = equal_func;
	}

	// Iterable<G>
	public Type get_element_type () {
		return typeof (G);
	}

	public Gee.Iterator<G> iterator () {
		return new Iterator<G> (this);
	}

	// Collection<G>
	public int size {
		get { return this._size; }
	}

	public bool contains (G item) {
		return this.index_of (item) != -1;
	}

	public bool add (G item) {
		Node<G> n = new Node<G> (item);
		if (this._head == null && this._tail == null) {
			this._head = this._tail = n;
		} else {
			this._tail.next = n;
			n.prev = this._tail;
			this._tail = n;
		}

		// Adding items to the list during iterations is allowed.
		//++this._stamp;

		this._size++;
		return true;
	}

	public bool remove (G item) { // Should remove only the first occurence (a test should be added)
		for (Node<G> n = this._head; n != null; n = n.next) {
			if (this.equal_func (item, n.data)) {
				this._remove_node (n);
				return true;
			}
		}
		return false;
	}

	public void clear () {
		++this._stamp;
		this._head = this._tail = null;
		this._size = 0;
	}

	// List<G>
	public new G? get (int index) {
		assert (index >= 0);
		assert (index < this._size);

		unowned Node<G>? n = this._get_node_at (index);
		if (n == null) {
			return null;
		} else {
			return n.data;
		}
	}

	public new void set (int index, G item) {
		assert (index >= 0);
		assert (index < this._size);

		unowned Node<G>? n = this._get_node_at (index);
		return_if_fail (n != null);
		n.data = item;
	}

	public int index_of (G item) {
		int result = -1;
		int idx = 0;
		foreach (G node_item in this) {
			if (this.equal_func (item, node_item)) {
				result = idx;
				break;
			} else {
				idx++;
			}
		}
		return result;
	}

	public void insert (int index, G item) {
		assert (index >= 0);
		assert (index <= this._size);

		if (index == this._size) {
			this.add (item);
		} else {
			Node<G> n = new Node<G> (item);
			if (index == 0) {
				n.next = this._head;
				this._head.prev = n;
				this._head = (owned)n;
			} else {
				Node prev = this._head;
				for (int i = 0; i < index - 1; i++) {
					prev = prev.next;
				}
				n.prev = prev;
				n.next = prev.next;
				n.next.prev = n;
				prev.next = n;
			}

			// Adding items to the list during iterations is allowed.
			//++this._stamp;

			this._size++;
		}
	}

	public void remove_at (int index) {
		assert (index >= 0);
		assert (index < this._size);

		unowned Node<G>? n = this._get_node_at (index);
		return_if_fail (n != null);
		this._remove_node (n);
	}

	public List<G>? slice (int start, int stop) {
		return_val_if_fail (start <= stop, null);
		return_val_if_fail (start >= 0, null);
		return_val_if_fail (stop <= this._size, null);

		List<G> slice = new LinkedList<G> (this.equal_func);
		Node<G> n = this._get_node_at (start);
		for (int i = start; i < stop; i++) {
			slice.add (n.data);
			n = n.next;
		}

		return slice;
	}

	private class Node<G> { // Maybe a compact class should be used?
		public G data;
		public Node<G>? prev = null;
		public Node<G>? next = null;
		public Node (G data) {
			this.data = data;
		}
	}

	private class Iterator<G> : Object, Gee.Iterator<G> {
		private bool started = false;
		private unowned Node<G>? position;
		private int _stamp;
		private LinkedList<G> _list;

		public Iterator (LinkedList<G> list) {
			this._list = list;
			this.position = list._head;
			this._stamp = list._stamp;
		}

		public bool next () {
			assert (this._stamp == this._list._stamp);

			if (!this.started) {
				this.started = true;
				return this.position != null;
			} else if (this.position.next == null) {
				return false;
			} else {
				this.position = this.position.next;
				return true;
			}
		}

		public new G? get () {
			assert (this._stamp == this._list._stamp);

			if (this.position == null) {
				return null;
			} else {
				return this.position.data;
			}
		}
	}

	private unowned Node<G>? _get_node_at (int index) {
		unowned Node<G>? n = null;;
		if (index == 0) {
			n = this._head;
		} else if (index == this._size - 1) {
			n = this._tail;
		} else if (index <= this._size / 2) {
			n = this._head;
			for (int i = 0; index != i; i++) {
				n = n.next;
			}
		} else {
			n = this._tail;
			for (int i = this._size - 1; index != i; i--) {
				n = n.prev;
			}
		}
		return n;
	}

	private void _remove_node (owned Node<G> n) {
		if (n == this._head) {
			this._head = n.next;
		}
		if (n == this._tail) {
			this._tail = n.prev;
		}
		if (n.prev != null) {
			n.prev.next = n.next;
		}
		if (n.next != null) {
			n.next.prev = n.prev;
		}
		n.prev = null;
		n.next = null;
		++this._stamp;
		this._size--;
	}
}

