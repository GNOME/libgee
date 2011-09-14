/* hazardpointer.vala
 *
 * Copyright (C) 2011  Maciej Piechotka
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

[Compact]
public class Gee.HazardPointer<G> {
	
	internal class Set {

		/**
		 * Gets a new hazard pointer node
		 *
	 	 * @return new hazard pointer node
		 */
		internal inline unowned Node<G> acquire () {
			unowned Node<G>? curr = (Node<G> *)AtomicPointer.get (ref _head);
			for (; curr != null; curr = curr.get_next ())
				if (curr.activate ())
					return curr;
			Node<G> *node = new Node<G> ();
			Node<G> *old_head = null;
			do {
				node->set_next (old_head = (Node<G> *)AtomicPointer.get (ref _head));
			} while (!AtomicPointer.compare_and_exchange (ref _head, old_head, node));
			return  node;
		}

		private Node<G> *_head;

		[Compact]
		internal class Node {
			public Node () {
				AtomicPointer.set (ref _hazard, null);
				AtomicInt.set (ref _active, 1);
			}
			
			inline ~Node () {
				delete next;
			}

			public void release () {
				AtomicPointer.set (ref _hazard, null);
				AtomicInt.set (ref _active, 0);
			}

			public inline bool is_active () {
				return AtomicInt.get (ref _active) != 0;
			}

			public inline bool activate () {
				return AtomicInt.compare_and_exchange (ref _active, 0, 1);
			}

			public inline void set (G *ptr) {
				AtomicPointer.set (ref _hazard, ptr);
			}

			public inline G *get (bool safe = true) {
				if (safe) {
					return (G *)AtomicPointer.get (ref _hazard);
				} else {
					G **hazard = &_hazard;
					return *hazard;
				}
			}

			public inline unowned Node<G>? get_next () {
				return (Node<G>?)AtomicPointer.get (ref _next);
			}

			public inline void set_next (Node<G> *next) {
				AtomicPointer.set (ref _next, next);
			}

			private Node *_next;
			private int _active;
			private void *_hazard;
		}
	}
	internal class Context {
		internal ArrayList<void *> _to_free;
	}
}

