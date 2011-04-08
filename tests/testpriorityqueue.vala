/* testpriorityqueue.vala
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
 * Authors:
 * 	Didier 'Ptitjes Villevalois <ptitjes@free.fr>
 */

using Gee;

public class PriorityQueueTests : QueueTests {

	public PriorityQueueTests () {
		base ("PriorityQueue");
		add_test ("[PriorityQueue] poll gives minimum", test_poll_gives_minimum);
	}

	public override void set_up () {
		test_collection = new PriorityQueue<string> ();
	}

	public override void tear_down () {
		test_collection = null;
	}

	private void test_poll_gives_minimum () {
		var test_queue = test_collection as Gee.Queue<string>;

		// Check the queue exists
		assert (test_queue != null);

		// Add two elements and remove the greatest
		assert (test_queue.offer ("one"));
		assert (test_queue.offer ("two"));
		assert (test_queue.peek () == "one");
		assert (test_queue.remove ("two"));
		assert (test_queue.peek () == "one");
		assert (test_queue.poll () == "one");

		// Add twelve elements
		assert (test_queue.offer ("one"));
		assert (test_queue.offer ("two"));
		assert (test_queue.offer ("three"));
		assert (test_queue.offer ("four"));
		assert (test_queue.offer ("five"));
		assert (test_queue.offer ("six"));
		assert (test_queue.offer ("seven"));
		assert (test_queue.offer ("eight"));
		assert (test_queue.offer ("nine"));
		assert (test_queue.offer ("ten"));
		assert (test_queue.offer ("eleven"));
		assert (test_queue.offer ("twelve"));

		assert (test_queue.peek () == "eight");
		assert (test_queue.poll () == "eight");
		assert (test_queue.peek () == "eleven");
		assert (test_queue.poll () == "eleven");
		assert (test_queue.peek () == "five");
		assert (test_queue.poll () == "five");
		assert (test_queue.peek () == "four");
		assert (test_queue.poll () == "four");
		assert (test_queue.peek () == "nine");
		assert (test_queue.poll () == "nine");
		assert (test_queue.peek () == "one");
		assert (test_queue.poll () == "one");
		assert (test_queue.peek () == "seven");
		assert (test_queue.poll () == "seven");
		assert (test_queue.peek () == "six");
		assert (test_queue.poll () == "six");
		assert (test_queue.peek () == "ten");
		assert (test_queue.poll () == "ten");
		assert (test_queue.peek () == "three");
		assert (test_queue.poll () == "three");
		assert (test_queue.peek () == "twelve");
		assert (test_queue.poll () == "twelve");
		assert (test_queue.peek () == "two");
		assert (test_queue.poll () == "two");

		// Add decreasing elements
		assert (test_queue.offer ("2"));
		assert (test_queue.offer ("1"));

		
		assert (test_queue.peek () == "1");
		assert (test_queue.poll () == "1");
		assert (test_queue.peek () == "2");
		assert (test_queue.poll () == "2");
	}
}
