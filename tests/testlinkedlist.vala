/* testlinkedlist.vala
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
 * Authors:
 * 	Jürg Billeter <j@bitron.ch>
 * 	Mark Lee <marklee@src.gnome.org> (port to LinkedList)
 */

using GLib;
using Gee;

void test_linkedlist_get () {
	var linkedlistOfString = new LinkedList<string> (str_equal);

	// Check get for empty list
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.get (0);
		return;
	}
	Test.trap_assert_failed ();

	// Check get for valid index in list with one element
	linkedlistOfString.add ("1");
	assert (linkedlistOfString.get (0) == "1");

	// Check get for indexes out of range
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.get (1);
		return;
	}
	Test.trap_assert_failed ();

	// Check get for invalid index number
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.get (-1);
		return;
	}
	Test.trap_assert_failed ();

	// Check get for valid indexes in list with multiple element
	linkedlistOfString.add ("2");
	linkedlistOfString.add ("3");
	assert (linkedlistOfString.get (0) == "1");
	assert (linkedlistOfString.get (1) == "2");
	assert (linkedlistOfString.get (2) == "3");

	// Check get if list is cleared and empty again
	linkedlistOfString.clear ();

	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.get (0);
		return;
	}
	Test.trap_assert_failed ();
}

void test_linkedlist_set () {
	var linkedlistOfString = new LinkedList<string> (str_equal);

	// Check set when list is empty.
	assert (linkedlistOfString.size == 0);
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.set (0, "0");
		return;
	}
	Test.trap_assert_failed ();
	assert (linkedlistOfString.size == 0);

	// Check set when one item is in list
	linkedlistOfString.add ("1"); // Add item "1"
	assert (linkedlistOfString.size == 1);
	assert (linkedlistOfString.get (0) == "1");

	linkedlistOfString.set (0, "2"); // Set the item to value 2
	assert (linkedlistOfString.size == 1);
	assert (linkedlistOfString.get (0) == "2");

	// Check set when index out of range
	assert (linkedlistOfString.size == 1);
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.set (1, "0");
		return;
	}
	Test.trap_assert_failed ();
	assert (linkedlistOfString.size == 1);
}

void test_linkedlist_insert () {
	var linkedlistOfString = new LinkedList<string> (str_equal);

	// Check inserting in empty list
	// Inserting at index 1
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.insert (1, "0");
		return;
	}
	Test.trap_assert_failed ();

	// Inserting at index 0
	assert (linkedlistOfString.size == 0);
	linkedlistOfString.insert (0, "10");
	assert (linkedlistOfString.size == 1);
	assert (linkedlistOfString.get (0) == "10");

	// Check insert to the beginning
	linkedlistOfString.insert (0, "5");
	assert (linkedlistOfString.get (0) == "5");
	assert (linkedlistOfString.get (1) == "10");

	// Check insert in between
	linkedlistOfString.insert (1, "7");
	assert (linkedlistOfString.get (0) == "5");
	assert (linkedlistOfString.get (1) == "7");
	assert (linkedlistOfString.get (2) == "10");

	// Check insert into index out of current range
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.insert (4, "20");
		return;
	}
	Test.trap_assert_failed ();

	// Check insert to the end
	linkedlistOfString.insert (3, "20");
	assert (linkedlistOfString.get (0) == "5");
	assert (linkedlistOfString.get (1) == "7");
	assert (linkedlistOfString.get (2) == "10");
	assert (linkedlistOfString.get (3) == "20");

	// Check insert into invalid index
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.insert (-1, "0");
		return;
	}
	Test.trap_assert_failed ();

}

void test_linkedlist_remove_at () {
	var linkedlistOfString = new LinkedList<string> (str_equal);

	// Check removing in empty list
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.remove_at (0);
		return;
	}
	Test.trap_assert_failed ();

	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.remove_at (1);
		return;
	}
	Test.trap_assert_failed ();

	// add 5 items
	linkedlistOfString.add ("1");
	linkedlistOfString.add ("2");
	linkedlistOfString.add ("3");
	linkedlistOfString.add ("4");
	linkedlistOfString.add ("5");
	assert (linkedlistOfString.size == 5);

	// Check remove_at first
	linkedlistOfString.remove_at (0);
	assert (linkedlistOfString.size == 4);
	assert (linkedlistOfString.get (0) == "2");
	assert (linkedlistOfString.get (1) == "3");
	assert (linkedlistOfString.get (2) == "4");
	assert (linkedlistOfString.get (3) == "5");

	// Check remove_at last
	linkedlistOfString.remove_at (3);
	assert (linkedlistOfString.size == 3);
	assert (linkedlistOfString.get (0) == "2");
	assert (linkedlistOfString.get (1) == "3");
	assert (linkedlistOfString.get (2) == "4");

	// Check remove_at in between
	linkedlistOfString.remove_at (1);
	assert (linkedlistOfString.size == 2);
	assert (linkedlistOfString.get (0) == "2");
	assert (linkedlistOfString.get (1) == "4");

	// Check remove_at when index out of range
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.remove_at (2);
		return;
	}
	Test.trap_assert_failed ();

	// Check remove_at when invalid index
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.remove_at (-1);
		return;
	}
	Test.trap_assert_failed ();
}

void test_linkedlist_index_of () {
	var linkedlistOfString = new LinkedList<string> (str_equal);
	// Check empty list
	assert (linkedlistOfString.index_of ("one") == -1);

	// Check one item
	linkedlistOfString.add ("one");
	assert (linkedlistOfString.index_of ("one") == 0);
	assert (linkedlistOfString.index_of ("two") == -1);

	// Check more items
	linkedlistOfString.add ("two");
	linkedlistOfString.add ("three");
	linkedlistOfString.add ("four");
	assert (linkedlistOfString.index_of ("one") == 0);
	assert (linkedlistOfString.index_of ("two") == 1);
	assert (linkedlistOfString.index_of ("three") == 2);
	assert (linkedlistOfString.index_of ("four") == 3);
	assert (linkedlistOfString.index_of ("five") == -1);

	// Check list of ints
	var linkedlistOfInt = new LinkedList<int> ();

	// Check more items
	linkedlistOfInt.add (1);
	linkedlistOfInt.add (2);
	linkedlistOfInt.add (3);
	assert (linkedlistOfInt.index_of (1) == 0);
	assert (linkedlistOfInt.index_of (2) == 1);
	assert (linkedlistOfInt.index_of (3) == 2);
	assert (linkedlistOfInt.index_of (4) == -1);

	// Check list of objects
	var linkedlistOfObjects = new LinkedList<Object> ();

	var object1 = new Object ();
	var object2 = new Object ();
	var object3 = new Object ();
	var object4 = new Object ();

	linkedlistOfObjects.add (object1);
	linkedlistOfObjects.add (object2);
	linkedlistOfObjects.add (object3);
	linkedlistOfObjects.add (object4);

	assert (linkedlistOfObjects.index_of (object1) == 0);
	assert (linkedlistOfObjects.index_of (object2) == 1);
	assert (linkedlistOfObjects.index_of (object3) == 2);
	assert (linkedlistOfObjects.index_of (object4) == 3);

}

void test_linkedlist_slice () {
	var linkedlistOfString = new LinkedList<string> (str_equal);
	Gee.List<string> slicedLinkedListOfString;
	// Check empty list
	assert (linkedlistOfString.slice (0, 0).size == 0);

	// Check one item
	linkedlistOfString.add ("one");
	slicedLinkedListOfString = linkedlistOfString.slice (0, 1);
	assert (slicedLinkedListOfString.size == 1);
	assert (slicedLinkedListOfString.get (0) == "one");

	// Check more items
	linkedlistOfString.add ("two");
	linkedlistOfString.add ("three");
	linkedlistOfString.add ("four");
	slicedLinkedListOfString = linkedlistOfString.slice (1, 2);
	assert (slicedLinkedListOfString.size == 1);
	assert (slicedLinkedListOfString.get (0) == "two");
	slicedLinkedListOfString = linkedlistOfString.slice (2, 4);
	assert (slicedLinkedListOfString.size == 2);
	assert (slicedLinkedListOfString.get (0) == "three");
	assert (slicedLinkedListOfString.get (1) == "four");

	// Check slice when start/stop out of range
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.slice (-1, 0);
		return;
	}
	Test.trap_assert_failed ();
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.slice (0, -1);
		return;
	}
	Test.trap_assert_failed ();

	// Check slice when start > stop
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.slice (1, 0);
		return;
	}
	Test.trap_assert_failed ();

	// Check slice when stop > size
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		linkedlistOfString.slice (1, 5);
		return;
	}
	Test.trap_assert_failed ();
}

void test_linkedlist_add () {
	var linkedlistOfString = new LinkedList<string> (str_equal);

	linkedlistOfString.add ("42");
	assert (linkedlistOfString.contains ("42"));
	assert (linkedlistOfString.size == 1);

	// check for correct order of elements
	linkedlistOfString.add ("43");
	linkedlistOfString.add ("44");
	linkedlistOfString.add ("45");
	assert (linkedlistOfString.get (0) == "42");
	assert (linkedlistOfString.get (1) == "43");
	assert (linkedlistOfString.get (2) == "44");
	assert (linkedlistOfString.get (3) == "45");
	assert (linkedlistOfString.size == 4);

	// check adding of ints
	var linkedlistOfInt = new LinkedList<int> ();

	linkedlistOfInt.add (42);
	assert (linkedlistOfInt.contains (42));
	assert (linkedlistOfInt.size == 1);

	// check adding of objects
	var linkedlistOfGLibObject = new LinkedList<Object> ();

	var fooObject = new Object ();
	linkedlistOfGLibObject.add (fooObject);
	assert (linkedlistOfGLibObject.contains (fooObject));
	assert (linkedlistOfGLibObject.size == 1);

}

void test_linkedlist_clear () {
	var linkedlistOfString = new LinkedList<string> (str_equal);
	assert (linkedlistOfString.size == 0);

	// Check clear on empty list
	linkedlistOfString.clear ();
	assert (linkedlistOfString.size == 0);

	// Check clear one item
	linkedlistOfString.add ("1");
	assert (linkedlistOfString.size == 1);
	linkedlistOfString.clear ();
	assert (linkedlistOfString.size == 0);

	// Check clear multiple items
	linkedlistOfString.add ("1");
	linkedlistOfString.add ("2");
	linkedlistOfString.add ("3");
	assert (linkedlistOfString.size == 3);
	linkedlistOfString.clear ();
	assert (linkedlistOfString.size == 0);
}

void test_linkedlist_contains () {
	var linkedlistOfString = new LinkedList<string> (str_equal);

	// Check on empty list
	assert (!linkedlistOfString.contains ("1"));

	// Check items
	linkedlistOfString.add ("10");
	assert (linkedlistOfString.contains ("10"));
	assert (!linkedlistOfString.contains ("20"));
	assert (!linkedlistOfString.contains ("30"));

	linkedlistOfString.add ("20");
	assert (linkedlistOfString.contains ("10"));
	assert (linkedlistOfString.contains ("20"));
	assert (!linkedlistOfString.contains ("30"));

	linkedlistOfString.add ("30");
	assert (linkedlistOfString.contains ("10"));
	assert (linkedlistOfString.contains ("20"));
	assert (linkedlistOfString.contains ("30"));

	// Clear and recheck
	linkedlistOfString.clear ();
	assert (!linkedlistOfString.contains ("10"));
	assert (!linkedlistOfString.contains ("20"));
	assert (!linkedlistOfString.contains ("30"));

	var linkedlistOfInt = new LinkedList<int> ();

	// Check items
	linkedlistOfInt.add (10);
	assert (linkedlistOfInt.contains (10));
	assert (!linkedlistOfInt.contains (20));
	assert (!linkedlistOfInt.contains (30));

	linkedlistOfInt.add (20);
	assert (linkedlistOfInt.contains (10));
	assert (linkedlistOfInt.contains (20));
	assert (!linkedlistOfInt.contains (30));

	linkedlistOfInt.add (30);
	assert (linkedlistOfInt.contains (10));
	assert (linkedlistOfInt.contains (20));
	assert (linkedlistOfInt.contains (30));

	// Clear and recheck
	linkedlistOfInt.clear ();
	assert (!linkedlistOfInt.contains (10));
	assert (!linkedlistOfInt.contains (20));
	assert (!linkedlistOfInt.contains (30));
}

void test_linkedlist_remove () {
	var linkedlistOfString = new LinkedList<string> (str_equal);

	// Check remove if list is empty
	linkedlistOfString.remove ("42");

	// Add 5 same elements
	linkedlistOfString.add ("42");
	linkedlistOfString.add ("42");
	linkedlistOfString.add ("42");
	linkedlistOfString.add ("42");
	linkedlistOfString.add ("42");

	// Check remove one element
	linkedlistOfString.remove ("42");
	assert (linkedlistOfString.size == 4);
	assert (linkedlistOfString.contains ("42"));

	// Check remove another one element
	linkedlistOfString.remove ("42");
	assert (linkedlistOfString.size == 3);
	assert (linkedlistOfString.contains ("42"));

	// Clear the list to start from scratch
	linkedlistOfString.clear ();

	// Add 5 different elements
	linkedlistOfString.add ("42");
	linkedlistOfString.add ("43");
	linkedlistOfString.add ("44");
	linkedlistOfString.add ("45");
	linkedlistOfString.add ("46");
	assert (linkedlistOfString.size == 5);

	// Check remove first
	linkedlistOfString.remove ("42");
	assert (linkedlistOfString.size == 4);
	assert (linkedlistOfString.get (0) == "43");
	assert (linkedlistOfString.get (1) == "44");
	assert (linkedlistOfString.get (2) == "45");
	assert (linkedlistOfString.get (3) == "46");

	// Check remove last
	linkedlistOfString.remove ("46");
	assert (linkedlistOfString.size == 3);
	assert (linkedlistOfString.get (0) == "43");
	assert (linkedlistOfString.get (1) == "44");
	assert (linkedlistOfString.get (2) == "45");

	// Check remove in between
	linkedlistOfString.remove ("44");
	assert (linkedlistOfString.size == 2);
	assert (linkedlistOfString.get (0) == "43");
	assert (linkedlistOfString.get (1) == "45");

	// Check removing of int element
	var linkedlistOfInt = new LinkedList<int> ();

	// Add 5 different elements
	linkedlistOfInt.add (42);
	linkedlistOfInt.add (43);
	linkedlistOfInt.add (44);
	linkedlistOfInt.add (45);
	linkedlistOfInt.add (46);
	assert (linkedlistOfInt.size == 5);

	// Remove first
	linkedlistOfInt.remove (42);
	assert (linkedlistOfInt.size == 4);
	assert (linkedlistOfInt.get (0) == 43);
	assert (linkedlistOfInt.get (1) == 44);
	assert (linkedlistOfInt.get (2) == 45);
	assert (linkedlistOfInt.get (3) == 46);

	// Remove last
	linkedlistOfInt.remove (46);
	assert (linkedlistOfInt.size == 3);
	assert (linkedlistOfInt.get (0) == 43);
	assert (linkedlistOfInt.get (1) == 44);
	assert (linkedlistOfInt.get (2) == 45);

	// Remove in between
	linkedlistOfInt.remove (44);
	assert (linkedlistOfInt.size == 2);
	assert (linkedlistOfInt.get (0) == 43);
	assert (linkedlistOfInt.get (1) == 45);
}

void test_linkedlist_size () {
	var linkedlist = new LinkedList<string> (str_equal);

	// Check empty list
	assert (linkedlist.size == 0);

	// Check when one item
	linkedlist.add ("1");
	assert (linkedlist.size == 1);

	// Check when more items
	linkedlist.add ("2");
	assert (linkedlist.size == 2);

	// Check when items cleared
	linkedlist.clear ();
	assert (linkedlist.size == 0);
}

void test_linkedlist_iterator () {
	var linkedlistOfString = new LinkedList<string> (str_equal);

	// Check iterate empty list
	var iterator = linkedlistOfString.iterator ();
	assert (!iterator.next ());

	// Check iterate list
	linkedlistOfString.add ("42");
	linkedlistOfString.add ("43");
	linkedlistOfString.add ("44");

	iterator = linkedlistOfString.iterator ();
	assert (iterator.next ());
	assert (iterator.get () == "42");
	assert (iterator.next ());
	assert (iterator.get () == "43");
	assert (iterator.next ());
	assert (iterator.get () == "44");
	assert (!iterator.next ());
}

void main (string[] args) {
	Test.init (ref args);

	// Methods of List interface
	Test.add_func ("/LinkedList/List/get", test_linkedlist_get);
	Test.add_func ("/LinkedList/List/set", test_linkedlist_set);
	Test.add_func ("/LinkedList/List/insert", test_linkedlist_insert);
	Test.add_func ("/LinkedList/List/remove_at", test_linkedlist_remove_at);
	Test.add_func ("/LinkedList/List/index_of", test_linkedlist_index_of);
	Test.add_func ("/LinkedList/List/slice", test_linkedlist_slice);

	// Methods of Collection interface
	Test.add_func ("/LinkedList/Collection/add", test_linkedlist_add);
	Test.add_func ("/LinkedList/Collection/clear", test_linkedlist_clear);
	Test.add_func ("/LinkedList/Collection/contains", test_linkedlist_contains);
	Test.add_func ("/LinkedList/Collection/remove", test_linkedlist_remove);
	Test.add_func ("/LinkedList/Collection/size", test_linkedlist_size);

	// Methods of Iterable interface
	Test.add_func ("/LinkedList/Iterable/iterator", test_linkedlist_iterator);

	Test.run ();
}

