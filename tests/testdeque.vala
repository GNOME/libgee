/* testdeque.vala
 *
 * Copyright (C) 2009  Didier Villevalois
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
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 */

using Gee;

public abstract class DequeTests : QueueTests {

	public DequeTests (string name) {
		base (name);
		add_test ("[Deque] queue use", test_queue_use);
		add_test ("[Deque] stack use", test_stack_use);
		add_test ("[Deque] reversed stack use", test_reversed_stack_use);
	}

	public void test_queue_use () {
		var test_deque = test_collection as Gee.Deque<string>;
		ArrayList<string> recipient = new ArrayList<string> ();

		// Check the test deque is not null
		assert (test_deque != null);

		// Check normal FIFO behavior
		assert (test_deque.offer_tail ("one"));
		assert (test_deque.size == 1);
		assert (test_deque.offer_tail ("two"));
		assert (test_deque.size == 2);
		assert (test_deque.offer_tail ("three"));
		assert (test_deque.size == 3);
		assert (test_deque.offer_tail ("four"));
		assert (test_deque.size == 4);
		assert (test_deque.peek_head () == "one");
		assert (test_deque.poll_head () == "one");
		assert (test_deque.size == 3);
		assert (test_deque.peek_head () == "two");
		assert (test_deque.poll_head () == "two");
		assert (test_deque.size == 2);
		assert (test_deque.peek_head () == "three");
		assert (test_deque.poll_head () == "three");
		assert (test_deque.size == 1);
		assert (test_deque.peek_head () == "four");
		assert (test_deque.poll_head () == "four");
		assert (test_deque.size == 0);

		// Check normal behavior when no element
		assert (test_deque.peek_head () == null);
		assert (test_deque.poll_head () == null);

		// Check drain with FIFO behavior
		recipient.clear ();
		assert (test_deque.offer_tail ("one"));
		assert (test_deque.offer_tail ("two"));
		assert (test_deque.offer_tail ("three"));
		assert (test_deque.offer_tail ("four"));
		assert (test_deque.size == 4);
		assert (test_deque.drain_head (recipient, 1) == 1);
		assert (test_deque.size == 3);
		assert (recipient.size == 1);
		assert (recipient.get (0) == "one");
		assert (test_deque.drain_head (recipient) == 3);
		assert (test_deque.size == 0);
		assert (recipient.size == 4);
		assert (recipient.get (1) == "two");
		assert (recipient.get (2) == "three");
		assert (recipient.get (3) == "four");

		// Check drain one when no element
		recipient.clear ();
		assert (test_deque.drain_head (recipient, 1) == 0);
		assert (test_deque.size == 0);
		assert (recipient.size == 0);

		// Check drain all when no element
		recipient.clear ();
		assert (test_deque.drain_head (recipient) == 0);
		assert (test_deque.size == 0);
		assert (recipient.size == 0);
	}

	public void test_stack_use () {
		var test_deque = test_collection as Gee.Deque<string>;
		ArrayList<string> recipient = new ArrayList<string> ();

		// Check the test deque is not null
		assert (test_deque != null);

		// Check normal LIFO behavior
		assert (test_deque.offer_head ("one"));
		assert (test_deque.size == 1);
		assert (test_deque.offer_head ("two"));
		assert (test_deque.size == 2);
		assert (test_deque.offer_head ("three"));
		assert (test_deque.size == 3);
		assert (test_deque.offer_head ("four"));
		assert (test_deque.size == 4);
		assert (test_deque.peek_head () == "four");
		assert (test_deque.poll_head () == "four");
		assert (test_deque.size == 3);
		assert (test_deque.peek_head () == "three");
		assert (test_deque.poll_head () == "three");
		assert (test_deque.size == 2);
		assert (test_deque.peek_head () == "two");
		assert (test_deque.poll_head () == "two");
		assert (test_deque.size == 1);
		assert (test_deque.peek_head () == "one");
		assert (test_deque.poll_head () == "one");
		assert (test_deque.size == 0);

		// Check normal behavior when no element
		assert (test_deque.peek_head () == null);
		assert (test_deque.poll_head () == null);

		// Check drain with LIFO behavior
		recipient.clear ();
		assert (test_deque.offer_head ("one"));
		assert (test_deque.offer_head ("two"));
		assert (test_deque.offer_head ("three"));
		assert (test_deque.offer_head ("four"));
		assert (test_deque.size == 4);
		assert (test_deque.drain_head (recipient, 1) == 1);
		assert (test_deque.size == 3);
		assert (recipient.size == 1);
		assert (recipient.get (0) == "four");
		assert (test_deque.drain_head (recipient) == 3);
		assert (test_deque.size == 0);
		assert (recipient.size == 4);
		assert (recipient.get (1) == "three");
		assert (recipient.get (2) == "two");
		assert (recipient.get (3) == "one");

		// Check drain one when no element
		recipient.clear ();
		assert (test_deque.drain_head (recipient, 1) == 0);
		assert (test_deque.size == 0);
		assert (recipient.size == 0);

		// Check drain all when no element
		recipient.clear ();
		assert (test_deque.drain_head (recipient) == 0);
		assert (test_deque.size == 0);
		assert (recipient.size == 0);
	}

	public void test_reversed_stack_use () {
		var test_deque = test_collection as Gee.Deque<string>;
		ArrayList<string> recipient = new ArrayList<string> ();

		// Check the test deque is not null
		assert (test_deque != null);

		// Check normal LIFO behavior
		assert (test_deque.offer_tail ("one"));
		assert (test_deque.size == 1);
		assert (test_deque.offer_tail ("two"));
		assert (test_deque.size == 2);
		assert (test_deque.offer_tail ("three"));
		assert (test_deque.size == 3);
		assert (test_deque.offer_tail ("four"));
		assert (test_deque.size == 4);
		assert (test_deque.peek_tail () == "four");
		assert (test_deque.poll_tail () == "four");
		assert (test_deque.size == 3);
		assert (test_deque.peek_tail () == "three");
		assert (test_deque.poll_tail () == "three");
		assert (test_deque.size == 2);
		assert (test_deque.peek_tail () == "two");
		assert (test_deque.poll_tail () == "two");
		assert (test_deque.size == 1);
		assert (test_deque.peek_tail () == "one");
		assert (test_deque.poll_tail () == "one");
		assert (test_deque.size == 0);

		// Check normal behavior when no element
		assert (test_deque.peek_tail () == null);
		assert (test_deque.poll_tail () == null);

		// Check drain with LIFO behavior
		recipient.clear ();
		assert (test_deque.offer_tail ("one"));
		assert (test_deque.offer_tail ("two"));
		assert (test_deque.offer_tail ("three"));
		assert (test_deque.offer_tail ("four"));
		assert (test_deque.size == 4);
		assert (test_deque.drain_tail (recipient, 1) == 1);
		assert (test_deque.size == 3);
		assert (recipient.size == 1);
		assert (recipient.get (0) == "four");
		assert (test_deque.drain_tail (recipient) == 3);
		assert (test_deque.size == 0);
		assert (recipient.size == 4);
		assert (recipient.get (1) == "three");
		assert (recipient.get (2) == "two");
		assert (recipient.get (3) == "one");

		// Check drain one when no element
		recipient.clear ();
		assert (test_deque.drain_tail (recipient, 1) == 0);
		assert (test_deque.size == 0);
		assert (recipient.size == 0);

		// Check drain all when no element
		recipient.clear ();
		assert (test_deque.drain_tail (recipient) == 0);
		assert (test_deque.size == 0);
		assert (recipient.size == 0);
	}
}
