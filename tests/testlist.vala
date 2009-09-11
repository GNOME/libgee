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

	public ListTests (string name) {
		base (name);
		add_test ("[List] iterator is ordered", test_iterator_is_ordered);
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
	}

	public void test_iterator_is_ordered () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check iterate empty list
		var iterator = test_list.iterator ();
		assert (! iterator.next());

		// Check iterate list
		assert (test_list.add ("one"));
		assert (test_list.add ("two"));
		assert (test_list.add ("three"));
		assert (test_list.add ("one"));

		iterator = test_list.iterator ();
		assert (iterator.next());
		assert (iterator.get () == "one");
		assert (iterator.next());
		assert (iterator.get () == "two");
		assert (iterator.next());
		assert (iterator.get () == "three");
		assert (iterator.next());
		assert (iterator.get () == "one");
		assert (! iterator.next());
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

		// Check the test list is not null
		assert (test_list != null);

		// Check get for empty list
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.get (0);
			return;
		}
		Test.trap_assert_failed ();

		// Check get for valid index in list with one element
		assert (test_list.add ("one"));
		assert (test_list.get (0) == "one");

		// Check get for indexes out of range
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.get (1);
			return;
		}
		Test.trap_assert_failed ();

		// Check get for invalid index number
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.get (-1);
			return;
		}
		Test.trap_assert_failed ();

		// Check get for valid indexes in list with multiple element
		assert (test_list.add ("two"));
		assert (test_list.add ("three"));
		assert (test_list.get (0) == "one");
		assert (test_list.get (1) == "two");
		assert (test_list.get (2) == "three");

		// Check get if list is cleared and empty again
		test_list.clear ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.get (0);
			return;
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
			return;
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
			return;
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
			return;
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
			return;
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
			return;
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
			return;
		}
		Test.trap_assert_failed ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.remove_at (1);
			return;
		}
		Test.trap_assert_failed ();

		// add 5 items
		assert (test_list.add ("one"));
		assert (test_list.add ("two"));
		assert (test_list.add ("three"));
		assert (test_list.add ("four"));
		assert (test_list.add ("five"));
		assert (test_list.size == 5);

		// Check remove_at first
		assert (test_list.remove_at (0) == "one");
		assert (test_list.size == 4);
		assert (test_list.get (0) == "two");
		assert (test_list.get (1) == "three");
		assert (test_list.get (2) == "four");
		assert (test_list.get (3) == "five");

		// Check remove_at last
		assert (test_list.remove_at (3) == "five");
		assert (test_list.size == 3);
		assert (test_list.get (0) == "two");
		assert (test_list.get (1) == "three");
		assert (test_list.get (2) == "four");

		// Check remove_at in between
		assert (test_list.remove_at (1) == "three");
		assert (test_list.size == 2);
		assert (test_list.get (0) == "two");
		assert (test_list.get (1) == "four");

		// Check remove_at when index out of range
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.remove_at (2);
			return;
		}
		Test.trap_assert_failed ();

		// Check remove_at when invalid index
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.remove_at (-1);
			return;
		}
		Test.trap_assert_failed ();
	}

	public void test_index_of () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check empty list
		assert (test_list.index_of ("one") == -1);

		// Check one item
		assert (test_list.add ("one"));
		assert (test_list.index_of ("one") == 0);
		assert (test_list.index_of ("two") == -1);

		// Check more items
		assert (test_list.add ("two"));
		assert (test_list.add ("three"));
		assert (test_list.add ("four"));
		assert (test_list.index_of ("one") == 0);
		assert (test_list.index_of ("two") == 1);
		assert (test_list.index_of ("three") == 2);
		assert (test_list.index_of ("four") == 3);
		assert (test_list.index_of ("five") == -1);
	}

	public void test_first () {
		var test_list = test_collection as Gee.List<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check first for empty list
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			test_list.first ();
			return;
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
			return;
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
			return;
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
			return;
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
			return;
		}
		Test.trap_assert_failed ();

		test_list.clear ();
		dummy.clear ();

		// Insert all in the beginnig
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
}
