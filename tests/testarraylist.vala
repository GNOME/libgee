/* testhashmap.vala
 *
 * Copyright (C) 2008  Jürg Billeter
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
 */

using GLib;
using Gee;

public class ArrayListTests : CollectionTests {

	public ArrayListTests () {
		base ("ArrayList");

		// Methods of List interface
		add_test("get", test_arraylist_get);
		add_test("set", test_arraylist_set);
		add_test("insert", test_arraylist_insert);
		add_test("remove_at", test_arraylist_remove_at);
		add_test("index_of", test_arraylist_index_of);

		// Methods of Collection interface
		add_test("add", test_arraylist_add);
		add_test("clear", test_arraylist_clear);
		add_test("contains", test_arraylist_contains);
		add_test("remove", test_arraylist_remove);
		add_test("size", test_arraylist_size);

		// Methods of Iterable interface
		add_test("iterator", test_arraylist_iterator);
	}

	public override void setup () {
		int_collection = new ArrayList<int> ();
		string_collection = new ArrayList<string> (str_equal);
		object_collection = new ArrayList<Object> ();
	}

	public override void teardown () {
		int_collection = null;
		string_collection = null;
		object_collection = null;
	}

	void test_arraylist_get () {
		var arraylistOfString = string_collection as Gee.List<string>;

		// Check get for empty list
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.get (0);
			return;
		}
		Test.trap_assert_failed ();

		// Check get for valid index in list with one element
		arraylistOfString.add ("1");
		assert (arraylistOfString.get (0) == "1");

		// Check get for indexes out of range
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.get (1);
			return;
		}
		Test.trap_assert_failed ();

		// Check get for invalid index number
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.get (-1);
			return;
		}
		Test.trap_assert_failed ();

		// Check get for valid indexes in list with multiple element
		arraylistOfString.add ("2");
		arraylistOfString.add ("3");
		assert (arraylistOfString.get (0) == "1");
		assert (arraylistOfString.get (1) == "2");
		assert (arraylistOfString.get (2) == "3");

		// Check get if list is cleared and empty again
		arraylistOfString.clear ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.get (0);
			return;
		}
		Test.trap_assert_failed ();
	}

	void test_arraylist_set () {
		var arraylistOfString = string_collection as Gee.List<string>;

		// Check set when list is empty.
		assert (arraylistOfString.size == 0);
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.set (0, "0");
			return;
		}
		Test.trap_assert_failed ();
		assert (arraylistOfString.size == 0);

		// Check set when one item is in list
		arraylistOfString.add ("1"); // Add item "1"
		assert (arraylistOfString.size == 1);
		assert (arraylistOfString.get (0) == "1");

		arraylistOfString.set (0, "2"); // Set the item to value 2
		assert (arraylistOfString.size == 1);
		assert (arraylistOfString.get (0) == "2");

		// Check set when index out of range
		assert (arraylistOfString.size == 1);
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.set (1, "0");
			return;
		}
		Test.trap_assert_failed ();
		assert (arraylistOfString.size == 1);
	}

	void test_arraylist_insert () {
		var arraylistOfString = string_collection as Gee.List<string>;

		// Check inserting in empty list
		// Inserting at index 1
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.insert (1, "0");
			return;
		}
		Test.trap_assert_failed ();

		// Inserting at index 0
		assert (arraylistOfString.size == 0);
		arraylistOfString.insert (0, "10");
		assert (arraylistOfString.size == 1);
		assert (arraylistOfString.get (0) == "10");

		// Check insert to the beginning
		arraylistOfString.insert (0, "5");
		assert (arraylistOfString.get (0) == "5");
		assert (arraylistOfString.get (1) == "10");

		// Check insert in between
		arraylistOfString.insert (1, "7");
		assert (arraylistOfString.get (0) == "5");
		assert (arraylistOfString.get (1) == "7");
		assert (arraylistOfString.get (2) == "10");

		// Check insert into index out of current range
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.insert (4, "20");
			return;
		}
		Test.trap_assert_failed ();

		// Check insert to the end
		arraylistOfString.insert (3, "20");
		assert (arraylistOfString.get (0) == "5");
		assert (arraylistOfString.get (1) == "7");
		assert (arraylistOfString.get (2) == "10");
		assert (arraylistOfString.get (3) == "20");

		// Check insert into invalid index
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.insert (-1, "0");
			return;
		}
		Test.trap_assert_failed ();

	}

	void test_arraylist_remove_at () {
		var arraylistOfString = string_collection as Gee.List<string>;

		// Check removing in empty list
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.remove_at (0);
			return;
		}
		Test.trap_assert_failed ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.remove_at (1);
			return;
		}
		Test.trap_assert_failed ();

		// add 5 items
		arraylistOfString.add ("1");
		arraylistOfString.add ("2");
		arraylistOfString.add ("3");
		arraylistOfString.add ("4");
		arraylistOfString.add ("5");
		assert (arraylistOfString.size == 5);

		// Check remove_at first
		arraylistOfString.remove_at (0);
		assert (arraylistOfString.size == 4);
		assert (arraylistOfString.get (0) == "2");
		assert (arraylistOfString.get (1) == "3");
		assert (arraylistOfString.get (2) == "4");
		assert (arraylistOfString.get (3) == "5");

		// Check remove_at last
		arraylistOfString.remove_at (3);
		assert (arraylistOfString.size == 3);
		assert (arraylistOfString.get (0) == "2");
		assert (arraylistOfString.get (1) == "3");
		assert (arraylistOfString.get (2) == "4");

		// Check remove_at in between
		arraylistOfString.remove_at (1);
		assert (arraylistOfString.size == 2);
		assert (arraylistOfString.get (0) == "2");
		assert (arraylistOfString.get (1) == "4");

		// Check remove_at when index out of range
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.remove_at (2);
			return;
		}
		Test.trap_assert_failed ();

		// Check remove_at when invalid index
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
			arraylistOfString.remove_at (-1);
			return;
		}
		Test.trap_assert_failed ();
	}

	void test_arraylist_index_of () {
		var arraylistOfString = string_collection as Gee.List<string>;
		// Check empty list
		assert (arraylistOfString.index_of ("one") == -1);

		// Check one item
		arraylistOfString.add ("one");
		assert (arraylistOfString.index_of ("one") == 0);
		assert (arraylistOfString.index_of ("two") == -1);

		// Check more items
		arraylistOfString.add ("two");
		arraylistOfString.add ("three");
		arraylistOfString.add ("four");
		assert (arraylistOfString.index_of ("one") == 0);
		assert (arraylistOfString.index_of ("two") == 1);
		assert (arraylistOfString.index_of ("three") == 2);
		assert (arraylistOfString.index_of ("four") == 3);
		assert (arraylistOfString.index_of ("five") == -1);

		// Check list of ints
		var arraylistOfInt = int_collection as Gee.List<int>;

		// Check more items
		arraylistOfInt.add (1);
		arraylistOfInt.add (2);
		arraylistOfInt.add (3);
		assert (arraylistOfInt.index_of (1) == 0);
		assert (arraylistOfInt.index_of (2) == 1);
		assert (arraylistOfInt.index_of (3) == 2);
		assert (arraylistOfInt.index_of (4) == -1);

		// Check list of objects
		var arraylistOfObjects = object_collection as Gee.List<Object>;

		var object1 = new Object ();
		var object2 = new Object ();
		var object3 = new Object ();

		arraylistOfObjects.add (object1);
		arraylistOfObjects.add (object2);
		arraylistOfObjects.add (object3);

		assert (arraylistOfObjects.index_of (object1) == 0);
		assert (arraylistOfObjects.index_of (object2) == 1);
		assert (arraylistOfObjects.index_of (object3) == 2);

	}

	void test_arraylist_add () {
		var arraylistOfString = string_collection as Gee.List<string>;

		arraylistOfString.add ("42");
		assert (arraylistOfString.contains ("42"));
		assert (arraylistOfString.size == 1);

		// check for correct order of elements
		arraylistOfString.add ("43");
		arraylistOfString.add ("44");
		arraylistOfString.add ("45");
		assert (arraylistOfString.get (0) == "42");
		assert (arraylistOfString.get (1) == "43");
		assert (arraylistOfString.get (2) == "44");
		assert (arraylistOfString.get (3) == "45");
		assert (arraylistOfString.size == 4);

		// check adding of ints
		var arrayListOfInt = int_collection as Gee.List<int>;

		arrayListOfInt.add (42);
		assert (arrayListOfInt.contains (42));
		assert (arrayListOfInt.size == 1);

		// check adding of objects
		var arrayListOfGLibObject = new ArrayList<Object> ();

		var fooObject = new Object();
		arrayListOfGLibObject.add (fooObject);
		assert (arrayListOfGLibObject.contains (fooObject));
		assert (arrayListOfGLibObject.size == 1);

	}

	void test_arraylist_clear () {
		var arraylistOfString = string_collection as Collection<string>;
		assert (arraylistOfString.size == 0);

		// Check clear on empty list
		arraylistOfString.clear();
		assert (arraylistOfString.size == 0);

		// Check clear one item
		arraylistOfString.add ("1");
		assert (arraylistOfString.size == 1);
		arraylistOfString.clear();
		assert (arraylistOfString.size == 0);

		// Check clear multiple items
		arraylistOfString.add ("1");
		arraylistOfString.add ("2");
		arraylistOfString.add ("3");
		assert (arraylistOfString.size == 3);
		arraylistOfString.clear();
		assert (arraylistOfString.size == 0);
	}

	void test_arraylist_contains () {
		var arraylistOfString = string_collection as Gee.List<string>;

		// Check on empty list
		assert (!arraylistOfString.contains("1"));

		// Check items
		arraylistOfString.add ("10");
		assert (arraylistOfString.contains("10"));
		assert (!arraylistOfString.contains("20"));
		assert (!arraylistOfString.contains("30"));

		arraylistOfString.add ("20");
		assert (arraylistOfString.contains("10"));
		assert (arraylistOfString.contains("20"));
		assert (!arraylistOfString.contains("30"));

		arraylistOfString.add ("30");
		assert (arraylistOfString.contains("10"));
		assert (arraylistOfString.contains("20"));
		assert (arraylistOfString.contains("30"));

		// Clear and recheck
		arraylistOfString.clear();
		assert (!arraylistOfString.contains("10"));
		assert (!arraylistOfString.contains("20"));
		assert (!arraylistOfString.contains("30"));

		var arraylistOfInt = int_collection as Gee.List<int>;

		// Check items
		arraylistOfInt.add (10);
		assert (arraylistOfInt.contains(10));
		assert (!arraylistOfInt.contains(20));
		assert (!arraylistOfInt.contains(30));

		arraylistOfInt.add (20);
		assert (arraylistOfInt.contains(10));
		assert (arraylistOfInt.contains(20));
		assert (!arraylistOfInt.contains(30));

		arraylistOfInt.add (30);
		assert (arraylistOfInt.contains(10));
		assert (arraylistOfInt.contains(20));
		assert (arraylistOfInt.contains(30));

		// Clear and recheck
		arraylistOfInt.clear();
		assert (!arraylistOfInt.contains(10));
		assert (!arraylistOfInt.contains(20));
		assert (!arraylistOfInt.contains(30));
	}

	void test_arraylist_remove () {
		var arraylistOfString = string_collection as Gee.List<string>;

		// Check remove if list is empty
		arraylistOfString.remove("42");

		// Add 5 same elements
		arraylistOfString.add ("42");
		arraylistOfString.add ("42");
		arraylistOfString.add ("42");
		arraylistOfString.add ("42");
		arraylistOfString.add ("42");

		// Check remove one element
		arraylistOfString.remove ("42");
		assert (arraylistOfString.size == 4);
		assert (arraylistOfString.contains ("42"));

		// Check remove another one element
		arraylistOfString.remove ("42");
		assert (arraylistOfString.size == 3);
		assert (arraylistOfString.contains ("42"));

		// Clear the list to start from scratch
		arraylistOfString.clear();

		// Add 5 different elements
		arraylistOfString.add ("42");
		arraylistOfString.add ("43");
		arraylistOfString.add ("44");
		arraylistOfString.add ("45");
		arraylistOfString.add ("46");
		assert (arraylistOfString.size == 5);

		// Check remove first
		arraylistOfString.remove("42");
		assert (arraylistOfString.size == 4);
		assert (arraylistOfString.get (0) == "43");
		assert (arraylistOfString.get (1) == "44");
		assert (arraylistOfString.get (2) == "45");
		assert (arraylistOfString.get (3) == "46");

		// Check remove last
		arraylistOfString.remove("46");
		assert (arraylistOfString.size == 3);
		assert (arraylistOfString.get (0) == "43");
		assert (arraylistOfString.get (1) == "44");
		assert (arraylistOfString.get (2) == "45");

		// Check remove in between
		arraylistOfString.remove("44");
		assert (arraylistOfString.size == 2);
		assert (arraylistOfString.get (0) == "43");
		assert (arraylistOfString.get (1) == "45");

		// Check removing of int element
		var arraylistOfInt = int_collection as Gee.List<int>;

		// Add 5 different elements
		arraylistOfInt.add (42);
		arraylistOfInt.add (43);
		arraylistOfInt.add (44);
		arraylistOfInt.add (45);
		arraylistOfInt.add (46);
		assert (arraylistOfInt.size == 5);

		// Remove first
		arraylistOfInt.remove(42);
		assert (arraylistOfInt.size == 4);
		assert (arraylistOfInt.get (0) == 43);
		assert (arraylistOfInt.get (1) == 44);
		assert (arraylistOfInt.get (2) == 45);
		assert (arraylistOfInt.get (3) == 46);

		// Remove last
		arraylistOfInt.remove(46);
		assert (arraylistOfInt.size == 3);
		assert (arraylistOfInt.get (0) == 43);
		assert (arraylistOfInt.get (1) == 44);
		assert (arraylistOfInt.get (2) == 45);

		// Remove in between
		arraylistOfInt.remove(44);
		assert (arraylistOfInt.size == 2);
		assert (arraylistOfInt.get (0) == 43);
		assert (arraylistOfInt.get (1) == 45);
	}

	void test_arraylist_size () {
		var arraylist = string_collection as Gee.List<string>;

		// Check empty list
		assert (arraylist.size == 0);

		// Check when one item
		arraylist.add ("1");
		assert (arraylist.size == 1);

		// Check when more items
		arraylist.add ("2");
		assert (arraylist.size == 2);

		// Check when items cleared
		arraylist.clear();
		assert (arraylist.size == 0);
	}

	void test_arraylist_iterator () {
		var arraylistOfString = string_collection as Gee.List<string>;

		// Check iterate empty list
		var iterator = arraylistOfString.iterator ();
		assert (!iterator.next());

		// Check iterate list
		arraylistOfString.add ("42");
		arraylistOfString.add ("43");
		arraylistOfString.add ("44");

		iterator = arraylistOfString.iterator ();
		assert (iterator.next());
		assert (iterator.get () == "42");
		assert (iterator.next());
		assert (iterator.get () == "43");
		assert (iterator.next());
		assert (iterator.get () == "44");
		assert (!iterator.next());
	}
}

void main (string[] args) {
	Test.init (ref args);

	ArrayListTests tests = new ArrayListTests ();

	TestSuite.get_root ().add_suite (tests.get_suite ());

	Test.run ();
}

