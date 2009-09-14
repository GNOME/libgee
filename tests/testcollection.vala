/* testcollection.vala
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

using Gee;

public abstract class CollectionTests : Gee.TestCase {

	public CollectionTests (string name) {
		base(name);
		add_test ("[Collection] type correctness", test_type_correctness);
		add_test ("[Collection] iterator returns all elements once",
		          test_iterator_returns_all_elements_once);
		add_test ("[Collection] contains, size and is_empty",
		          test_contains_size_and_is_empty);
		add_test ("[Collection] add_all", test_add_all);
		add_test ("[Collection] contains_all", test_contains_all);
		add_test ("[Collection] remove_all", test_remove_all);
		add_test ("[Collection] retain_all", test_retain_all);
		add_test ("[Collection] to_array", test_to_array);
		add_test ("[Collection] GObject properties", test_gobject_properties);
	}

	protected Collection<string> test_collection;

	public void test_type_correctness () {
		// Check the collection exists
		assert (test_collection != null);

		// Check the advertised element type
		assert (test_collection.element_type == typeof (string));
	}

	public void test_iterator_returns_all_elements_once () {
		// Check the collection exists
		assert (test_collection != null);
		bool has_next;

		// Check with an empty collection
		Iterator<string> iterator = test_collection.iterator ();
		assert (! iterator.has_next ());
		assert (! iterator.next ());
		assert (! iterator.first ());

		// Check for some elements in the collection
		assert (test_collection.add ("one"));
		assert (test_collection.add ("two"));
		assert (test_collection.add ("three"));

		bool one_found = false;
		bool two_found = false;
		bool three_found = false;
		bool one_found_once = true;
		bool two_found_once = true;
		bool three_found_once = true;
		iterator = test_collection.iterator ();
		while (true) {
			has_next = iterator.has_next ();
			assert (has_next == iterator.next ());
			if (! has_next) {
				break;
			}

			string element = iterator.get ();
			if (element == "one") {
				if (one_found) {
					one_found_once = false;
				}
				one_found = true;
			} else if (element == "two") {
				if (two_found) {
					two_found_once = false;
				}
				two_found = true;
			} else if (element == "three") {
				if (three_found) {
					three_found_once = false;
				}
				three_found = true;
			}
		}
		has_next = iterator.has_next ();
		assert (! has_next);
		assert (has_next == iterator.next ());
		assert (one_found);
		assert (one_found_once);
		assert (two_found);
		assert (two_found_once);
		assert (three_found);
		assert (three_found_once);

		// Do it twice to check first ()
		assert (iterator.first ());

		one_found = false;
		two_found = false;
		three_found = false;
		one_found_once = true;
		two_found_once = true;
		three_found_once = true;
		while (true) {
			string element = iterator.get ();
			if (element == "one") {
				if (one_found) {
					one_found_once = false;
				}
				one_found = true;
			} else if (element == "two") {
				if (two_found) {
					two_found_once = false;
				}
				two_found = true;
			} else if (element == "three") {
				if (three_found) {
					three_found_once = false;
				}
				three_found = true;
			}

			has_next = iterator.has_next ();
			assert (has_next == iterator.next ());
			if (! has_next) {
				break;
			}
		}
		has_next = iterator.has_next ();
		assert (! has_next);
		assert (has_next == iterator.next ());
		assert (one_found);
		assert (one_found_once);
		assert (two_found);
		assert (two_found_once);
		assert (three_found);
		assert (three_found_once);
	}

	public void test_contains_size_and_is_empty () {
		// Check the collection exists
		assert (test_collection != null);

		// Check the collection is initially empty
		assert (! test_collection.contains("one"));
		assert (! test_collection.contains("two"));
		assert (! test_collection.contains("three"));
		assert (test_collection.size == 0);
		assert (test_collection.is_empty);

		// Add an element
		assert (test_collection.add ("one"));
		assert (test_collection.contains("one"));
		assert (! test_collection.contains("two"));
		assert (! test_collection.contains("three"));
		assert (test_collection.size == 1);
		assert (! test_collection.is_empty);

		// Remove the added element
		assert (test_collection.remove ("one"));
		assert (! test_collection.contains("one"));
		assert (! test_collection.contains("two"));
		assert (! test_collection.contains("three"));
		assert (test_collection.size == 0);
		assert (test_collection.is_empty);

		// Add more elements
		assert (test_collection.add ("one"));
		assert (test_collection.contains("one"));
		assert (! test_collection.contains("two"));
		assert (! test_collection.contains("three"));
		assert (test_collection.size == 1);
		assert (! test_collection.is_empty);

		assert (test_collection.add ("two"));
		assert (test_collection.contains("one"));
		assert (test_collection.contains("two"));
		assert (! test_collection.contains("three"));
		assert (test_collection.size == 2);
		assert (! test_collection.is_empty);

		assert (test_collection.add ("three"));
		assert (test_collection.contains("one"));
		assert (test_collection.contains("two"));
		assert (test_collection.contains("three"));
		assert (test_collection.size == 3);
		assert (! test_collection.is_empty);

		// Remove one element
		assert (test_collection.remove ("two"));
		assert (test_collection.contains("one"));
		assert (! test_collection.contains("two"));
		assert (test_collection.contains("three"));
		assert (test_collection.size == 2);
		assert (! test_collection.is_empty);

		// Remove the same element again
		assert (! test_collection.remove ("two"));
		assert (test_collection.contains("one"));
		assert (! test_collection.contains("two"));
		assert (test_collection.contains("three"));
		assert (test_collection.size == 2);
		assert (! test_collection.is_empty);

		// Remove all elements
		test_collection.clear ();
		assert (! test_collection.contains("one"));
		assert (! test_collection.contains("two"));
		assert (! test_collection.contains("three"));
		assert (test_collection.size == 0);
		assert (test_collection.is_empty);
	}

	public void test_add_all () {
		// Check the collection exists
		assert (test_collection != null);

		// Creating a dummy collection
		var dummy = new ArrayList<string> ();

		// Check when the test collection is initially empty and
		// dummy collection is empty
		assert (! test_collection.add_all (dummy));

		assert (test_collection.is_empty);
		assert (dummy.is_empty);

		// Check when test collection is not empty but dummy is
		assert (test_collection.add ("hello"));
		assert (! test_collection.add_all (dummy));

		assert (test_collection.size == 1);
		assert (test_collection.contains ("hello"));

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection is initially empty and
		// dummy collection is not empty
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));

		assert (test_collection.add_all (dummy));

		assert (test_collection.size == 3);
		assert (test_collection.contains ("hello1"));
		assert (test_collection.contains ("hello2"));
		assert (test_collection.contains ("hello3"));
		assert (dummy.size == 3);
		assert (dummy.contains ("hello1"));
		assert (dummy.contains ("hello2"));
		assert (dummy.contains ("hello3"));

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection is not empty and both
		// collections does not intersect
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));

		assert (test_collection.add ("hello"));

		assert (test_collection.add_all (dummy));

		assert (test_collection.size == 4);
		assert (test_collection.contains ("hello"));
		assert (test_collection.contains ("hello1"));
		assert (test_collection.contains ("hello2"));
		assert (test_collection.contains ("hello3"));
		assert (dummy.size == 3);
		assert (dummy.contains ("hello1"));
		assert (dummy.contains ("hello2"));
		assert (dummy.contains ("hello3"));

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection is not empty and both
		// collection intersect
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));

		assert (test_collection.add ("hello1"));

		assert (test_collection.add_all (dummy));

		assert (test_collection.size == 4);
		assert (test_collection.contains ("hello1"));
		assert (test_collection.contains ("hello2"));
		assert (test_collection.contains ("hello3"));
		assert (dummy.size == 3);
		assert (dummy.contains ("hello1"));
		assert (dummy.contains ("hello2"));
		assert (dummy.contains ("hello3"));
	}

	public void test_contains_all () {
		// Check the collection exists
		assert (test_collection != null);

		// Creating a dummy collection
		var dummy = new ArrayList<string> ();
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));

		// Check when the test collection is initially empty
		assert (test_collection.is_empty);
		assert (! test_collection.contains_all (dummy));

		// Check when the test collection is not empty and both
		// collections does not intersect
		assert (test_collection.add ("hello4"));
		assert (test_collection.add ("hello5"));
		assert (! test_collection.contains_all (dummy));

		// Check when the test collection is not empty and both
		// collections intersect but are not equal
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello2"));
		assert (! test_collection.contains_all (dummy));

		// Check when the test collection is not empty and the
		// dummy collection is contained in the test one
		assert (test_collection.add ("hello3"));
		assert (test_collection.contains_all (dummy));
		assert (! dummy.contains_all (test_collection));
	}

	public void test_remove_all () {
		// Check the collection exists
		assert (test_collection != null);

		// Creating a dummy collection
		var dummy = new ArrayList<string> ();

		// Check when both collection are intially empty
		assert (! test_collection.remove_all (dummy));

		assert (test_collection.is_empty);
		assert (dummy.is_empty);

		// Check when the test collection is initially empty and
		// dummy collection is not empty
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));

		assert (! test_collection.remove_all (dummy));

		assert (test_collection.is_empty);

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection is not empty and both
		// collections does not intersect
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));
		assert (test_collection.add ("hello4"));
		assert (test_collection.add ("hello5"));

		assert (! test_collection.remove_all (dummy));

		assert (test_collection.size == 2);
		assert (dummy.size == 3);

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection is not empty and both
		// collections intersect
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello2"));
		assert (test_collection.add ("hello3"));

		assert (test_collection.remove_all (dummy));

		assert (test_collection.is_empty);
		assert (dummy.size == 3);

		test_collection.clear ();
		dummy.clear ();

		// Check removing the same element
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello1"));

		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello1"));

		assert (test_collection.remove_all (dummy));

		assert (test_collection.size == 2);
		assert (dummy.size == 2);
	}

	public void test_retain_all () {
		// Check the collection exists
		assert (test_collection != null);

		// Creating a dummy collection
		var dummy = new ArrayList<string> ();

		// Check when the test collection is initially empty and
		// dummy collection is empty
		assert (! test_collection.retain_all (dummy));

		assert (test_collection.is_empty);
		assert (dummy.is_empty);

		// Check when the test collection is not empty and
		// the dummy one is
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello2"));

		assert (test_collection.retain_all (dummy));

		assert (test_collection.is_empty);
		assert (dummy.is_empty);

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection is initially empty and
		// dummy collection is not empty
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));

		assert (! test_collection.retain_all (dummy));

		assert (test_collection.is_empty);
		assert (dummy.size == 3);
		assert (dummy.contains ("hello1"));
		assert (dummy.contains ("hello2"));
		assert (dummy.contains ("hello3"));

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection is not empty and both
		// collection does not intersect
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));
		assert (test_collection.add ("hello4"));
		assert (test_collection.add ("hello5"));

		assert (test_collection.retain_all (dummy));

		assert (test_collection.is_empty);
		assert (dummy.size == 3);
		assert (dummy.contains ("hello1"));
		assert (dummy.contains ("hello2"));
		assert (dummy.contains ("hello3"));

		test_collection.clear ();
		dummy.clear ();

		// Check when both collections have the same elements
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello2"));
		assert (test_collection.add ("hello3"));

		assert (! test_collection.retain_all (dummy));

		assert (test_collection.size == 3);
		assert (test_collection.contains ("hello1"));
		assert (test_collection.contains ("hello2"));
		assert (test_collection.contains ("hello3"));
		assert (dummy.size == 3);
		assert (dummy.contains ("hello1"));
		assert (dummy.contains ("hello2"));
		assert (dummy.contains ("hello3"));

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection is not empty and both
		// collections intersect but are not equal
		assert (dummy.add ("hello1"));
		assert (dummy.add ("hello2"));
		assert (dummy.add ("hello3"));
		assert (test_collection.add ("hello2"));
		assert (test_collection.add ("hello3"));
		assert (test_collection.add ("hello4"));

		assert (test_collection.retain_all (dummy));

		assert (test_collection.size == 2);
		assert (test_collection.contains ("hello2"));
		assert (test_collection.contains ("hello3"));
		assert (dummy.size == 3);
		assert (dummy.contains ("hello1"));
		assert (dummy.contains ("hello2"));
		assert (dummy.contains ("hello3"));

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection contains the same elements several
		// times and the dummy collection contains the element too
		assert (dummy.add ("hello1"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello1"));

		assert (! test_collection.retain_all (dummy));

		assert (test_collection.size == 4);
		assert (dummy.size == 1);

		test_collection.clear ();
		dummy.clear ();

		// Check when the test collection contains the same elements several
		// times and the dummy collection contains the element too
		assert (dummy.add ("hello2"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello1"));

		assert (test_collection.retain_all (dummy));

		assert (test_collection.is_empty);
		assert (dummy.size == 1);
	}

	public void test_to_array() {
		// Check the collection exists
		assert (test_collection != null);

		// Check the collection is empty
		assert (test_collection.is_empty);

		// Add some elements
		assert (test_collection.add ("hello1"));
		assert (test_collection.add ("hello2"));
		assert (test_collection.add ("hello3"));

		// Check the conversion to array
		string[] array = (string[]) test_collection.to_array ();
		int index = 0;
		foreach (string element in test_collection) {
			assert (element == array[index++]);
		}
	}

	public void test_gobject_properties() {
		// Check the collection exists
		assert (test_collection != null);
		Value value;

		value = Value (typeof (Type));
		test_collection.get_property ("element-type", ref value);
		assert (value.get_gtype () == test_collection.element_type);
		value.unset ();

		value = Value (typeof (bool));
		test_collection.get_property ("is-empty", ref value);
		assert (value.get_boolean () == test_collection.is_empty);
		value.unset ();

		value = Value (typeof (int));
		test_collection.get_property ("size", ref value);
		assert (value.get_int () == test_collection.size);
		value.unset ();
	}
}
