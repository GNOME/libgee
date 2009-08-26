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
 * Left-leaning red-black tree implementation of the Set interface.
 */
public class Gee.TreeSet<G> : AbstractCollection<G>, Set<G> {
	public override int size {
		get {return _size;}
	}

	public CompareFunc compare_func { private set; get; }

	private int _size = 0;

	public TreeSet (CompareFunc compare_func = Gee.direct_compare) {
		this.compare_func = compare_func;
	}

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

	private void remove_minimal (ref Node<G> node, out G key) {
		if (node.left == null) {
			Node<G> n = (owned) node;
			key = (owned) n.key;
			node = null;
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
				node = null;
				_size--;
				return true;
			}
			if (is_black (r) && is_black (r.left)) {
				move_red_right (ref node);
			}
			if (compare_func (item, node.key) == 0) {
				remove_minimal (ref node.right, out node.key);
				fix_up (ref node);
				_size--;
				return true;
			} else {
				bool re = remove_from_node (ref node.right, item);
				fix_up (ref node);
				return re;
			}
		}
	}

	public override bool remove (G item) {
		bool b = remove_from_node (ref root, item);
		if (root != null) {
			root.color = Node.Color.BLACK;
		}
		stamp++;
		return b;
	}

	public override void clear () {
		root = null;
		_size = 0;
		stamp++;
	}

	public override Gee.Iterator<G> iterator () {
		return  new Iterator<G> (this);
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

		public G key;
		public Color color;
		public Node<G>? left;
		public Node<G>? right;
		public weak Node<G>? prev;
		public weak Node<G>? next;
	}

	private class Iterator<G> : Object, Gee.Iterator<G> {
		public new TreeSet<G> set {construct; get;}
		private int stamp;
		construct {
			stamp = set.stamp;
		}

		public Iterator (TreeSet<G> set) {
			this.set = set;
		}

		public bool next () {
			if (current != null) {
				current = current.next;
				return current != null;
			} else if (!run){
				run = true;
				current = set.first;
				return current != null;
			} else {
				return false;
			}
		}

		public new G? get () {
			assert (stamp == set.stamp);
			assert (current != null);
			return current.key;
		}

		private weak Node<G>? current;
		private bool run = false;
	}

	private Node<G>? root;
	private weak Node<G>? first;
	private int stamp = 0;
}
