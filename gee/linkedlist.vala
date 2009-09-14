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
 * Doubly-linked list implementation of the {@link Gee.List} interface.
 *
 * This implementation is pretty well designed for highly mutable data. When
 * indexed access is privileged prefer using {@link Gee.ArrayList}.
 *
 * @see Gee.ArrayList
 */
public class Gee.LinkedList<G> : AbstractList<G>, Queue<G>, Deque<G> {
	private int _size = 0;
	private int _stamp = 0;
	private Node? _head = null;
	private Node? _tail = null;

	/**
	 * The elements' equality testing function.
	 */
	public EqualFunc equal_func { private set; get; }

	/**
	 * Constructs a new, empty linked list.
	 *
	 * @param equal_func an optional equality testing function.
	 */
	public LinkedList (EqualFunc? equal_func = null) {
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
	public override int size {
		get { return this._size; }
	}

	/**
	 * @inheritDoc
	 */
	public override bool contains (G item) {
		return this.index_of (item) != -1;
	}

	/**
	 * @inheritDoc
	 */
	public override bool add (G item) {
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

	/**
	 * @inheritDoc
	 */
	public override bool remove (G item) { // Should remove only the first occurence (a test should be added)
		for (Node<G> n = this._head; n != null; n = n.next) {
			if (this.equal_func (item, n.data)) {
				this._remove_node (n);
				return true;
			}
		}
		return false;
	}

	/**
	 * @inheritDoc
	 */
	public override void clear () {
		++this._stamp;
		this._head = this._tail = null;
		this._size = 0;
	}

	/**
	 * @inheritDoc
	 */
	public override G get (int index) {
		assert (index >= 0);
		assert (index < this._size);

		unowned Node<G>? n = this._get_node_at (index);
		assert (n != null);
		return n.data;
	}

	/**
	 * @inheritDoc
	 */
	public override void set (int index, G item) {
		assert (index >= 0);
		assert (index < this._size);

		unowned Node<G>? n = this._get_node_at (index);
		return_if_fail (n != null);
		n.data = item;
	}

	/**
	 * @inheritDoc
	 */
	public override int index_of (G item) {
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

	/**
	 * @inheritDoc
	 */
	public override void insert (int index, G item) {
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

	/**
	 * @inheritDoc
	 */
	public override G remove_at (int index) {
		assert (index >= 0);
		assert (index < this._size);

		unowned Node<G>? n = this._get_node_at (index);
		return_if_fail (n != null);
		G element = n.data;
		this._remove_node (n);
		return element;
	}

	/**
	 * @inheritDoc
	 */
	public override List<G>? slice (int start, int stop) {
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

	/**
	 * @inheritDoc
	 */
	public override G first () {
		assert (_size > 0);
		return _head.data;
	}

	/**
	 * @inheritDoc
	 */
	public override G last () {
		assert (_size > 0);
		return _tail.data;
	}

	/**
	 * @inheritDoc
	 */
	public int capacity {
		get { return UNBOUNDED_CAPACITY; }
	}

	/**
	 * @inheritDoc
	 */
	public int remaining_capacity {
		get { return UNBOUNDED_CAPACITY; }
	}

	/**
	 * @inheritDoc
	 */
	public bool is_full {
		get { return false; }
	}

	/**
	 * @inheritDoc
	 */
	public bool offer (G element) {
		return offer_tail (element);
	}

	/**
	 * @inheritDoc
	 */
	public G? peek () {
		return peek_head ();
	}

	/**
	 * @inheritDoc
	 */
	public G? poll () {
		return poll_head ();
	}

	/**
	 * @inheritDoc
	 */
	public int drain (Collection<G> recipient, int amount = -1) {
		return drain_head (recipient, amount);
	}

	/**
	 * @inheritDoc
	 */
	public bool offer_head (G element) {
		insert (0, element);
		return true;
	}

	/**
	 * @inheritDoc
	 */
	public G? peek_head () {
		if (this._size == 0) {
			return null;
		}
		return get (0);
	}

	/**
	 * @inheritDoc
	 */
	public G? poll_head () {
		if (this._size == 0) {
			return null;
		}
		return remove_at (0);
	}

	/**
	 * @inheritDoc
	 */
	public int drain_head (Collection<G> recipient, int amount = -1) {
		if (amount == -1) {
			amount = this._size;
		}
		for (int i = 0; i < amount; i++) {
			if (this._size == 0) {
				return i;
			}
			recipient.add (remove_at (0));
		}
		return amount;
	}

	/**
	 * @inheritDoc
	 */
	public bool offer_tail (G element) {
		return add (element);
	}

	/**
	 * @inheritDoc
	 */
	public G? peek_tail () {
		if (this._size == 0) {
			return null;
		}
		return get (_size - 1);
	}

	/**
	 * @inheritDoc
	 */
	public G? poll_tail () {
		if (this._size == 0) {
			return null;
		}
		return remove_at (_size - 1);
	}

	/**
	 * @inheritDoc
	 */
	public int drain_tail (Collection<G> recipient, int amount = -1) {
		if (amount == -1) {
			amount = this._size;
		}
		for (int i = 0; i < amount; i++) {
			if (this._size == 0) {
				return i;
			}
			recipient.add (remove_at (this._size - 1));
		}
		return amount;
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

		public new G get () {
			assert (this._stamp == this._list._stamp);
			assert (this.position != null);

			return this.position.data;
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

