/* treeset.vala
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
 * Left-leaning red-black tree implementation of the {@link Gee.Set} interface.
 *
 * This implementation is especially well designed for large quantity of
 * data. The (balanced) tree implementation insure that the set and get
 * methods are in logarithmic complexity. For a linear implementation see
 * {@link Gee.HashSet}.
 *
 * @see Gee.HashSet
 */
public class Gee.TreeSet<G> : AbstractSet<G> {
	/**
	 * @inheritDoc
	 */
	public override int size {
		get {return _size;}
	}

	/**
	 * The elements' comparator function.
	 */
	public CompareFunc compare_func { private set; get; }

	private int _size = 0;

	/**
	 * Constructs a new, empty tree set sorted according to the specified
	 * comparator function.
	 *
	 * @param compare_func an optional elements comparator function.
	 */
	public TreeSet (CompareFunc? compare_func = null) {
		if (compare_func == null) {
			compare_func = Functions.get_compare_func_for (typeof (G));
		}
		this.compare_func = compare_func;
	}

	/**
	 * @inheritDoc
	 */
	public override bool contains (G item) {
		weak Node<G>? cur = root;
		while (cur != null) {
			int res = compare_func (item, cur.key);
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

	private void rotate_right (ref Node<G> root) {
		Node<G> pivot = (owned) root.left;
		pivot.color = root.color;
		root.color = Node.Color.RED;
		root.left = (owned) pivot.right;
		pivot.right = (owned) root;
		root = (owned) pivot;
	}

	private void rotate_left (ref Node<G> root) {
		Node<G> pivot = (owned) root.right;
		pivot.color = root.color;
		root.color = Node.Color.RED;
		root.right = (owned) pivot.left;
		pivot.left = (owned) root;
		root = (owned) pivot;
	}

	private bool is_red (Node<G>? n) {
		return n != null && n.color == Node.Color.RED;
	}

	private bool is_black (Node<G>? n) {
		return n == null || n.color == Node.Color.BLACK;
	}

	private void fix_up (ref Node<G> node) {
		if (is_black (node.left) && is_red (node.right)) {
			rotate_left (ref node);
		}
		if (is_red (node.left) && is_black (node.right)) {
			rotate_right (ref node);
		}
	}

	private bool add_to_node (ref Node<G>? node, owned G item, Node<G>? prev, Node<G>? next) {
		if (node == null) {
			node = new Node<G> ((owned) item, prev, next);
			if (prev == null) {
				first = node;
			}
			_size++;
			return true;
		}

		if (is_red (node.left) && is_red (node.right)) {
			node.flip ();
		}

		int cmp = compare_func (item, node.key);
		if (cmp == 0) {
			fix_up (ref node);
			return false;
		} else if (cmp < 0) {
			bool r = add_to_node (ref node.left, item, node.prev, node);
			fix_up (ref node);
			return r;
		} else {
			bool r = add_to_node (ref node.right, item, node, node.next);
			fix_up (ref node);
			return r;
		}
	}

	/**
	 * @inheritDoc
	 *
	 * If the element already exists in the set it will not be added twice.
	 */
	public override bool add (G item) {
		bool r = add_to_node (ref root, item, null, null);
		root.color = Node.Color.BLACK;
		stamp++;
		return r;
	}

	private void move_red_left (ref Node<G> root) {
		root.flip ();
		if (is_red (root.right.left)) {
			rotate_right (ref root.right);
			rotate_left (ref root);
			root.flip ();
		}
	}

	private void move_red_right (ref Node<G> root) {
		root.flip ();
		if (is_red (root.left.left)) {
			rotate_right (ref root.right);
			root.flip ();
		}
	}

	private void fix_removal (ref Node<G> node, out G? key = null) {
		Node<G> n = (owned) node;
		if (&key != null)
			key = (owned) n.key;
		if (n.prev != null) {
			n.prev.next = n.next;
		} else {
			first = n.next;
		}
		if (n.next != null) {
			n.next.prev = n.prev;
		}
		node = null;
		_size--;
	}

	private void remove_minimal (ref Node<G> node, out G key) {
		if (node.left == null) {
			fix_removal (ref node, out key);
			return;
		}

		if (is_black (node.left) && is_black (node.left.left)) {
			move_red_left (ref node);
		}

		remove_minimal (ref node.left, out key);

		fix_up (ref node);
	}

	private bool remove_from_node (ref Node<G>? node, G item) {
		if (node == null) {
			return false;
		} else if (compare_func (item, node.key) < 0) {
			weak Node<G> left = node.left;
			if (left == null) {
				return false;
			}
			if (is_black (left) && is_black (left.left)) {
				move_red_left (ref node);
			}
			bool r = remove_from_node (ref node.left, item);
			fix_up (ref node);
			return r;
		} else {
			if (is_red (node.left)) {
				rotate_right (ref node);
			}

			weak Node<G> r = node.right;
			if (compare_func (item, node.key) == 0 && r == null) {
				fix_removal (ref node, null);
				return true;
			}
			if (is_black (r) && is_black (r.left)) {
				move_red_right (ref node);
			}
			if (compare_func (item, node.key) == 0) {
				remove_minimal (ref node.right, out node.key);
				fix_up (ref node);
				return true;
			} else {
				bool re = remove_from_node (ref node.right, item);
				fix_up (ref node);
				return re;
			}
		}
	}

	/**
	 * @inheritDoc
	 */
	public override bool remove (G item) {
		bool b = remove_from_node (ref root, item);
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

	/**
	 * @inheritDoc
	 */
	public override Gee.Iterator<G> iterator () {
		return new Iterator<G> (this);
	}

	[Compact]
	private class Node<G> {
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

		public Node (owned G node, Node<G>? prev, Node<G>? next) {
			this.key = (owned) node;
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

		public G key;
		public Color color;
		public Node<G>? left;
		public Node<G>? right;
		public weak Node<G>? prev;
		public weak Node<G>? next;
	}

	private class Iterator<G> : Object, Gee.Iterator<G> {
		public new TreeSet<G> set {
			private set {
				_set = value;
				stamp = _set.stamp;
			}
		}

		private TreeSet<G> _set;

		// concurrent modification protection
		private int stamp;

		public Iterator (TreeSet<G> set) {
			this.set = set;
		}

		public bool next () {
			assert (stamp == _set.stamp);
			if (current != null) {
				current = current.next;
			} else {
				switch (state) {
				case Iterator.State.BEFORE_THE_BEGIN:
					current = _set.first;
					break;
				case Iterator.State.NORMAL: // After remove
					current = _next;
					_next = null;
					_prev = null;
					break;
				case Iterator.State.PAST_THE_END:
					break;
				default:
					assert_not_reached ();
				}
			}
			state = current != null ? Iterator.State.NORMAL : Iterator.State.PAST_THE_END;
			return current != null;
		}

		public bool has_next () {
			assert (stamp == _set.stamp);
			return (current == null && state == Iterator.State.BEFORE_THE_BEGIN) ||
			       (current == null && state == Iterator.State.NORMAL && _next != null) ||
			       (current != null && current.next != null);
		}

		public bool first () {
			assert (stamp == _set.stamp);
			current = _set.first;
			_next = null;
			_prev = null;
			return current != null; // on false it is null anyway
		}

		public new G get () {
			assert (stamp == _set.stamp);
			assert (current != null);
			return current.key;
		}

		private weak Node<G>? current;
		private weak Node<G>? _next;
		private weak Node<G>? _prev;
		private enum State {
			BEFORE_THE_BEGIN,
			NORMAL,
			PAST_THE_END
		}
		private Iterator.State state = Iterator.State.BEFORE_THE_BEGIN;
	}

	private Node<G>? root = null;
	private weak Node<G>? first = null;
	private int stamp = 0;
}
