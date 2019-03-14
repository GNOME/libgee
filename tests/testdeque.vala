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

	protected DequeTests (string name) {
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
		string[] to_offer = {
		        "one", "two", "three", "four", "five", "six", "seven", "
eight",
		        "nine", "ten", "eleven", "twelve", "thirteen", "fourteen
",
		        "fifteen", "sixteen", "seventeen", "eighteen", "nineteen
", "twenty",
		        "twenty one", "twenty two", "twenty three", "twenty four",
		        "twenty five", "twenty six", "twenty seven", "twenty eight",
		        "twenty nine", "thirty", "thirty one", "thirty two", "thirty four",
		        "thirty five", "thirty six", "thirty seven", "thirty eight",
		        "thirty nine", "fourty"
		};

		// Check normal FIFO behavior
		for (int i = 0; i < to_offer.length; i++) {
			assert (test_deque.offer_tail (to_offer[i]));
			assert (test_deque.size == i + 1);
		}
		for (int i = 0; i < to_offer.length; i++) {
			assert (test_deque.peek_head () == to_offer[i]);
			assert (test_deque.poll_head () == to_offer[i]);
			assert (test_deque.size == to_offer.length - i - 1);
		}

		// Check normal behavior when no element
		assert (test_deque.peek_head () == null);
		assert (test_deque.poll_head () == null);

		// Check drain with FIFO behavior
		recipient.clear ();
		for (int i = 0; i < to_offer.length; i++) {
			assert (test_deque.offer_tail (to_offer[i]));
		}
		assert (test_deque.size == to_offer.length);
		assert (test_deque.drain_head (recipient, 1) == 1);
		assert (test_deque.size == to_offer.length - 1);
		assert (recipient.size == 1);
		assert (recipient.get (0) == to_offer[0]);
		assert (test_deque.drain_head (recipient) == to_offer.length - 1);
		assert (test_deque.size == 0);
		assert (recipient.size == to_offer.length);
		for (int i = 1; i < to_offer.length; i++) {
			assert (recipient.get (i) == to_offer[i]);
		}

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
		string[] to_offer = {
		        "one", "two", "three", "four", "five", "six", "seven", "
eight",
		        "nine", "ten", "eleven", "twelve", "thirteen", "fourteen
",
		        "fifteen", "sixteen", "seventeen", "eighteen", "nineteen
", "twenty",
		        "twenty one", "twenty two", "twenty three", "twenty four",
		        "twenty five", "twenty six", "twenty seven", "twenty eight",
		        "twenty nine", "thirty", "thirty one", "thirty two", "thirty four",
		        "thirty five", "thirty six", "thirty seven", "thirty eight",
		        "thirty nine", "fourty"
		};

		// Check the test deque is not null
		assert (test_deque != null);

		// Check normal LIFO behavior
		for (int i = 0; i < to_offer.length; i++) {
			assert (test_deque.offer_head (to_offer[i]));
			assert (test_deque.size == i + 1);
		}
		for (int i = to_offer.length - 1; i >= 0; i--) {
			assert (test_deque.peek_head () == to_offer[i]);
			assert (test_deque.poll_head () == to_offer[i]);
			assert (test_deque.size == i);
		}

		// Check normal behavior when no element
		assert (test_deque.peek_head () == null);
		assert (test_deque.poll_head () == null);

		// Check drain with LIFO behavior
		recipient.clear ();
		for (int i = 0; i < to_offer.length; i++) {
			assert (test_deque.offer_head (to_offer[i]));
		}
		assert (test_deque.size == to_offer.length);
		assert (test_deque.drain_head (recipient, 1) == 1);
		assert (test_deque.size == to_offer.length - 1);
		assert (recipient.size == 1);
		assert (recipient.get (0) == to_offer[to_offer.length - 1]);
		assert (test_deque.drain_head (recipient) == to_offer.length - 1);
		assert (test_deque.size == 0);
		assert (recipient.size == to_offer.length);
		for (int i = 1; i < to_offer.length; i++) {
			assert (recipient.get (i) == to_offer[to_offer.length - i - 1]);
		}

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
		string[] to_offer = {
		        "one", "two", "three", "four", "five", "six", "seven", "
eight",
		        "nine", "ten", "eleven", "twelve", "thirteen", "fourteen
",
		        "fifteen", "sixteen", "seventeen", "eighteen", "nineteen
", "twenty",
		        "twenty one", "twenty two", "twenty three", "twenty four",
		        "twenty five", "twenty six", "twenty seven", "twenty eight",
		        "twenty nine", "thirty", "thirty one", "thirty two", "thirty four",
		        "thirty five", "thirty six", "thirty seven", "thirty eight",
		        "thirty nine", "fourty"
		};

		// Check the test deque is not null
		assert (test_deque != null);

		// Check normal LIFO behavior
		for (int i = 0; i < to_offer.length; i++) {
			assert (test_deque.offer_tail (to_offer[i]));
			assert (test_deque.size == i + 1);
		}
		for (int i = 0; i < to_offer.length; i++) {
			assert (test_deque.peek_tail () == to_offer[to_offer.length - i - 1]);
			assert (test_deque.poll_tail () == to_offer[to_offer.length - i - 1]);
			assert (test_deque.size == to_offer.length - i - 1);
		}

		// Check normal behavior when no element
		assert (test_deque.peek_tail () == null);
		assert (test_deque.poll_tail () == null);

		// Check drain with LIFO behavior
		recipient.clear ();
		for (int i = 0; i < to_offer.length; i++) {
			assert (test_deque.offer_tail (to_offer[i]));
		}
		assert (test_deque.size == to_offer.length);
		assert (test_deque.drain_tail (recipient, 1) == 1);
		assert (test_deque.size == to_offer.length - 1);
		assert (recipient.size == 1);
		assert (recipient.get (0) == to_offer[to_offer.length - 1]);
		assert (test_deque.drain_tail (recipient) == to_offer.length - 1);
		assert (test_deque.size == 0);
		assert (recipient.size == to_offer.length);
		for (int i = 1; i < to_offer.length; i++) {
			assert (recipient.get (i) == to_offer[to_offer.length - i - 1]);
		}

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

