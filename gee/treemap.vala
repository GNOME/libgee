/* treemap.vala
 *
 * Copyright (C) 2009  Maciej Piechotka
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
 * 	Maciej Piechotka <uzytkownik2@gmail.com>
 */

using GLib;

/**
 * Left-leaning red-black tree implementation of the {@link Gee.Map} interface.
 *
 * This implementation is especially well designed for large quantity of
 * data. The (balanced) tree implementation insure that the set and get
 * methods are in logarithmic complexity.
 *
 * @see Gee.HashMap
 */
public class Gee.TreeMap<K,V> : Gee.AbstractMap<K,V> {
	/**
	 * @inheritDoc
	 */
	public override int size {
		get { return _size; }
	}

	/**
	 * @inheritDoc
	 */
	public override Set<K> keys {
		owned get {
			return new KeySet<K,V> (this);
		}
	}

	/**
	 * @inheritDoc
	 */
	public override Collection<V> values {
		owned get {
			return new ValueCollection<K,V> (this);
		}
	}

	/**
	 * The keys' comparator function.
	 */
	public CompareFunc key_compare_func { private set; get; }

	/**
	 * The values' equality testing function.
	 */
	public EqualFunc value_equal_func { private set; get; }

	private int _size = 0;

	/**
	 * Constructs a new, empty tree map sorted according to the specified
	 * comparator function.
	 *
	 * @param key_compare_func an optional key comparator function.
	 * @param value_equal_func an optional values equality testing function.
	 */
	public TreeMap (CompareFunc? key_compare_func = null, EqualFunc? value_equal_func = null) {
		if (key_compare_func == null) {
			key_compare_func = Functions.get_compare_func_for (typeof (K));
		}
		if (value_equal_func == null) {
			value_equal_func = Functions.get_equal_func_for (typeof (V));
		}
		this.key_compare_func = key_compare_func;
		this.value_equal_func = value_equal_func;
	}

	private void rotate_right (ref Node<K, V> root) {
		Node<K,V> pivot = (owned) root.left;
		pivot.color = root.color;
		root.color = Node.Color.RED;
		root.left = (owned) pivot.right;
		pivot.right = (owned) root;
		root = (owned) pivot;
	}

	private void rotate_left (ref Node<K, V> root) {
		Node<K,V> pivot = (owned) root.right;
		pivot.color = root.color;
		root.color = Node.Color.RED;
		root.right = (owned) pivot.left;
		pivot.left = (owned) root;
		root = (owned) pivot;
	}

	private bool is_red (Node<K, V>? n) {
		return n != null && n.color == Node.Color.RED;
	}

	private bool is_black (Node<K, V>? n) {
		return n == null || n.color == Node.Color.BLACK;
	}

	/**
	 * @inheritDoc
	 */
	public override bool has_key (K key) {
		weak Node<K, V>? cur = root;
		while (cur != null) {
			int res = key_compare_func (key, cur.key);
			if (res == 0) {
				return true;
			} else if (res < 0) {
				cur = cur.left;
			} else {
				cur = cur.right;
			}
		}
		return false;
	}

	/**
	 * @inheritDoc
	 */
	public override V? get (K key) {
		weak Node<K, V>? cur = root;
		while (cur != null) {
			int res = key_compare_func (key, cur.key);
			if (res == 0) {
				return cur.value;
			} else if (res < 0) {
				cur = cur.left;
			} else {
				cur = cur.right;
			}
		}
		return null;
	}

	private void set_to_node (ref Node<K, V>? node, K key, V value, Node<K, V>? prev, Node<K, V>? next) {
		if (node == null) {
			node = new Node<K,V> (key, value, prev, next);
			if (prev == null) {
				first = node;
			}
			if (next == null) {
				last = node;
			}
			_size++;
		}

		if (is_red (node.left) && is_red (node.right)) {
			node.flip ();
		}

		int cmp = key_compare_func (key, node.key);
		if (cmp == 0) {
			node.value = value;
		} else if (cmp < 0) {
			set_to_node (ref node.left, key, value, node.prev, node);
		} else {
			set_to_node (ref node.right, key, value, node, node.next);
		}

		fix_up (ref node);
	}

	/**
	 * @inheritDoc
	 */
	public override void set (K key, V value) {
		set_to_node (ref root, key, value, null, null);
		root.color = Node.Color.BLACK;
	}

	private void move_red_left (ref Node<K, V> root) {
		root.flip ();
		if (root.right != null && is_red (root.right.left)) {
			rotate_right (ref root.right);
			rotate_left (ref root);
			root.flip ();
		}
	}

	private void move_red_right (ref Node<K, V> root) {
		root.flip ();
		if (root.left != null && is_red (root.left.left)) {
			rotate_right (ref root.right);
			root.flip ();
		}
	}

	private void fix_removal (ref Node<K,V> node, out K? key = null, out V? value) {
		Node<K,V> n = (owned) node;
		if (&key != null)
			key = (owned) n.key;
		if (&value != null)
			value = (owned) n.value;
		if (n.prev != null) {
			n.prev.next = n.next;
		} else {
			first = n.next;
		}
		if (n.next != null) {
			n.next.prev = n.prev;
		} else {
			last = n.next;
		}
		node = null;
		_size--;
	}

	private void remove_minimal (ref Node<K,V> node, out K key, out V value) {
		if (node.left == null) {
			fix_removal (ref node, out key, out value);
			return;
		}

		if (is_black (node.left) && is_black (node.left.left)) {
			move_red_left (ref node);
		}

		remove_minimal (ref node.left, out key, out value);

		fix_up (ref node);
	}

	private bool remove_from_node (ref Node<K, V>? node, K key, out V value) {
		if (node == null) {
			return false;
		} else if (key_compare_func (key, node.key) < 0) {
			weak Node<K,V> left = node.left;
			if (left == null) {
				return false;
			}
			if (is_black (left) && is_black (left.left)) {
				move_red_left (ref node);
			}
			bool r = remove_from_node (ref node.left, key, out value);
			fix_up (ref node);
			return r;
		} else {
			if (is_red (node.left)) {
				rotate_right (ref node);
			}

			weak Node<K,V> r = node.right;
			if (key_compare_func (key, node.key) == 0 && r == null) {
				fix_removal (ref node, null, out value);
				return true;
			}
			if (r == null || (is_black (r) && is_black (r.left))) {
				move_red_right (ref node);
			}
			if (key_compare_func (key, node.key) == 0) {
				value = (owned) node.value;
				remove_minimal (ref node.right, out node.key, out node.value);
				fix_up (ref node);
				return true;
			} else {
				bool re = remove_from_node (ref node.right, key, out value);
				fix_up (ref node);
				return re;
			}
		}
	}

	private void fix_up (ref Node<K,V> node) {
		if (is_black (node.left) && is_red (node.right)) {
			rotate_left (ref node);
		}
		if (is_red (node.left) && is_red (node.left.left)) {
			rotate_right (ref node);
		}
	}

	/**
	 * @inheritDoc
	 */
	public override bool unset (K key, out V? value = null) {
		V node_value;
		bool b = remove_from_node (ref root, key, out node_value);

		if (&value != null) {
			value = (owned) node_value;
		}

		if (root != null) {
			root.color = Node.Color.BLACK;
		}
		stamp++;
		return b;
	}

	/**
	 * @inheritDoc
	 */
	public override void clear () {
		root = null;
		_size = 0;
		stamp++;
	}

	[Compact]
	private class Node<K, V> {
		public enum Color {
			RED,
			BLACK;

			public Color flip () {
				if (this == RED) {
					return BLACK;
				} else {
					return RED;
				}
			}
		}

		public Node (owned K key, owned V value, Node<K,V>? prev, Node<K,V>? next) {
			this.key = (owned) key;
			this.value = (owned) value;
			this.color = Color.RED;
			this.prev = prev;
			this.next = next;
			if (prev != null) {
				prev.next = this;
			}
			if (next != null) {
				next.prev = this;
			}
		}

		public void flip () {
			color.flip ();
			if (left != null) {
				left.color = left.color.flip ();
			}
			if (right != null) {
				right.color = right.color.flip ();
			}
		}

		public K key;
		public V value;
		public Color color;
		public Node<K, V>? left;
		public Node<K, V>? right;
		public weak Node<K, V>? prev;
		public weak Node<K, V>? next;
	}

	private Node<K, V>? root = null;
	private weak Node<K, V>? first = null;
	private weak Node<K, V>? last = null;
	private int stamp = 0;

	private class KeySet<K,V> : AbstractSet<K> {
		private TreeMap<K,V> _map;

		public KeySet (TreeMap<K,V> map) {
			_map = map;
		}

		public override Iterator<K> iterator () {
			return new KeyIterator<K,V> (_map);
		}

		public override int size {
			get { return _map.size; }
		}

		public override bool add (K key) {
			assert_not_reached ();
		}

		public override void clear () {
			assert_not_reached ();
		}

		public override bool remove (K key) {
			assert_not_reached ();
		}

		public override bool contains (K key) {
			return _map.contains (key);
		}

		public override bool add_all (Collection<K> collection) {
			assert_not_reached ();
		}

		public override bool remove_all (Collection<K> collection) {
			assert_not_reached ();
		}

		public override bool retain_all (Collection<K> collection) {
			assert_not_reached ();
		}
	}

	private class ValueCollection<K,V> : AbstractCollection<V> {
		private TreeMap<K,V> _map;

		public ValueCollection (TreeMap<K,V> map) {
			_map = map;
		}

		public override Iterator<V> iterator () {
			return new ValueIterator<K,V> (_map);
		}

		public override int size {
			get { return _map.size; }
		}

		public override bool add (V key) {
			assert_not_reached ();
		}

		public override void clear () {
			assert_not_reached ();
		}

		public override bool remove (V key) {
			assert_not_reached ();
		}

		public override bool contains (V key) {
			Iterator<V> it = iterator ();
			while (it.next ()) {
				if (_map.value_equal_func (key, it.get ())) {
					return true;
				}
			}
			return false;
		}

		public override bool add_all (Collection<V> collection) {
			assert_not_reached ();
		}

		public override bool remove_all (Collection<V> collection) {
			assert_not_reached ();
		}

		public override bool retain_all (Collection<V> collection) {
			assert_not_reached ();
		}
	}

	private class KeyIterator<K,V> : Object, Gee.Iterator<K>, BidirIterator<K> {
		private TreeMap<K,V> _map;

		// concurrent modification protection
		private int stamp;

		public KeyIterator (TreeMap<K,V> map) {
			_map = map;
			stamp = _map.stamp;
		}

		public bool next () {
			assert (stamp == _map.stamp);
			if (current != null) {
				current = current.next;
			} else if (state == KeyIterator.State.BEFORE_THE_BEGIN) {
				run = true;
				current = _map.first;
			}
			return current != null;
		}

		public bool has_next () {
			assert (stamp == _map.stamp);
			return (current == null && state == KeyIterator.State.BEFORE_THE_BEGIN) ||
			       (current != null && current.next != null);
		}

		public bool first () {
			assert (stamp == _map.stamp);
			current = _map.first;
			return current != null; // on false it is null anyway
		}

		public bool previous () {
			assert (stamp == _map.stamp);
			if (current != null) {
				current = current.prev;
			} else if (state == KeyIterator.State.PAST_THE_END) {
				current = _map.last;
			}
			state = KeyIterator.State.BEFORE_THE_BEGIN;
			return current != null;
		}

		public bool has_previous () {
			assert (stamp == _map.stamp);
			return (current == null && state == KeyIterator.State.PAST_THE_END) ||
			       (current != null && current.prev != null);
		}

		public bool last () {
			assert (stamp == _map.stamp);
			current = _map.last;
			return current != null; // on false it is null anyway
		}

		public new K get () {
			assert (stamp == _map.stamp);
			assert (current != null);
			return current.key;
		}

		public void remove () {
			assert_not_reached ();
		}

		private weak Node<K, V>? current;
		private enum State {
			BEFORE_THE_BEGIN,
			PAST_THE_END
		}
		private KeyIterator.State state = KeyIterator.State.BEFORE_THE_BEGIN;
		private bool run = false;
	}

	private class ValueIterator<K,V> : Object, Gee.Iterator<V>, Gee.BidirIterator<V> {
		private TreeMap<K,V> _map;

		// concurrent modification protection
		private int stamp;

		public ValueIterator (TreeMap<K,V> map) {
			_map = map;
			stamp = _map.stamp;
		}

		public bool next () {
			assert (stamp == _map.stamp);
			if (current != null) {
				current = current.next;
			} else if (state == ValueIterator.State.BEFORE_THE_BEGIN) {
				run = true;
				current = _map.first;
			}
			return current != null;
		}

		public bool has_next () {
			assert (stamp == _map.stamp);
			return (current == null && state == ValueIterator.State.BEFORE_THE_BEGIN) ||
			       (current != null && current.next != null);
		}

		public bool first () {
			assert (stamp == _map.stamp);
			current = _map.first;
			return current != null; // on false it is null anyway
		}

		public bool previous () {
			assert (stamp == _map.stamp);
			if (current != null) {
				current = current.prev;
			} else if (state == ValueIterator.State.PAST_THE_END) {
				current = _map.last;
			}
			state = ValueIterator.State.BEFORE_THE_BEGIN;
			return current != null;
		}

		public bool has_previous () {
			assert (stamp == _map.stamp);
			return (current == null && state == ValueIterator.State.PAST_THE_END) ||
			       (current != null && current.prev != null);
		}

		public bool last () {
			assert (stamp == _map.stamp);
			current = _map.last;
			return current != null; // on false it is null anyway
		}

		public new V get () {
			assert (stamp == _map.stamp);
			assert (current != null);
			return current.value;
		}

		public void remove () {
			assert_not_reached ();
		}

		private weak Node<K, V>? current;
		private enum State {
			BEFORE_THE_BEGIN,
			PAST_THE_END
		}
		private ValueIterator.State state = ValueIterator.State.BEFORE_THE_BEGIN;
		private bool run = false;
	}
}
