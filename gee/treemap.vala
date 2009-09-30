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
 * Left-leaning red-black tree implementation of the {@link Map} interface.
 *
 * This implementation is especially well designed for large quantity of
 * data. The (balanced) tree implementation insure that the set and get
 * methods are in logarithmic complexity.
 *
 * @see HashMap
 */
public class Gee.TreeMap<K,V> : Gee.AbstractMap<K,V> {
	/**
	 * {@inheritDoc}
	 */
	public override int size {
		get { return _size; }
	}
	
	public override bool read_only {
		get { return false; }
	}

	/**
	 * {@inheritDoc}
	 */
	public override Set<K> keys {
		owned get {
			Set<K> keys = _keys;
			if (_keys == null) {
				keys = new KeySet<K,V> (this);
				_keys = keys;
				keys.add_weak_pointer ((void**) (&_keys));
			}
			return keys;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public override Collection<V> values {
		owned get {
			Collection<K> values = _values;
			if (_values == null) {
				values = new ValueCollection<K,V> (this);
				_values = values;
				values.add_weak_pointer ((void**) (&_values));
			}
			return values;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public override Set<Map.Entry<K,V>> entries {
		owned get {
			Set<Map.Entry<K,V>> entries = _entries;
			if (_entries == null) {
				entries = new EntrySet<K,V> (this);
				_entries = entries;
				entries.add_weak_pointer ((void**) (&_entries));
			}
			return entries;
		}
	}

	/**
	 * The keys' comparator function.
	 */
	public CompareDataFunc key_compare_func { private set; get; }

	/**
	 * The values' equality testing function.
	 */
	public EqualDataFunc value_equal_func { private set; get; }

	private int _size = 0;

	private weak Set<K> _keys;
	private weak Collection<V> _values;
	private weak Set<Map.Entry<K,V>> _entries;

	/**
	 * Constructs a new, empty tree map sorted according to the specified
	 * comparator function.
	 *
	 * If not provided, the functions parameters are requested to the
	 * {@link Functions} function factory methods.
	 *
	 * @param key_compare_func an optional key comparator function
	 * @param value_equal_func an optional values equality testing function
	 */
	public TreeMap (owned CompareDataFunc? key_compare_func = null, owned EqualDataFunc? value_equal_func = null) {
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
	 * {@inheritDoc}
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
	 * {@inheritDoc}
	 */
	public override bool has (K key, V value) {
		V? own_value = get (key);
		return (own_value != null && value_equal_func (own_value, value));
	}

	/**
	 * {@inheritDoc}
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

	private bool set_to_node (ref Node<K, V>? node, K key, V value, out V old_value, Node<K, V>? prev, Node<K, V>? next) {
		if (node == null) {
			node = new Node<K,V> (key, value, prev, next);
			if (prev == null) {
				first = node;
			}
			if (next == null) {
				last = node;
			}
			_size++;
			return true;
		}

		int cmp = key_compare_func (key, node.key);
		bool changed;
		if (cmp == 0) {
			if (value_equal_func (value, node.value)) {
				changed = false;
			} else {
				old_value = (owned) node.value;
				node.value = value;
				changed = true;
			}
		} else if (cmp < 0) {
			changed = set_to_node (ref node.left, key, value, out old_value, node.prev, node);
		} else {
			changed = set_to_node (ref node.right, key, value, out old_value, node, node.next);
		}

		fix_up (ref node);
		return changed;
	}

	/**
	 * {@inheritDoc}
	 */
	public override void set (K key, V value) {
		V old_value;
		set_to_node (ref root, key, value, out old_value, null, null);
		root.color = Node.Color.BLACK;
		stamp++;
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
			rotate_right (ref root);
			root.flip ();
		}
	}

	private void fix_removal (ref Node<K,V> node, out K? key = null, out V? value) {
		Node<K,V> n = (owned) node;
		if (&key != null)
			key = (owned) n.key;
		else
			n.key = null;
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
		n.value = null;
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

	private bool remove_from_node (ref Node<K, V>? node, K key, out V value, out unowned Node<K, V>? prev = null, out unowned Node<K, V>? next = null) {
		if (node == null) {
			return false;
		} else if (key_compare_func (key, node.key) < 0) {
			weak Node<K,V> left = node.left;
			if (left == null) {
				return false;
			}
			if (node.left != null && is_black (left) && is_black (left.left)) {
				move_red_left (ref node);
			}
			bool r = remove_from_node (ref node.left, key, out value, out prev, out next);
			fix_up (ref node);
			return r;
		} else {
			if (is_red (node.left)) {
				rotate_right (ref node);
			}

			weak Node<K,V>? r = node.right;
			if (key_compare_func (key, node.key) == 0 && r == null) {
				if (&prev != null)
					prev = node.prev;
				if (&next != null)
					next = node.next;
				fix_removal (ref node, null, out value);
				return true;
			}
			if (is_black (r) && r != null && is_black (r.left)) {
				move_red_right (ref node);
			}
			if (key_compare_func (key, node.key) == 0) {
				value = (owned) node.value;
				if (&prev != null)
					prev = node.prev;
				if (&next != null)
					next = node;
				remove_minimal (ref node.right, out node.key, out node.value);
				fix_up (ref node);
				return true;
			} else {
				bool re = remove_from_node (ref node.right, key, out value, out prev, out next);
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
		if (is_red (node.left) && is_red (node.right)) {
			node.flip ();
		}
	}

	/**
	 * {@inheritDoc}
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

	private inline void clear_subtree (owned Node<K,V> node) {
		node.key = null;
		node.value = null;
		if (node.left != null)
			clear_subtree ((owned) node.left);
		if (node.right != null)
			clear_subtree ((owned) node.right);
	}

	/**
	 * {@inheritDoc}
	 */
	public override void clear () {
		if (root != null) {
			clear_subtree ((owned) root);
			first = last = null;
		}
		_size = 0;
		stamp++;
	}

	/**
	 * {@inheritDoc}
	 */
	public override Gee.MapIterator<K,V> map_iterator () {
		return new MapIterator<K,V> (this);
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
			color = color.flip ();
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
		public unowned Map.Entry<K,V>? entry;
	}

	private Node<K, V>? root = null;
	private weak Node<K, V>? first = null;
	private weak Node<K, V>? last = null;
	private int stamp = 0;

	private class Entry<K,V> : Map.Entry<K,V> {
		private unowned Node<K,V> _node;

		public static Map.Entry<K,V> entry_for<K,V> (Node<K,V> node) {
			Map.Entry<K,V> result = node.entry;
			if (node.entry == null) {
				result = new Entry<K,V> (node);
				node.entry = result;
				result.add_weak_pointer ((void**) (&node.entry));
			}
			return result;
		}

		public Entry (Node<K,V> node) {
			_node = node;
		}

		public override K key { get { return _node.key; } }

		public override V value {
			get { return _node.value; }
			set { _node.value = value; }
		}
	}

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

		public override bool read_only {
			get { return true; }
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
			return _map.has_key (key);
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

		public override bool read_only {
			get { return true; }
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

	private class EntrySet<K,V> : AbstractSet<Map.Entry<K, V>> {
		private TreeMap<K,V> _map;

		public EntrySet (TreeMap<K,V> map) {
			_map = map;
		}

		public override Iterator<Map.Entry<K, V>> iterator () {
			return new EntryIterator<K,V> (_map);
		}

		public override int size {
			get { return _map.size; }
		}

		public override bool read_only {
			get { return true; }
		}

		public override bool add (Map.Entry<K, V> entry) {
			assert_not_reached ();
		}

		public override void clear () {
			assert_not_reached ();
		}

		public override bool remove (Map.Entry<K, V> entry) {
			assert_not_reached ();
		}

		public override bool contains (Map.Entry<K, V> entry) {
			return _map.has (entry.key, entry.value);
		}

		public override bool add_all (Collection<Map.Entry<K, V>> entries) {
			assert_not_reached ();
		}

		public override bool remove_all (Collection<Map.Entry<K, V>> entries) {
			assert_not_reached ();
		}

		public override bool retain_all (Collection<Map.Entry<K, V>> entries) {
			assert_not_reached ();
		}
	}

	private class NodeIterator<K,V> : Object {
		protected TreeMap<K,V> _map;

		// concurrent modification protection
		protected int stamp;

		protected weak Node<K, V>? current;
		protected weak Node<K, V>? _next;
		protected weak Node<K, V>? _prev;

		public NodeIterator (TreeMap<K,V> map) {
			_map = map;
			stamp = _map.stamp;
		}

		public bool next () {
			assert (stamp == _map.stamp);
			if (current != null) {
				if (current.next != null) {
					current = current.next;
					return true;
				} else {
					return false;
				}
			} else if (_next == null && _prev == null) {
				current = _map.first;
				return current != null;
			} else {
				current = _next;
				if (current != null) {
					_next = null;
					_prev = null;
				}
				return current != null;
			}
		}

		public bool has_next () {
			assert (stamp == _map.stamp);
			return (current == null && _next == null && _prev == null && _map.first != null) ||
			       (current == null && _next != null) ||
			       (current != null && current.next != null);
		}

		public bool first () {
			assert (stamp == _map.stamp);
			current = _map.first;
			_next = null;
			_prev = null;
			return current != null; // on false it is null anyway
		}

		public bool previous () {
			assert (stamp == _map.stamp);
			if (current != null) {
				if (current.prev != null) {
					current = current.prev;
					return true;
				} else {
					return false;
				}
			} else {
				if (_prev != null) {
					current = _prev;
					_next = null;
					_prev = null;
					return true;
				} else {
					return false;
				}
			}
		}

		public bool has_previous () {
			assert (stamp == _map.stamp);
			return (current == null && _prev != null) ||
			       (current != null && current.prev != null);
		}

		public bool last () {
			assert (stamp == _map.stamp);
			current = _map.last;
			_next = null;
			_prev = null;
			return current != null; // on false it is null anyway
		}

		public void remove () {
			assert_not_reached ();
		}
		
		public void unset () {
			assert (stamp == _map.stamp);
			assert (current != null);
			V value;
			bool success = _map.remove_from_node (ref _map.root, current.key, out value, out _prev, out _next);
			assert (success);
			if (_map.root != null)
				_map.root.color = Node.Color.BLACK;
			current = null;
			stamp++;
			_map.stamp++;
			assert (stamp == _map.stamp);
		}
		
		public virtual bool read_only {
			get {
				return true;
			}
		}
		
		public bool valid {
			get {
				return current != null;
			}
		}
	}

	private class KeyIterator<K,V> : NodeIterator<K,V>, Gee.Iterator<K>, BidirIterator<K> {
		public KeyIterator (TreeMap<K,V> map) {
			base (map);
		}

		public new K get () {
			assert (stamp == _map.stamp);
			assert (current != null);
			return current.key;
		}
	}

	private class ValueIterator<K,V> : NodeIterator<K,V>, Gee.Iterator<V>, Gee.BidirIterator<V> {
		public ValueIterator (TreeMap<K,V> map) {
			base (map);
		}

		public new V get () {
			assert (stamp == _map.stamp);
			assert (current != null);
			return current.value;
		}
	}

	private class EntryIterator<K,V> : NodeIterator<K,V>, Gee.Iterator<Map.Entry<K,V>>, Gee.BidirIterator<Map.Entry<K,V>> {
		public EntryIterator (TreeMap<K,V> map) {
			base (map);
		}

		public new Map.Entry<K,V> get () {
			assert (stamp == _map.stamp);
			assert (current != null);
			return Entry<K,V>.entry_for<K,V> (current);
		}
	}

	private class MapIterator<K,V> : NodeIterator<K,V>, Gee.MapIterator<K,V> {
		public MapIterator (TreeMap<K,V> map) {
			base (map);
		}

		public K get_key () {
			assert (stamp == _map.stamp);
			assert (current != null);
			return current.key;
		}

		public V get_value () {
			assert (stamp == _map.stamp);
			assert (current != null);
			return current.value;
		}

		public void set_value (V value) {
			assert (stamp == _map.stamp);
			assert (current != null);
			current.value = value;
		}
		
		public override bool read_only {
			get {
				return false;
			}
		}
		
		public bool mutable {
			get {
				return true;
			}
		}
	}
}
