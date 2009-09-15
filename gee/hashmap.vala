/* hashmap.vala
 *
 * Copyright (C) 1995-1997  Peter Mattis, Spencer Kimball and Josh MacDonald
 * Copyright (C) 1997-2000  GLib Team and others
 * Copyright (C) 2007-2009  Jürg Billeter
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
 * Hash table implementation of the {@link Gee.Map} interface.
 *
 * This implementation is better fit for highly heterogenous key values.
 * In case of high key hashes redundancy or higher amount of data prefer using
 * tree implementation like {@link Gee.TreeMap}.
 *
 * @see Gee.TreeMap
 */
public class Gee.HashMap<K,V> : Gee.AbstractMap<K,V> {
	/**
	 * @inheritDoc
	 */
	public override int size {
		get { return _nnodes; }
	}

	/**
	 * The keys' hash function.
	 */
	public HashFunc key_hash_func { private set; get; }

	/**
	 * The keys' equality testing function.
	 */
	public EqualFunc key_equal_func { private set; get; }

	/**
	 * The values' equality testing function.
	 */
	public EqualFunc value_equal_func { private set; get; }

	private int _array_size;
	private int _nnodes;
	private Node<K,V>[] _nodes;

	// concurrent modification protection
	private int _stamp = 0;

	private const int MIN_SIZE = 11;
	private const int MAX_SIZE = 13845163;

	/**
	 * Constructs a new, empty hash map.
	 *
	 * @param key_hash_func a key hash function.
	 * @param key_equal_func a key equality testing function.
	 * @param value_equal_func a value equallity testing function.
	 */
	public HashMap (HashFunc? key_hash_func = null, EqualFunc? key_equal_func = null, EqualFunc? value_equal_func = null) {
		if (key_hash_func == null) {
			key_hash_func = Functions.get_hash_func_for (typeof (K));
		}
		if (key_equal_func == null) {
			key_equal_func = Functions.get_equal_func_for (typeof (K));
		}
		if (value_equal_func == null) {
			value_equal_func = Functions.get_equal_func_for (typeof (V));
		}
		this.key_hash_func = key_hash_func;
		this.key_equal_func = key_equal_func;
		this.value_equal_func = value_equal_func;
	}

	construct {
		_array_size = MIN_SIZE;
		_nodes = new Node<K,V>[_array_size];
	}

	/**
	 * @inheritDoc
	 */
	public override Set<K> get_keys () {
		return new KeySet<K,V> (this);
	}

	/**
	 * @inheritDoc
	 */
	public override Collection<V> get_values () {
		return new ValueCollection<K,V> (this);
	}

	internal Gee.UpdatableKeyIterator<K,V> updatable_key_iterator () {
		return new UpdatableKeyIterator<K,V> (this);
	}

	private Node<K,V>** lookup_node (K key) {
		uint hash_value = key_hash_func (key);
		Node<K,V>** node = &_nodes[hash_value % _array_size];
		while ((*node) != null && (hash_value != (*node)->key_hash || !key_equal_func ((*node)->key, key))) {
			node = &((*node)->next);
		}
		return node;
	}

	/**
	 * @inheritDoc
	 */
	public override bool contains (K key) {
		Node<K,V>** node = lookup_node (key);
		return (*node != null);
	}

	/**
	 * @inheritDoc
	 */
	public override V? get (K key) {
		Node<K,V>* node = (*lookup_node (key));
		if (node != null) {
			return node->value;
		} else {
			return null;
		}
	}

	/**
	 * @inheritDoc
	 */
	public override void set (K key, V value) {
		Node<K,V>** node = lookup_node (key);
		if (*node != null) {
			(*node)->value = value;
		} else {
			uint hash_value = key_hash_func (key);
			*node = new Node<K,V> (key, value, hash_value);
			_nnodes++;
			resize ();
		}
		_stamp++;
	}

	/**
	 * @inheritDoc
	 */
	public override bool remove (K key, out V? value = null) {
		Node<K,V>** node = lookup_node (key);
		if (*node != null) {
			Node<K,V> next = (owned) (*node)->next;

			if (&value != null) {
				value = (owned) (*node)->value;
			}

			(*node)->key = null;
			(*node)->value = null;
			delete *node;

			*node = (owned) next;

			_nnodes--;
			resize ();
			_stamp++;
			return true;
		}
		return false;
	}

	/**
	 * @inheritDoc
	 */
	public override void clear () {
		for (int i = 0; i < _array_size; i++) {
			Node<K,V> node = (owned) _nodes[i];
			while (node != null) {
				Node next = (owned) node.next;
				node.key = null;
				node.value = null;
				node = (owned) next;
			}
		}
		_nnodes = 0;
		resize ();
	}

	private void resize () {
		if ((_array_size >= 3 * _nnodes && _array_size >= MIN_SIZE) ||
		    (3 * _array_size <= _nnodes && _array_size < MAX_SIZE)) {
			int new_array_size = (int) SpacedPrimes.closest (_nnodes);
			new_array_size = new_array_size.clamp (MIN_SIZE, MAX_SIZE);

			Node<K,V>[] new_nodes = new Node<K,V>[new_array_size];

			for (int i = 0; i < _array_size; i++) {
				Node<K,V> node;
				Node<K,V> next = null;
				for (node = (owned) _nodes[i]; node != null; node = (owned) next) {
					next = (owned) node.next;
					uint hash_val = node.key_hash % new_array_size;
					node.next = (owned) new_nodes[hash_val];
					new_nodes[hash_val] = (owned) node;
				}
			}
			_nodes = (owned) new_nodes;
			_array_size = new_array_size;
		}
	}

	~HashSet () {
		clear ();
	}

	[Compact]
	private class Node<K,V> {
		public K key;
		public V value;
		public Node<K,V> next;
		public uint key_hash;

		public Node (owned K k, owned V v, uint hash) {
			key = (owned) k;
			value = (owned) v;
			key_hash = hash;
		}
	}

	private class KeySet<K,V> : AbstractSet<K> {
		public HashMap<K,V> map { private set; get; }

		public KeySet (HashMap map) {
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
		public HashMap<K,V> map { private set; get; }

		public ValueCollection (HashMap map) {
			this.map = map;
		}

		public override Iterator<V> iterator () {
			return new ValueIterator<K,V> (map);
		}

		public override int size {
			get { return map.size; }
		}

		public override bool add (V value) {
			assert_not_reached ();
		}

		public override void clear () {
			assert_not_reached ();
		}

		public override bool remove (V value) {
			assert_not_reached ();
		}

		public override bool contains (V value) {
			Iterator<V> it = iterator ();
			while (it.next ()) {
				if (map.value_equal_func (it.get (), value)) {
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

	private abstract class NodeIterator<K,V> : Object {
		public HashMap<K,V> map {
			private set {
				_map = value;
				_stamp = _map._stamp;
			}
		}

		protected HashMap<K,V> _map;
		private int _index = -1;
		protected weak Node<K,V> _node;
		protected weak Node<K,V> _next;

		// concurrent modification protection
		protected int _stamp;

		public NodeIterator (HashMap map) {
			this.map = map;
		}

		public bool next () {
			assert (_stamp == _map._stamp);
			if (!has_next ()) {
				return false;
			}
			_node = _next;
			_next = null;
			return (_node != null);
		}

		public bool has_next () {
			assert (_stamp == _map._stamp);
			if (_next == null) {
				_next = _node;
				if (_next != null) {
					_next = _next.next;
				}
				while (_next == null && _index + 1 < _map._array_size) {
					_index++;
					_next = _map._nodes[_index];
				}
			}
			return (_next != null);
		}

		public bool first () {
			assert (_stamp == _map._stamp);
			if (_map.size == 0) {
				return false;
			}
			_index = -1;
			_next = null;
			return next ();
		}
	}

	private class KeyIterator<K,V> : NodeIterator<K,V>, Iterator<K> {
		public KeyIterator (HashMap map) {
			base (map);
		}

		public new K get () {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			return _node.key;
		}

		public void remove () {
			assert_not_reached ();
		}
	}

	private class UpdatableKeyIterator<K,V> : NodeIterator<K,V>, Iterator<K>, Gee.UpdatableKeyIterator<K,V> {
		public UpdatableKeyIterator (HashMap map) {
			base (map);
		}

		public new K get () {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			return _node.key;
		}

		public void remove () {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			has_next ();
			_map.remove (_node.key);
			_node = null;
			_stamp = _map._stamp;
		}

		public V get_value () {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			return _node.value;
		}

		public void set_value (V value) {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			_map.set (_node.key, value);
			_stamp = _map._stamp;
		}
	}

	private class ValueIterator<K,V> : NodeIterator<K,V>, Iterator<K> {
		public ValueIterator (HashMap map) {
			base (map);
		}

		public new V get () {
			assert (_stamp == _map._stamp);
			assert (_node != null);
			return _node.value;
		}

		public void remove () {
			assert_not_reached ();
		}
	}
}

