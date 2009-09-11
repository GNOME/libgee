/* testqueue.vala
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

public abstract class QueueTests : CollectionTests {

	public QueueTests (string name) {
		base (name);
		add_test ("[Queue] capacity bound", test_capacity_bound);
		add_test ("[Queue] one element operation", test_one_element_operation);
	}

	public void test_capacity_bound () {
		var test_queue = test_collection as Gee.Queue<string>;

		// Check the test queue is not null
		assert (test_queue != null);

		if (test_queue.capacity == null) {
			// Unbounded capacity
			assert (test_queue.remaining_capacity == null);
			assert (! test_queue.is_full);
		} else {
			// Bounded capacity
			assert (test_queue.is_empty);

			// Check that we can fill it completely
			int capacity = test_queue.capacity;
			for (int i = 1; i <= capacity; i++) {
				assert (! test_queue.is_full);
				assert (test_queue.offer ("one") == true);
				assert (test_queue.remaining_capacity == capacity - i);
			}
			assert (test_queue.is_full);

			// Check that we can empty it completely
			for (int i = 1; i <= capacity; i++) {
				assert (test_queue.poll () == "one");
				assert (! test_queue.is_full);
				assert (test_queue.remaining_capacity == i);
			}
			assert (test_queue.is_empty);
		}
	}

	public void test_one_element_operation () {
		var test_queue = test_collection as Gee.Queue<string>;
		ArrayList<string> recipient = new ArrayList<string> ();

		// Check the test queue is not null
		assert (test_queue != null);

		// Check offer one element when there is none yet
		assert (test_queue.offer ("one") == true);
		assert (test_queue.peek () == "one");
		assert (test_queue.size == 1);
		assert (! test_queue.is_empty);

		// Check poll when there is one element
		assert (test_queue.poll () == "one");
		assert (test_queue.size == 0);
		assert (test_queue.is_empty);

		// Check poll when there is no element
		assert (test_queue.peek () == null);
		assert (test_queue.poll () == null);

		// Check drain one element when there is one
		recipient.clear ();
		assert (test_queue.offer ("one") == true);
		assert (test_queue.drain (recipient, 1) == 1);
		assert (test_queue.size == 0);
		assert (test_queue.is_empty);
		assert (recipient.size == 1);
		assert (recipient.get (0) == "one");

		// Check drain one element when there is none
		recipient.clear ();
		assert (test_queue.drain (recipient, 1) == 0);
		assert (test_queue.size == 0);
		assert (test_queue.is_empty);
		assert (recipient.size == 0);

		// Check drain all elements when there is one
		recipient.clear ();
		assert (test_queue.offer ("one") == true);
		assert (test_queue.drain (recipient) == 1);
		assert (test_queue.size == 0);
		assert (test_queue.is_empty);
		assert (recipient.size == 1);
		assert (recipient.get (0) == "one");
	}
}
