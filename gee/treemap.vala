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
 * Left-leaning red-black tree implementation of the Map interface.
 */
public class Gee.TreeMap<K,V> : Object, Map<K,V> {
	public int size {
		get { return _size; }
	}

	public CompareFunc key_compare_func { construct; get; }
	public EqualFunc value_equal_func { construct; get; }

	private int _size = 0;

	public TreeMap (CompareFunc key_compare_func = Gee.direct_compare, EqualFunc value_equal_func = GLib.direct_equal) {
		this.key_compare_func = key_compare_func;
		this.value_equal_func = value_equal_func;
	}

	public Set<K> get_keys () {
		return new KeySet<K,V> (this);
	}

	public Collection<V> get_values () {
		return new ValueCollection<K,V> (this);
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

	public bool contains (K key) {
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

	public new V? get (K key) {
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

	public new void set (K key, V value) {
		set_to_node (ref root, key, value, null, null);
		root.color = Node.Color.BLACK;
	}

	private void move_red_left (ref Node<K, V> root) {
		root.flip ();
		if (is_red (root.right.left)) {
			rotate_right (ref root.right);
			rotate_left (ref root);
			root.flip ();
		}
	}

	private void move_red_right (ref Node<K, V> root) {
		root.flip ();
		if (is_red (root.left.left)) {
			rotate_right (ref root.right);
			root.flip ();
		}
	}

	private void remove_minimal (ref Node<K,V> node, out K key, out V value) {
		if (node.left == null) {
			Node<K,V> n = (owned) node;
			key = (owned) n.key;
			value = (owned) n.value;
			node = null;
			return;
		}

		if (is_black (node.left) && is_black (node.left.left)) {
			move_red_left (ref node);
		}

		remove_minimal (ref node.left, out key, out value);

		fix_up (ref node);
	}

	private bool remove_from_node (ref Node<K, V>? node, K key) {
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
			bool r = remove_from_node (ref node.left, key);
			fix_up (ref node);
			return r;
		} else {
			if (is_red (node.left)) {
				rotate_right (ref node);
			}
	
			weak Node<K,V> r = node.right;
			if (key_compare_func (key, node.key) == 0 && r == null) {
				node = null;
				_size--;
				return true;
			}
			if (is_black (r) && is_black (r.left)) {
				move_red_right (ref node);
			}
			if (key_compare_func (key, node.key) == 0) {
				remove_minimal (ref node.right, out node.key, out node.value);
				fix_up (ref node);
				_size--;
				return true;
			} else {
				bool re = remove_from_node (ref node.right, key);
				fix_up (ref node);
				return re;
			}
		}
	}

	private void fix_up (ref Node<K,V> node) {
		if (is_black (node.left) && is_red (node.right)) {
			rotate_left (ref node);
		}
		if (is_red (node.left) && is_black (node.right)) {
			rotate_right (ref node);
		}
	}

	public bool remove (K key) {
		bool b = remove_from_node (ref root, key);
		if (root != null) {
			root.color = Node.Color.BLACK;
		}
		stamp++;
		return b;
	}

	public void clear () {
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

		~Node () {
			if (prev != null) {
				prev.next = this.next;
			}
			if (next != null) {
				next.prev = this.prev;
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

	private Node<K, V>? root;
	private weak Node<K, V>? first;
	private int stamp = 0;

	private class KeySet<K,V> : AbstractCollection<K>, Iterable<K>, Collection<K>, Set<K> {
		public TreeMap<K,V> map { construct; get; }

		public KeySet (TreeMap<K,V> map) {
			this.map = map;
		}

		public override Iterator<K> iterator () {
			return new KeyIterator<K,V> (map);
		}

		public override int size {
			get { return map.size; }
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
			return map.contains (key);
		}
	}

	private class ValueCollection<K,V> : AbstractCollection<V>, Iterable<V>, Collection<V> {
		public TreeMap<K,V> map { construct; get; }

		public ValueCollection (TreeMap map) {
			this.map = map;
		}

		public override Iterator<V> iterator () {
			return new ValueIterator<K,V> (map);
		}

		public override int size {
			get { return map.size; }
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
				if (map.value_equal_func (key, it.get ())) {
					return true;
				}
			}
			return false;
		}
	}

	private class KeyIterator<K,V> : Object, Gee.Iterator<K> {
		public TreeMap<K,V> map { construct; get; }
		private int stamp;
		construct {
			stamp = map.stamp;
		}

		public KeyIterator (TreeMap<K,V> map) {
			this.map = map;
		}

		public bool next () {
			if (current != null) {
				current = current.next;
				return current != null;
			} else if (!run){
				run = true;
				current = map.first;
				return current != null;
			} else {
				return false;
			}
		}

		public new K? get () {
			assert (stamp == map.stamp);
			assert (current != null);
			return current.key;
		}

		private weak Node<K, V>? current;
		private bool run = false;
	}

	private class ValueIterator<K,V> : Object, Gee.Iterator<V> {
		public TreeMap<K,V> map { construct; get; }
		private int stamp;
		construct {
			stamp = map.stamp;
		}

		public ValueIterator (TreeMap<K,V> map) {
			this.map = map;
		}

		public bool next () {
			if (current != null) {
				current = current.next;
				return current != null;
			} else if (!run) {
				run = true;
				current = map.first;
				return current != null;
			} else {
				return false;
			}
		}

		public new V? get () {
			assert (stamp == map.stamp);
			assert (current != null);
			return current.value;
		}

		private weak Node<K, V>? current;
		private bool run = false;
	}
}
