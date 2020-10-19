/* testlist.vala
 *
 * Copyright (C) 2008  Jürg Billeter
 * Copyright (C) 2009  Didier Villevalois, Julien Peeters
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
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using GLib;
using Gee;

public abstract class ListTests : CollectionTests {

	protected ListTests (string name) {
		base (name);
		add_test ("[List] iterator is ordered", test_iterator_is_ordered);
		add_test ("[List] list iterator", test_list_iterator);
		add_test ("[List] duplicates are retained",
		          test_duplicates_are_retained);
		add_test ("[List] get", test_get);
		add_test ("[List] set", test_set);
		add_test ("[List] insert", test_insert);
		add_test ("[List] remove_at", test_remove_at);
		add_test ("[List] index_of", test_index_of);
		add_test ("[List] first", test_first);
		add_test ("[List] last", test_last);
		add_test ("[List] insert_all", test_insert_all);
		add_test ("[List] slice", test_slice);
	}

	public void test_iterator_is_ordered () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check iterate empty list
		var iterator = test_list.iterator ();
		assert (! iterator.next ());

		unowned string[] data = TestData.get_data ();
		unowned uint[] idx = TestData.get_drawn_numbers ();

		// Check iterate list
		foreach (unowned string s in data) {
			assert (test_list.add (s));
		}
		foreach (uint i in idx) {
			assert (test_list.add (data[i]));
		}

		iterator = test_list.iterator ();
		foreach (unowned string s in data) {
			assert (iterator.next());
			assert (iterator.get () == s);
		}
		foreach (uint i in idx) {
			assert (iterator.next());
			assert (iterator.get () == data[i]);
		}
		assert (! iterator.next ());
	}

	public void test_list_iterator () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check iterate empty list
		var iterator = test_list.list_iterator ();
		assert (! iterator.has_next ());
		assert (! iterator.next ());

		// Check iterate list
		assert (test_list.add ("one"));
		assert (test_list.add ("two"));
		assert (test_list.add ("three"));

		iterator = test_list.list_iterator ();
		assert (iterator.next());
		assert (iterator.get () == "one");
		assert (iterator.index () == 0);
		iterator.set ("new one");
		assert (iterator.next());
		assert (iterator.get () == "two");
		assert (iterator.index () == 1);
		iterator.set ("new two");
		assert (test_list.size == 3);
		assert (iterator.index () == 1);
		iterator.add ("after two");
		assert (test_list.size == 4);
		assert (iterator.index () == 2);
		assert (iterator.next());
		assert (iterator.get () == "three");
		assert (iterator.index () == 3);
		iterator.set ("new three");
		assert (! iterator.has_next ());
		assert (! iterator.next ());

		iterator = test_list.list_iterator ();
		assert (iterator.next ());
		assert (iterator.get () == "new one");
		assert (iterator.index () == 0);
	}

	public virtual void test_duplicates_are_retained () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		assert (test_list.add ("one"));
		assert (test_list.contains ("one"));
		assert (test_list.size == 1);

		assert (test_list.add ("one"));
		assert (test_list.contains ("one"));
		assert (test_list.size == 2);

		assert (test_list.add ("one"));
		assert (test_list.contains ("one"));
		assert (test_list.size == 3);

		assert (test_list.remove ("one"));
		assert (test_list.contains ("one"));
		assert (test_list.size == 2);

		assert (test_list.remove ("one"));
		assert (test_list.contains ("one"));
		assert (test_list.size == 1);

		assert (test_list.remove ("one"));
		assert (!test_list.contains ("one"));
		assert (test_list.size == 0);
	}

	public void test_get () {
		var test_list = test_collection as Gee.List<string>;

		unowned string[] data = TestData.get_data ();
		unowned uint[] idx = TestData.get_drawn_numbers ();

		// Check the test list is not null
		assert (test_list != null);

		// Check get for empty list
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.get (0);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		// Check get for valid index in list with one element
		assert (test_list.add (data[0]));
		assert (test_list.get (0) == data[0]);

		// Check get for indexes out of range
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.get (1);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		// Check get for invalid index number
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.get (-1);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		// Check get for valid indexes in list with multiple element
		for (int i = 1; i < data.length; i++) {
			assert (test_list.add (data[i]));
		}
		foreach (uint j in idx) {
			assert (test_list.get ((int)j) == data[j]);
		}

		// Check get if list is cleared and empty again
		test_list.clear ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.get (0);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
	}

	public void test_set () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check set when list is empty
		assert (test_list.size == 0);
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.set (0, "zero");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (test_list.size == 0);

		// Check set when one item is in list
		assert (test_list.add ("one")); // Add item "one"
		assert (test_list.size == 1);
		assert (test_list.get (0) == "one");

		test_list.set (0, "two"); // Set the item to value 2
		assert (test_list.size == 1);
		assert (test_list.get (0) == "two");

		// Check set when index out of range
		assert (test_list.size == 1);
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.set (1, "zero");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (test_list.size == 1);
	}

	public void test_insert () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check inserting in empty list
		// Inserting at index 1
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.insert (1, "zero");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		// Inserting at index 0
		assert (test_list.size == 0);
		test_list.insert (0, "one");
		assert (test_list.size == 1);
		assert (test_list.get (0) == "one");

		// Check insert to the beginning
		test_list.insert (0, "two");
		assert (test_list.get (0) == "two");
		assert (test_list.get (1) == "one");

		// Check insert in between
		test_list.insert (1, "three");
		assert (test_list.get (0) == "two");
		assert (test_list.get (1) == "three");
		assert (test_list.get (2) == "one");

		// Check insert into index out of current range
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.insert (4, "four");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		// Check insert to the end
		test_list.insert (3, "four");
		assert (test_list.get (0) == "two");
		assert (test_list.get (1) == "three");
		assert (test_list.get (2) == "one");
		assert (test_list.get (3) == "four");

		// Check insert into invalid index
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.insert (-1, "zero");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
	}

	public void test_remove_at () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check removing in empty list
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.remove_at (0);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.remove_at (1);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		unowned string[] data = TestData.get_data ();
		unowned uint[] idx = TestData.get_drawn_numbers ();

		// add 5 items
		foreach (unowned string s in data) {
			assert (test_list.add (s));
		}
		assert (test_list.size == data.length);

		// Check remove_at first
		assert (test_list.remove_at (0) == data[0]);
		assert (test_list.size == data.length - 1);
		for (int i = 1; i < data.length - 1; i++) {
			assert (test_list.get (i - 1) == data[i]);
		}

		// Check remove_at last
		assert (test_list.remove_at (data.length - 2) == data[data.length - 1]);
		assert (test_list.size == data.length - 2);
		for (int i = 1; i < data.length - 2; i++) {
			assert (test_list.get (i - 1) == data[i]);
		}

		// Check remove_at in between
		uint expected_size = data.length - 2;
		for (uint i = 0; i < idx.length; i++) {
			int to_remove = (int)idx[i] - 1;
			if (idx[i] == data.length - 1 || idx[i] == 0) {
				// Skip last or first element, which was already removed
				continue;
			}
			for (uint j = 0; j < i; j++) {
				if (idx[j] < idx[i]) {
					if (idx[j] == data.length - 1 || idx[j] == 0) {
						// Last and first element were not removed
						continue;
					}
					to_remove--;
				}
			}
			assert (test_list.remove_at (to_remove) == data[idx[i]]);
			assert (test_list.size == --expected_size);
		}
		int current_idx = 0;
		for (uint i = 1; i < data.length - 1; i++) {
			bool skip = false;
			for (int j = 0; j < idx.length; j++) {
				if (i == idx[j]) {
					skip = true;
					break;
				}
			}
			if (skip) {
				continue;
			}
			assert (test_list.get(current_idx++) == data[i]);
		}
		assert (test_list.size == current_idx);

		// Check remove_at when index out of range
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.remove_at (current_idx);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		// Check remove_at when invalid index
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.remove_at (-1);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
	}

	public void test_index_of () {
		var test_list = test_collection as Gee.List<string>;

		unowned string[] data = TestData.get_data ();
		unowned uint[] idx = TestData.get_drawn_numbers ();

		// Check the test list is not null
		assert (test_list != null);

		// Check empty list
		assert (test_list.index_of (data[0]) == -1);

		// Check one item
		assert (test_list.add (data[0]));
		assert (test_list.index_of (data[0]) == 0);
		assert (test_list.index_of (data[1]) == -1);

		// Check more items
		for (int i = 1; i < data.length; i++) {
			assert (test_list.add (data[i]));
			foreach (uint j in idx) {
				if (j <= i) {
					assert (test_list.index_of (data[j]) == j);
				} else {
					assert (test_list.index_of (data[j]) == -1);
				}
			}
		}
	}

	public void test_first () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check first for empty list
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.first ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		// Check first for list with one element
		assert (test_list.add ("one"));
		assert (test_list.first () == "one");
		assert (test_list.first () == test_list.get (0));

		// Check first for for list with multiple element
		assert (test_list.add ("two"));
		assert (test_list.add ("three"));
		assert (test_list.first () == "one");
		assert (test_list.first () == test_list.get (0));

		// Check first if list is cleared and empty again
		test_list.clear ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.first ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
	}

	public void test_last () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check last for empty list
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.last ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		// Check last for list with one element
		assert (test_list.add ("one"));
		assert (test_list.last () == "one");
		assert (test_list.last () == test_list.get (test_list.size - 1));

		// Check last for for list with multiple element
		assert (test_list.add ("two"));
		assert (test_list.add ("three"));
		assert (test_list.last () == "three");
		assert (test_list.last () == test_list.get (test_list.size - 1));

		// Check last if list is cleared and empty again
		test_list.clear ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.last ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
	}

	public void test_insert_all () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		var dummy = new ArrayList<string> ();

		// Insert an empty list
		assert (test_list.add ("zero"));
		assert (test_list.add ("one"));
		assert (test_list.add ("two"));

		assert (test_list.size == 3);
		assert (dummy.is_empty);

		test_list.insert_all (0, dummy);

		assert (test_list.size == 3);
		assert (dummy.is_empty);

		test_list.clear ();
		dummy.clear ();

		// Insert into an empty list at index 0
		assert (dummy.add ("zero"));
		assert (dummy.add ("one"));
		assert (dummy.add ("two"));

		assert (test_list.is_empty);
		assert (dummy.size == 3);

		test_list.insert_all (0, dummy);

		assert (test_list.size == 3);
		assert (dummy.size == 3);

		test_list.clear ();
		dummy.clear ();

		// Insert all into empty list as index 1
		assert (dummy.add ("zero"));
		assert (dummy.add ("one"));
		assert (dummy.add ("two"));

		assert (test_list.is_empty);

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.insert_all (1, dummy);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		test_list.clear ();
		dummy.clear ();

		// Insert all in the beginning
		assert (test_list.add ("three"));
		assert (test_list.add ("four"));
		assert (test_list.add ("five"));

		assert (dummy.add ("zero"));
		assert (dummy.add ("one"));
		assert (dummy.add ("two"));

		assert (test_list.size == 3);
		assert (dummy.size == 3);

		test_list.insert_all (0, dummy);

		assert (test_list.size == 6);
		assert (dummy.size == 3);

		assert (test_list.get (0) == "zero");
		assert (test_list.get (1) == "one");
		assert (test_list.get (2) == "two");
		assert (test_list.get (3) == "three");
		assert (test_list.get (4) == "four");
		assert (test_list.get (5) == "five");

		test_list.clear ();
		dummy.clear ();

		// Insert all in the middle
		assert (test_list.add ("zero"));
		assert (test_list.add ("one"));
		assert (test_list.add ("five"));
		assert (test_list.add ("six"));

		assert (dummy.add ("two"));
		assert (dummy.add ("three"));
		assert (dummy.add ("four"));

		assert (test_list.size == 4);
		assert (dummy.size == 3);

		test_list.insert_all (2, dummy);

		assert (test_list.size == 7);
		assert (dummy.size == 3);

		assert (test_list.get (0) == "zero");
		assert (test_list.get (1) == "one");
		assert (test_list.get (2) == "two");
		assert (test_list.get (3) == "three");
		assert (test_list.get (4) == "four");
		assert (test_list.get (5) == "five");
		assert (test_list.get (6) == "six");

		test_list.clear ();
		dummy.clear ();

		// Insert all in at the end
		assert (test_list.add ("zero"));
		assert (test_list.add ("one"));
		assert (test_list.add ("two"));

		assert (dummy.add ("three"));
		assert (dummy.add ("four"));
		assert (dummy.add ("five"));

		assert (test_list.size == 3);
		assert (dummy.size == 3);

		test_list.insert_all (3, dummy);

		assert (test_list.size == 6);
		assert (dummy.size == 3);

		assert (test_list.get (0) == "zero");
		assert (test_list.get (1) == "one");
		assert (test_list.get (2) == "two");
		assert (test_list.get (3) == "three");
		assert (test_list.get (4) == "four");
		assert (test_list.get (5) == "five");
	}

	public void test_slice () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);
		Gee.List<string> dummy;

		// Check first for empty list
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			dummy = test_list.slice (1, 4);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		// Check for list with some items
		assert (test_list.add ("zero"));
		assert (test_list.add ("one"));
		assert (test_list.add ("two"));
		assert (test_list.add ("three"));
		assert (test_list.add ("four"));
		assert (test_list.add ("five"));
		assert (test_list.size == 6);

		dummy = test_list.slice (1, 4);
		assert (dummy.size == 3);
		assert (test_list.size == 6);

		assert (dummy.get (0) == "one");
		assert (dummy.get (1) == "two");
		assert (dummy.get (2) == "three");

		// Check for invalid indices
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			dummy = test_list.slice (0, 9);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
	}
}
