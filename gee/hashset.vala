/* hashset.vala
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
 * Hash table implementation of the {@link Gee.Set} interface.
 *
 * This implementation is better fit for highly heterogenous values.
 * In case of high value hashes redundancy or higher amount of data prefer using
 * tree implementation like {@link Gee.TreeSet}.
 *
 * @see Gee.TreeSet
 */
public class Gee.HashSet<G> : AbstractSet<G> {
	/**
	 * {@inheritDoc}
	 */
	public override int size {
		get { return _nnodes; }
	}

	/**
	 * The elements' hash function.
	 */
	public HashFunc hash_func { private set; get; }

	/**
	 * The elements' equality testing function.
	 */
	public EqualFunc equal_func { private set; get; }

	private int _array_size;
	private int _nnodes;
	private Node<G>[] _nodes;

	// concurrent modification protection
	private int _stamp = 0;

	private const int MIN_SIZE = 11;
	private const int MAX_SIZE = 13845163;

	/**
	 * Constructs a new, empty hash set.
	 *
	 * @param hash_func an optional hash function.
	 * @param equal_func an optional equality testing function.
	 */
	public HashSet (HashFunc? hash_func = null, EqualFunc? equal_func = null) {
		if (hash_func == null) {
			hash_func = Functions.get_hash_func_for (typeof (G));
		}
		if (equal_func == null) {
			equal_func = Functions.get_equal_func_for (typeof (G));
		}
		this.hash_func = hash_func;
		this.equal_func = equal_func;
		_array_size = MIN_SIZE;
		_nodes = new Node<G>[_array_size];
	}

	private Node<G>** lookup_node (G key) {
		uint hash_value = hash_func (key);
		Node<G>** node = &_nodes[hash_value % _array_size];
		while ((*node) != null && (hash_value != (*node)->key_hash || !equal_func ((*node)->key, key))) {
			node = &((*node)->next);
		}
		return node;
	}

	/**
	 * {@inheritDoc}
	 */
	public override bool contains (G key) {
		Node<G>** node = lookup_node (key);
		return (*node != null);
	}

	/**
	 * {@inheritDoc}
	 */
	public override Gee.Iterator<G> iterator () {
		return new Iterator<G> (this);
	}

	/**
	 * {@inheritDoc}
	 */
	public override bool add (G key) {
		Node<G>** node = lookup_node (key);
		if (*node != null) {
			return false;
		} else {
			uint hash_value = hash_func (key);
			*node = new Node<G> (key, hash_value);
			_nnodes++;
			resize ();
			_stamp++;
			return true;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public override bool remove (G key) {
		Node<G>** node = lookup_node (key);
		if (*node != null) {
			assert (*node != null);
			Node<G> next = (owned) (*node)->next;

			(*node)->key = null;
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
	 * {@inheritDoc}
	 */
	public override void clear () {
		for (int i = 0; i < _array_size; i++) {
			Node<G> node = (owned) _nodes[i];
			while (node != null) {
				Node next = (owned) node.next;
				node.key = null;
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

			Node<G>[] new_nodes = new Node<G>[new_array_size];

			for (int i = 0; i < _array_size; i++) {
				Node<G> node;
				Node<G> next = null;
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
	private class Node<G> {
		public G key;
		public Node<G> next;
		public uint key_hash;

		public Node (owned G k, uint hash) {
			key = (owned) k;
			key_hash = hash;
		}
	}

	private class Iterator<G> : Object, Gee.Iterator<G> {
		private HashSet<G> _set;
		private int _index = -1;
		private weak Node<G> _node;
		private weak Node<G> _next;

		// concurrent modification protection
		private int _stamp = 0;

		public Iterator (HashSet set) {
			_set = set;
			_stamp = _set._stamp;
		}

		public bool next () {
			assert (_stamp == _set._stamp);
			if (!has_next ()) {
				return false;
			}
			_node = _next;
			_next = null;
			return (_node != null);
		}

		public bool has_next () {
			assert (_stamp == _set._stamp);
			if (_next == null) {
				_next = _node;
				if (_next != null) {
					_next = _next.next;
				}
				while (_next == null && _index + 1 < _set._array_size) {
					_index++;
					_next = _set._nodes[_index];
				}
			}
			return (_next != null);
		}

		public bool first () {
			assert (_stamp == _set._stamp);
			if (_set.size == 0) {
				return false;
			}
			_index = -1;
			_next = null;
			return next ();
		}

		public new G get () {
			assert (_stamp == _set._stamp);
			assert (_node != null);
			return _node.key;
		}

		public void remove () {
			assert (_stamp == _set._stamp);
			assert (_node != null);
			has_next ();
			_set.remove (_node.key);
			_node = null;
			_stamp = _set._stamp;
		}
	}
}

