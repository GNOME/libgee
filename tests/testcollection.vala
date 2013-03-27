/* testcollection.vala
 *
 * Copyright (C) 2008  Jürg Billeter
 * Copyright (C) 2009  Didier Villevalois, Julien Peeters
 * Copyright (C) 2011-2012  Maciej Piechotka
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
 *      Maciej Piechotka <uzytkownik2@gmail.com>
 */

using Gee;

public abstract class CollectionTests : Gee.TestCase {

	public CollectionTests (string name) {
		base (name);
		add_test ("[Collection] type correctness", test_type_correctness);
		add_test ("[Collection] iterator returns all elements once",
		          test_iterator_returns_all_elements_once);
		add_test ("[Collection] mutable iterator", test_mutable_iterator);
		add_test ("[Collection] contains, size and is_empty",
		          test_contains_size_and_is_empty);
		add_test ("[Collection] add and remove", test_add_remove);
		add_test ("[Collection] clear", test_clear);
		add_test ("[Collection] add_all", test_add_all);
		add_test ("[Collection] contains_all", test_contains_all);
		add_test ("[Collection] remove_all", test_remove_all);
		add_test ("[Collection] retain_all", test_retain_all);
		add_test ("[Collection] to_array", test_to_array);
		add_test ("[Collection] GObject properties", test_gobject_properties);
		add_test ("[Collection] fold", test_fold);
		add_test ("[Collection] foreach", test_foreach);
		add_test ("[Collection] map", test_map);
		add_test ("[Collection] scan", test_scan);
		add_test ("[Collection] filter", test_filter);
		add_test ("[Collection] chop", test_chop);
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

		unowned string[] data = TestData.get_data ();

		// Check for some elements in the collection
		foreach (unowned string el in data) {
			assert (test_collection.add (el));
		}

		uint[] found_times = new uint[data.length];
		for (uint i = 0; i < 2; i++) {
			for (uint j = 0; j < found_times.length; j++) {
				found_times[j] = 0;
			}
			iterator = test_collection.iterator ();
			bool valid = iterator.valid;
			assert (! valid);
			while (true) {
				has_next = iterator.has_next ();
				assert (valid == iterator.valid);
				assert (has_next == iterator.next ());
				assert (valid = iterator.valid);
				if (! has_next) {
					break;
				}

				string element = iterator.get ();
				assert (iterator.valid);
				for (uint element_idx = 0;; element_idx++) {
					assert (element_idx < data.length);
					if (data[element_idx] == element) {
						found_times[element_idx]++;
						break;
					}
				}
			}
			has_next = iterator.has_next ();
			assert (! has_next);
			assert (iterator.valid);
			assert (has_next == iterator.next ());
			assert (iterator.valid);
			foreach (var ft in found_times) {
				assert (ft == 1);
			}
		}
	}

	public void test_mutable_iterator () {
		// Check the collection exists
		assert (test_collection != null);
		bool has_next;

		// Check with an empty collection
		Iterator<string> iterator = test_collection.iterator ();
		// ...

		unowned string[] data = TestData.get_data ();
		unowned uint[] idx = TestData.get_drawn_numbers ();

		// Check for some elements in the collection and remove few
		foreach (unowned string el in data) {
			assert (test_collection.add (el));
		}

		iterator = test_collection.iterator ();
		uint[] found_times = new uint[data.length];
		for (uint i = 0; i <= idx.length; i++) {
			for (uint j = 0; j < found_times.length; j++) {
				found_times[j] = 0;
			}
			iterator = test_collection.iterator ();
			assert (! iterator.valid);
			bool last_removed = false;
			while (true) {
				has_next = iterator.has_next ();
				assert (has_next == iterator.next ());
				if (! has_next) {
					break;
				}

				string element = iterator.get ();
				assert (iterator.valid);
				for (uint element_idx = 0;; element_idx++) {
					assert (element_idx < data.length);
					if (data[element_idx] == element) {
						if (i != idx.length && data[element_idx] == data[idx[i]]) {
							iterator.remove ();
							assert (! iterator.valid);
							last_removed = true;
						} else {
							last_removed = false;
						}
						found_times[element_idx]++;
						break;
					}
				}
			}
			has_next = iterator.has_next ();
			assert (! has_next);
			assert (iterator.valid == !last_removed);
			assert (has_next == iterator.next ());
			assert (iterator.valid == !last_removed);
			for (uint j = 0; j < found_times.length; j++) {
				bool removed = false;
				for (int k = 0; k < i; k++) {
					if (idx[k] == j) {
						removed = true;
						break;
					}
				}
				assert (found_times[j] == (removed ? 0 : 1));
			}
		}
	}

	public void test_contains_size_and_is_empty () {
		// Check the collection exists
		assert (test_collection != null);

		unowned string[] data = TestData.get_data ();
		unowned uint[] idx = TestData.get_drawn_numbers ();

		// Check the collection is initially empty
		foreach (unowned string s in data) {
			assert (! test_collection.contains (s));
		}
		assert (test_collection.size == 0);
		assert (test_collection.is_empty);

		// Add an element
		assert (test_collection.add (data[0]));
		assert (test_collection.contains (data[0]));
		for (uint i = 1; i < data.length; i++) {
			assert (! test_collection.contains (data[i]));
		}
		assert (test_collection.size == 1);
		assert (! test_collection.is_empty);

		// Remove the added element
		assert (test_collection.remove ("one"));
		foreach (unowned string s in data) {
			assert (! test_collection.contains (s));
		}
		assert (test_collection.size == 0);
		assert (test_collection.is_empty);

		// Add more elements
		for (uint i = 0; i < data.length; i++) {
			assert (test_collection.add (data[i]));
			for (uint j = 0; j <= i; j++) {
				assert (test_collection.contains (data[j]));
			}
			for (uint j = i + 1; j < data.length; j++) {
				assert (! test_collection.contains (data[j]));
			}
			assert (test_collection.size == i + 1);
			assert (! test_collection.is_empty);
		}
		for (uint i = 0; i < idx.length; i++) {
			// Remove one element
			assert (test_collection.remove (data[idx[i]]));
			for (uint j = 0; j < data.length; j++) {
				bool removed = false;
				for (uint k = 0; k <= i; k++) {
					if (idx[k] == j) {
						removed = true;
						break;
					}
				}
				assert (test_collection.contains (data[j]) == !removed);
			}
			assert (test_collection.size == data.length - (i + 1));

			// Remove the same element again
			assert (! test_collection.remove (data[idx[i]]));
			for (uint j = 0; j < data.length; j++) {
				bool removed = false;
				for (uint k = 0; k <= i; k++) {
					if (idx[k] == j) {
						removed = true;
						break;
					}
				}
				assert (test_collection.contains (data[j]) == !removed);
			}
			assert (test_collection.size == data.length - (i + 1));
		}

		// Remove all elements
		test_collection.clear ();
		foreach (unowned string el in data) {
			assert (! test_collection.contains (el));
		}
		assert (test_collection.size == 0);
		assert (test_collection.is_empty);
	}

	public void test_add_remove () {
		// Check the collection exists
		assert (test_collection != null);

		unowned string[] to_add = TestData.get_data ();
		var expected_size = 0;

		foreach (var a in to_add) {
			assert (!test_collection.contains (a));
			assert (test_collection.size == expected_size++);
			assert (test_collection.add (a));
			assert (test_collection.contains (a));
		}
		assert (test_collection.size == to_add.length);

		foreach (var a in to_add) {
			assert (test_collection.contains (a));
		}

		foreach (var a in to_add) {
			assert (test_collection.contains (a));
			assert (test_collection.size == expected_size--);
			assert (test_collection.remove (a));
			assert (!test_collection.contains (a));
		}
		assert (test_collection.size == 0);
	}

	public void test_clear () {
		// Check the collection exists
		assert (test_collection != null);

		unowned string[] to_add = TestData.get_data ();
		var expected_size = 0;

		foreach (var a in to_add) {
			assert (!test_collection.contains (a));
			assert (test_collection.size == expected_size++);
			assert (test_collection.add (a));
			assert (test_collection.contains (a));
		}
		assert (test_collection.size == to_add.length);
		
		test_collection.clear ();
		
		assert (test_collection.size == 0);
		
		Iterator<string> iter = test_collection.iterator ();
		assert (iter != null);
		assert (!iter.has_next ());		
		
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

		// We can only assert the result is greater or equal than 3
		// as we do not assume duplicates
		assert (test_collection.size >= 3);
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
	}

	public void test_to_array () {
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

	public void test_gobject_properties () {
		// Check the collection exists
		assert (test_collection != null);
		Value value;

		value = Value (typeof (int));
		test_collection.get_property ("size", ref value);
		assert (value.get_int () == test_collection.size);
		value.unset ();
	}
	
	public void test_fold () {
		assert (test_collection.add ("one"));
		assert (test_collection.add ("two"));
		assert (test_collection.add ("three"));
		
		int count;
		
		count = test_collection.fold<int> ((x, y) => {return y + 1;}, 0);
		assert (count == 3);
		
		count = test_collection.iterator ().fold<int> ((x, y) => {return y + 1;}, 0);
		assert (count == 3);
		
		Iterator<string> iter = test_collection.iterator ();
		assert (iter.next ());
		count = iter.fold<int> ((x, y) => {return y + 1;}, 0);
		assert (count == 3);
	}
	
	public void test_foreach () {
		assert (test_collection.add ("one"));
		assert (test_collection.add ("two"));
		assert (test_collection.add ("three"));
		
		int count = 0;
		bool res;
		
		res = test_collection.foreach ((x) => {count++; return true;});
		assert (count == 3);
		assert (res == true);
		
		res = test_collection.iterator ().foreach ((x) => {count++; return true;});
		assert (count == 6);
		assert (res == true);
		
		Iterator<string> iter = test_collection.iterator ();
		assert (iter.next ());
		res = iter.foreach ((x) => {count++; return true;});
		assert (count == 9);
		assert (res == true);

		res = test_collection.foreach ((x) => {count++; return false;});
		assert (count == 10);
		assert (res == false);
	}

	public void test_map () {
		assert (test_collection.add ("one"));
		assert (test_collection.add ("two"));
		assert (test_collection.add ("three"));

		bool one = false;
		bool two = false;
		bool three = false;

		int i = 0;
		var iter = test_collection.iterator().map<int> ((str) => {
			if (str == "one") {
				assert (!one);
				one = true;
			} else if (str == "two") {
				assert (!two);
				two = true;
			} else if (str == "three") {
				assert (!three);
				three = true;
			} else {
				assert_not_reached ();
			}
			return i++;
		});
		int j = 0;
		while (iter.next ()) {
			assert (i == j);
			assert (j == iter.get ());
			assert (j == iter.get ());
			j++;
			assert (i == j);
		}

		assert (i == j);
		assert (i == test_collection.size);
		assert (one);
		assert (two);
		assert (three);
		
		one = two = three = false;
		i = j = 0;

		iter = test_collection.map<int> ((str) => {
			if (str == "one") {
				assert (!one);
				one = true;
			} else if (str == "two") {
				assert (!two);
				two = true;
			} else if (str == "three") {
				assert (!three);
				three = true;
			} else {
				assert_not_reached ();
			}
			return i++;
		});
		while (iter.next ()) {
			assert (i == j);
			assert (j == iter.get ());
			assert (j == iter.get ());
			j++;
			assert (i == j);
		}

		assert (i == j);
		assert (i == test_collection.size);
		assert (one);
		assert (two);
		assert (three);
	}

	public void test_scan () {
		assert (test_collection.add ("one"));
		assert (test_collection.add ("two"));
		assert (test_collection.add ("three"));

		bool one = false;
		bool two = false;
		bool three = false;

		var iter = test_collection.iterator().scan<int> ((str, cur) => {
			if (str == "one") {
				assert (!one);
				one = true;
			} else if (str == "two") {
				assert (!two);
				two = true;
			} else if (str == "three") {
				assert (!three);
				three = true;
			} else {
				assert_not_reached ();
			}
			return cur + 1;
		}, 0);

		int j = 0;
		do {
			assert (j == iter.get ());
			assert (j == iter.get ());
			j++;
		} while (iter.next ());

		assert (j == test_collection.size + 1);
		assert (one);
		assert (two);
		assert (three);
		
		one = two = three = false;
		j = 0;
		
		iter = test_collection.scan<int> ((str, cur) => {
			if (str == "one") {
				assert (!one);
				one = true;
			} else if (str == "two") {
				assert (!two);
				two = true;
			} else if (str == "three") {
				assert (!three);
				three = true;
			} else {
				assert_not_reached ();
			}
			return cur + 1;
		}, 0);
		
		do {
			assert (j == iter.get ());
			assert (j == iter.get ());
			j++;
		} while (iter.next ());

		assert (j == test_collection.size + 1);
		assert (one);
		assert (two);
		assert (three);
	}

	public void test_filter () {
		assert (test_collection.add ("one"));
		assert (test_collection.add ("two"));
		assert (test_collection.add ("three"));

		bool one = false;
		bool two = false;
		bool three = false;

		var iter = test_collection.iterator().filter ((str) => {
			if (str == "one") {
				assert (!one);
				one = true;
			} else if (str == "two") {
				assert (!two);
				two = true;
			} else if (str == "three") {
				assert (!three);
				three = true;
			} else {
				assert_not_reached ();
			}
			return str != "two";
		});

		assert (!iter.valid);

		int j = 0;
		while (iter.next ()) {
			assert(iter.get () != "two");
			j++;
		}
		assert (j == 2);
		assert (one);
		assert (two);
		assert (three);
		
		one = two = three = false;
		j = 0;
		
		iter = test_collection.filter ((str) => {
			if (str == "one") {
				assert (!one);
				one = true;
			} else if (str == "two") {
				assert (!two);
				two = true;
			} else if (str == "three") {
				assert (!three);
				three = true;
			} else {
				assert_not_reached ();
			}
			return str != "two";
		});

		assert (!iter.valid);
		
		while (iter.next ()) {
			assert(iter.get () != "two");
			j++;
		}
		assert (j == 2);
		assert (one);
		assert (two);
		assert (three);
	}

	public void test_chop () {
		assert (test_collection.add ("one"));
		assert (test_collection.add ("two"));
		assert (test_collection.add ("three"));

		var iter = test_collection.iterator().chop (1, 1);
		assert (!iter.valid);
		var iter2 = test_collection.iterator();

		assert (iter2.next ());
		assert (iter2.next ());
		assert (iter.next ());
		assert (iter2.get () == iter.get ());
		assert (!iter.next ());
		assert (iter2.next ());

		iter = test_collection.chop (1, 1);
		assert (!iter.valid);
		iter2 = test_collection.iterator();

		assert (iter2.next ());
		assert (iter2.next ());
		assert (iter.next ());
		assert (iter2.get () == iter.get ());
		assert (!iter.next ());
		assert (iter2.next ());
	}
}

