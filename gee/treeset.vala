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

	private inline void rotate_right (ref Node<G> root) {
		Node<G> pivot = (owned) root.left;
		pivot.color = root.color;
		root.color = Node.Color.RED;
		root.left = (owned) pivot.right;
		pivot.right = (owned) root;
		root = (owned) pivot;
#if DEBUG
		stdout.printf (dump ("after rotate right on %s".printf ((string)root.right.key)));
#endif
	}

	private inline void rotate_left (ref Node<G> root) {
		Node<G> pivot = (owned) root.right;
		pivot.color = root.color;
		root.color = Node.Color.RED;
		root.right = (owned) pivot.left;
		pivot.left = (owned) root;
		root = (owned) pivot;
#if DEBUG
		stdout.printf (dump ("after rotate left on %s".printf ((string)root.left.key)));
#endif
	}

	private inline bool is_red (Node<G>? n) {
		return n != null && n.color == Node.Color.RED;
	}

	private inline bool is_black (Node<G>? n) {
		return n == null || n.color == Node.Color.BLACK;
	}

	private inline void fix_up (ref Node<G> node) {
#if DEBUG
		var n = (string)node.key;
#endif
		if (is_black (node.left) && is_red (node.right)) {
			rotate_left (ref node);
		}
		if (is_red (node.left) && is_red (node.left.left)) {
			rotate_right (ref node);
		}
		if (is_red (node.left) && is_red (node.right)) {
			node.flip ();
		}
#if DEBUG
		stdout.printf (dump ("after fix up on %s".printf (n)));
#endif
	}

	private bool add_to_node (ref Node<G>? node, owned G item, Node<G>? prev, Node<G>? next) {
#if DEBUG
		if (node != null)
			stdout.printf ("Adding %s to %s\n".printf ((string) item, (string) node.key));
#endif
		if (node == null) {
			node = new Node<G> ((owned) item, prev, next);
			if (prev == null) {
				first = node;
			}
			if (next == null) {
				last = node;
			}
			_size++;
			return true;
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
#if CONSISTENCY_CHECKS
		check ();
#endif
		bool r = add_to_node (ref root, item, null, null);
		root.color = Node.Color.BLACK;
#if CONSISTENCY_CHECKS
		check ();
#endif
		stamp++;
		return r;
	}

	private inline void move_red_left (ref Node<G> root) {
#if DEBUG
		var n = (string)root.key;
#endif
		root.flip ();
		if (is_red (root.right.left)) {
			rotate_right (ref root.right);
			rotate_left (ref root);
			root.flip ();
		}
#if DEBUG
		stdout.printf (dump ("after red left on %s".printf (n)));
#endif
	}

	private inline void move_red_right (ref Node<G> root) {
#if DEBUG
		var n = (string)root.key;
#endif
		root.flip ();
		if (is_red (root.left.left)) {
			rotate_right (ref root);
			root.flip ();
		}
#if DEBUG
		stdout.printf (dump ("after red right on %s".printf (n)));
#endif
	}

	private inline void fix_removal (ref Node<G> node, out G? key = null) {
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
		} else {
			last = n.prev;
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
#if DEBUG
		stdout.printf ("Removing %s from %s\n", (string)item, node != null ? (string)node.key : null);
#endif
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

			weak Node<G>? r = node.right;
			if (compare_func (item, node.key) == 0 && r == null) {
				fix_removal (ref node, null);
				return true;
			}
			if (is_black (r) && r != null && is_black (r.left)) {
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
#if CONSISTENCY_CHECKS
		check ();
#endif
		bool b = remove_from_node (ref root, item);
		if (root != null) {
			root.color = Node.Color.BLACK;
		}
#if CONSISTENCY_CHECKS
		check ();
#endif
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

	/**
	 * @inheritDoc
	 */
	public BidirIterator<G> bidir_iterator () {
		return new Iterator<G> (this);
	}

#if CONSISTENCY_CHECKS
	public inline void check () {
		check_subtree (root);
#if DEBUG
		stdout.printf ("%s\n", dump ());
#endif
	}

	private inline uint check_subtree (Node<G>? node) {
		if (node == null)
			return 0;
		assert (!(is_black (node.left) && is_red (node.right))); // Check left-leaning
		assert (!(is_red (node) && is_red (node.left))); // Check red property
		uint l = check_subtree (node.left);
		uint r = check_subtree (node.right);
		assert (l == r);
		return l + (node.color == Node.Color.BLACK ? 1 : 0);
	}
#endif
#if DEBUG
	public string dump (string? when = null) {
		return "TreeSet dump%s:\n%s".printf (when == null ? "" : (" " + when), dump_node (root));
	}

	private inline string dump_node (Node<G>? node, uint depth = 0) {
		if (node != null)
			return dump_node (node.left, depth + 1) +
			       "%s%s%p(%s)\033[0m\n".printf (string.nfill (depth, ' '),
			                                   node.color == Node.Color.RED ? "\033[0;31m" : "",
			                                   node, (string)node.key) +
			       dump_node (node.right, depth + 1);
		return "";
	}
#endif

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
			color = color.flip ();
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

	private class Iterator<G> : Object, Gee.Iterator<G>, BidirIterator<G> {
		private TreeSet<G> _set;

		// concurrent modification protection
		private int stamp;

		public Iterator (TreeSet<G> set) {
			_set = set;
			stamp = _set.stamp;
		}

		public bool next () {
			assert (stamp == _set.stamp);
			if (current != null) {
				current = current.next;
			} else if (!started) {
				current = _set.first;
				started = true;
			} else {
				current = _next;
				_next = null;
				_prev = null;
			}
			return current != null;
		}

		public bool has_next () {
			assert (stamp == _set.stamp);
			return (!started && _set.first != null) ||
			       (current == null && _next != null) ||
			       (current != null && current.next != null);
		}

		public bool first () {
			assert (stamp == _set.stamp);
			current = _set.first;
			_next = null;
			_prev = null;
			return current != null; // on false it is null anyway
		}

		public bool previous () {
			assert (stamp == _set.stamp);
			if (current != null) {
				current = current.prev;
			} else {
				current = _prev;
				_next = null;
				_prev = null;
			}
			return current != null;
		}

		public bool has_previous () {
			assert (stamp == _set.stamp);
			return (current == null && _prev != null) ||
			       (current != null && current.prev != null);
		}

		public bool last () {
			assert (stamp == _set.stamp);
			current = _set.last;
			_next = null;
			_prev = null;
			return current != null; // on false it is null anyway
		}

		public new G get () {
			assert (stamp == _set.stamp);
			assert (current != null);
			return current.key;
		}

		public void remove () {
			assert (stamp == _set.stamp);
			assert (current != null);
			_next = current.next;
			_prev = current.prev;
			_set.remove (get ());
			stamp++;
			current = null;
			assert (stamp == _set.stamp);
		}

		private weak Node<G>? current = null;
		private weak Node<G>? _next = null;
		private weak Node<G>? _prev = null;
		private bool started = false;
	}

	private Node<G>? root = null;
	private weak Node<G>? first = null;
	private weak Node<G>? last = null;
	private int stamp = 0;
}
