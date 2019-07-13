/* testmap.vala
 *
 * Copyright (C) 2008  Jürg Billeter
 * Copyright (C) 2009  Didier Villevalois, Julien Peeters, Maciej Piechotka
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
 * 	Maciej Piechotka <uzytkownik2@gmail.com>
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using Gee;

public abstract class MapTests : Gee.TestCase {

	protected MapTests (string name) {
		base (name);
		add_test ("[Map] type correctness", test_type_correctness);
		add_test ("[Map] has_key, size and is_empty",
		          test_has_key_size_is_empty);
		add_test ("[Map] keys", test_keys);
		add_test ("[Map] values", test_values);
		add_test ("[Map] entries", test_entries);
		add_test ("[Map] entry weak pointer lifetime", test_entry_weak_pointer_lifetime);
		add_test ("[Map] set all", test_set_all);
		add_test ("[Map] unset all", test_unset_all);
		add_test ("[Map] has all", test_has_all);
		add_test ("[Map] GObject properties", test_gobject_properties);
		add_test ("[Map] fold", test_fold);
		add_test ("[Map] foreach", test_foreach);
	}

	protected Map<string, string> test_map;

	public void test_type_correctness () {
		// Check the map exists
		assert (test_map != null);

		// Check the advertised key and value types
		assert (test_map.key_type == typeof (string));
		assert (test_map.value_type == typeof (string));
	}

	public void test_has_key_size_is_empty () {
		// Check the collection exists
		assert (test_map != null);
		string value;

		// Check the collection is initially empty
		assert (! test_map.has_key ("one"));
		assert (! test_map.has_key ("two"));
		assert (! test_map.has_key ("three"));
		assert (test_map.size == 0);
		assert (test_map.is_empty);

		// Add a binding
		test_map.set ("one", "value_of_one");
		assert (test_map.has_key ("one"));
		assert (test_map.has ("one", "value_of_one"));
		assert (! test_map.has ("one", "another_value_for_one"));
		assert (test_map.get ("one") == "value_of_one");
		assert (! test_map.has_key ("two"));
		assert (test_map.get ("two") == null);
		assert (! test_map.has_key ("three"));
		assert (test_map.get ("three") == null);
		assert (test_map.size == 1);
		assert (! test_map.is_empty);

		// Remove the last added binding
		assert (test_map.unset ("one"));
		assert (! test_map.has_key ("one"));
		assert (! test_map.has ("one", "value_of_one"));
		assert (! test_map.has ("one", "another_value_for_one"));
		assert (test_map.get ("one") == null);
		assert (! test_map.has_key ("two"));
		assert (test_map.get ("two") ==  null);
		assert (! test_map.has_key ("three"));
		assert (test_map.get ("three") == null);
		assert (test_map.size == 0);
		assert (test_map.is_empty);

		// Add more bindings
		test_map.set ("one", "value_of_one");
		assert (test_map.has_key ("one"));
		assert (test_map.get ("one") == "value_of_one");
		assert (! test_map.has_key ("two"));
		assert (test_map.get ("two") == null);
		assert (! test_map.has_key ("three"));
		assert (test_map.get ("three") == null);
		assert (test_map.size == 1);
		assert (! test_map.is_empty);

		test_map.set ("two", "value_of_two");
		assert (test_map.has_key ("one"));
		assert (test_map.get ("one") == "value_of_one");
		assert (test_map.has_key ("two"));
		assert (test_map.get ("two") == "value_of_two");
		assert (! test_map.has_key ("three"));
		assert (test_map.get ("three") == null);
		assert (test_map.size == 2);
		assert (! test_map.is_empty);

		test_map.set ("three", "value_of_three");
		assert (test_map.has_key ("one"));
		assert (test_map.get ("one") == "value_of_one");
		assert (test_map.has_key ("two"));
		assert (test_map.get ("two") == "value_of_two");
		assert (test_map.has_key ("three"));
		assert (test_map.get ("three") == "value_of_three");
		assert (test_map.size == 3);
		assert (! test_map.is_empty);

		// Update an existent binding
		test_map.set ("two", "value_of_two_new");
		assert (test_map.has_key ("one"));
		assert (test_map.get ("one") == "value_of_one");
		assert (test_map.has_key ("two"));
		assert (test_map.get ("two") == "value_of_two_new");
		assert (test_map.has_key ("three"));
		assert (test_map.get ("three") == "value_of_three");
		assert (test_map.size == 3);
		assert (! test_map.is_empty);

		// Remove one element
		assert (test_map.unset ("two", out value));
		assert (value == "value_of_two_new");
		assert (test_map.has_key ("one"));
		assert (test_map.get ("one") == "value_of_one");
		assert (! test_map.has_key ("two"));
		assert (test_map.get ("two") == null);
		assert (test_map.has_key ("three"));
		assert (test_map.get ("three") == "value_of_three");
		assert (test_map.size == 2);
		assert (! test_map.is_empty);

		// Remove the same element again
		assert (! test_map.unset ("two", out value));
		assert (value == null);
		assert (test_map.has_key ("one"));
		assert (! test_map.has_key ("two"));
		assert (test_map.has_key ("three"));
		assert (test_map.size == 2);
		assert (! test_map.is_empty);

		// Remove all elements
		test_map.clear ();
		assert (! test_map.has_key ("one"));
		assert (test_map.get ("one") == null);
		assert (! test_map.has_key ("two"));
		assert (test_map.get ("two") == null);
		assert (! test_map.has_key ("three"));
		assert (test_map.get ("three") == null);
		assert (test_map.size == 0);
		assert (test_map.is_empty);
	}

	public void test_keys () {
		// Check keys on empty map
		var keys = test_map.keys;
		assert (keys.size == 0);

		// Check keys on map with one item
		test_map.set ("one", "value_of_one");
		assert (keys.size == 1);
		assert (keys.contains ("one"));
		keys = test_map.keys;
		assert (keys.size == 1);
		assert (keys.contains ("one"));

		// Check modify key set directly
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (! keys.add ("three"));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		Test.trap_assert_stderr ("*code should not be reached*");

		// Check keys on map with multiple items
		test_map.set ("two", "value_of_two");
		assert (keys.size == 2);
		assert (keys.contains ("one"));
		assert (keys.contains ("two"));
		keys = test_map.keys;
		assert (keys.size == 2);
		assert (keys.contains ("one"));
		assert (keys.contains ("two"));

		// Check keys on map clear
		test_map.clear ();
		assert (keys.size == 0);
		keys = test_map.keys;
		assert (keys.size == 0);
	}

	public void test_values () {
		// Check keys on empty map
		var values = test_map.values;
		assert (values.size == 0);

		// Check keys on map with one item
		test_map.set ("one", "value_of_one");
		assert (values.size == 1);
		assert (values.contains ("value_of_one"));
		values = test_map.values;
		assert (values.size == 1);
		assert (values.contains ("value_of_one"));

		// Check modify key set directly
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (! values.add ("two"));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		Test.trap_assert_stderr ("*code should not be reached*");

		// Check keys on map with multiple items
		test_map.set ("two", "value_of_two");
		assert (values.size == 2);
		assert (values.contains ("value_of_one"));
		assert (values.contains ("value_of_two"));
		values = test_map.values;
		assert (values.size == 2);
		assert (values.contains ("value_of_one"));
		assert (values.contains ("value_of_two"));

		// Check keys on map clear
		test_map.clear ();
		assert (values.size == 0);
		values = test_map.values;
		assert (values.size == 0);
	}

	public void test_entries () {
		// Check entries on empty map
		var entries = test_map.entries;
		assert (entries.size == 0);

		// Check entries on map with one item
		test_map.set ("one", "value_of_one");
		assert (entries.size == 1);
		assert (entries.contains (new TestEntry<string,string> ("one", "value_of_one")));
		entries = test_map.entries;
		assert (entries.size == 1);
		assert (entries.contains (new TestEntry<string,string> ("one", "value_of_one")));

		// Check modify entry set directly
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (! entries.add (new TestEntry<string,string> ("two", "value_of_two")));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		Test.trap_assert_stderr ("*code should not be reached*");

		// Check entries on map with multiple items
		test_map.set ("two", "value_of_two");
		assert (entries.size == 2);
		assert (entries.contains (new TestEntry<string,string> ("one", "value_of_one")));
		assert (entries.contains (new TestEntry<string,string> ("two", "value_of_two")));
		entries = test_map.entries;
		assert (entries.size == 2);
		assert (entries.contains (new TestEntry<string,string> ("one", "value_of_one")));
		assert (entries.contains (new TestEntry<string,string> ("two", "value_of_two")));

		// Check keys on map clear
		test_map.clear ();
		assert (entries.size == 0);
		entries = test_map.entries;
		assert (entries.size == 0);
	}

	private void test_entry_weak_pointer_lifetime () {
		// Issue was reproducible with AddressSanitizer and G_SLICE=always-malloc

		test_map["1337"] = "Badger";

		foreach (var entry in test_map.entries) {
			if (entry.value == "Badger") {
				test_map.unset (entry.key);
				break;
			}
		}
	}

	public void test_clear () {
		test_map.set ("one", "value_of_one");
		test_map.set ("two", "value_of_two");
		test_map.set ("three", "value_of_three");
		
		test_map.clear ();
		assert (test_map.size == 0);
		
		Set<string> keys = test_map.keys;
		assert (keys != null);
		Iterator<string> ikeys = keys.iterator ();
		assert (ikeys != null);
		assert (!ikeys.has_next ());
		
		Collection<string> vals = test_map.values;
		assert (vals != null);
		Iterator<string> ivals = vals.iterator ();
		assert (ivals != null);
		assert (!ivals.has_next ());
		
		Set<Map.Entry<string, string>> ents = test_map.entries;
		assert (ents != null);
		Iterator<Map.Entry<string, string>> ients = ents.iterator ();
		assert (ients != null);
		assert (!ients.has_next ());
		
		MapIterator<string, string> iter = test_map.map_iterator ();
		assert (iter != null);
		assert (!iter.has_next ());
	}

	public void test_set_all () {
		var another_map = new HashMap<string,string> ();

		test_map.set ("one", "value_of_one");
		test_map.set ("two", "value_of_two");
		test_map.set ("three", "value_of_three");
		another_map.set ("four", "value_of_four");
		another_map.set ("five", "value_of_five");
		another_map.set ("six", "value_of_six");

		test_map.set_all (another_map);

		assert (test_map.size == 6);
		assert (test_map.has_key ("one"));
		assert (test_map.has_key ("two"));
		assert (test_map.has_key ("three"));
		assert (test_map.has_key ("four"));
		assert (test_map.has_key ("five"));
		assert (test_map.has_key ("six"));

		assert (test_map.get ("one") == "value_of_one");
		assert (test_map.get ("two") == "value_of_two");
		assert (test_map.get ("three") == "value_of_three");
		assert (test_map.get ("four") == "value_of_four");
		assert (test_map.get ("five") == "value_of_five");
		assert (test_map.get ("six") == "value_of_six");
	}

	public void test_unset_all () {
		var another_map = new HashMap<string,string> ();

		// Check unset all on empty maps.
		assert (test_map.is_empty);
		assert (another_map.is_empty);

		assert (! test_map.unset_all (another_map));

		assert (test_map.is_empty);
		assert (another_map.is_empty);

		test_map.clear ();
		another_map.clear ();

		// Test_Map is empty, another_map has entries. -> no change
		another_map.set ("one", "value_of_one");
		another_map.set ("two", "value_of_two");

		assert (test_map.is_empty);
		assert (another_map.size == 2);

		assert (! test_map.unset_all (another_map));

		assert (test_map.is_empty);
		assert (another_map.size == 2);

		test_map.clear ();
		another_map.clear ();

		// Test_Map has entries, another_map is empty. -> no change
		test_map.set ("one", "value_of_one");
		test_map.set ("two", "value_of_two");

		assert (test_map.size == 2);
		assert (another_map.is_empty);

		assert (! test_map.unset_all (another_map));

		assert (test_map.size == 2);
		assert (another_map.is_empty);

		test_map.clear ();
		another_map.clear ();

		// Test_Map and another_map have the same
		// entries -> test_map is cleared
		test_map.set ("one", "value_of_one");
		test_map.set ("two", "value_of_two");
		another_map.set ("one", "value_of_one");
		another_map.set ("two", "value_of_two");

		assert (test_map.size == 2);
		assert (another_map.size == 2);

		assert (test_map.unset_all (another_map));

		assert (test_map.is_empty);
		assert (another_map.size == 2);

		test_map.clear ();
		another_map.clear ();

		// Test_Map has some common keys with another_map
		// but both have also unique keys -> common key are
		// cleared from test_map
		test_map.set ("one", "value_of_one");
		test_map.set ("two", "value_of_two");
		test_map.set ("three", "value_of_three");
		another_map.set ("two", "value_of_two");
		another_map.set ("three", "value_of_three");
		another_map.set ("four", "value_of_four");
		another_map.set ("five", "value_of_five");

		assert (test_map.size == 3);
		assert (another_map.size == 4);

		assert (test_map.unset_all (another_map));

		assert (test_map.size == 1);
		assert (another_map.size == 4);

		assert (test_map.has_key ("one"));
	}

	public void test_has_all () {
		var another_map = new HashMap<string,string> ();

		// Check empty.
		assert (test_map.has_all (another_map));

		// Test_Map has items, another_map is empty.
		test_map.set ("one", "value_of_one");

		assert (test_map.has_all (another_map));

		test_map.clear ();
		another_map.clear ();

		// Test_Map is empty, another_map has items.
		another_map.set ("one", "value_of_one");

		assert (! test_map.has_all (another_map));

		test_map.clear ();
		another_map.clear ();

		// Test_Map and another_map are the same.
		test_map.set ("one", "value_of_one");
		test_map.set ("two", "value_of_two");

		another_map.set ("one", "value_of_one");
		another_map.set ("two", "value_of_two");

		assert (test_map.has_all (another_map));

		test_map.clear ();
		another_map.clear ();

		// Test_Map and another_map are not the same.
		test_map.set ("one", "value_of_one");
		test_map.set ("two", "value_of_two");

		another_map.set ("one", "another_value_of_one");
		another_map.set ("two", "another_value_of_two");

		assert (! test_map.has_all (another_map));

		test_map.clear ();
		another_map.clear ();

		// Test_Map and another_map are not the same
		test_map.set ("one", "value_of_one");
		another_map.set ("two", "value_of_two");

		assert (! test_map.has_all (another_map));

		test_map.clear ();
		another_map.clear ();

		// Test_Map has a subset of another_map
		test_map.set ("one", "value_of_one");
		test_map.set ("two", "value_of_two");
		test_map.set ("three", "value_of_three");
		test_map.set ("four", "value_of_four");
		test_map.set ("five", "value_of_five");
		test_map.set ("six", "value_of_six");
		another_map.set ("two", "value_of_two");
		another_map.set ("three", "value_of_three");
		another_map.set ("four", "value_of_four");

		assert (test_map.has_all (another_map));

		test_map.clear ();
		another_map.clear ();

		// Test_Map has a subset of another_map in all but one element another_map
		test_map.set ("one", "value_of_one");
		test_map.set ("two", "value_of_two");
		test_map.set ("three", "value_of_three");
		test_map.set ("four", "value_of_four");
		test_map.set ("five", "value_of_five");
		test_map.set ("six", "value_of_six");
		another_map.set ("two", "value_of_two");
		another_map.set ("three", "value_of_three");
		another_map.set ("four", "value_of_four");
		another_map.set ("height", "value_of_height");

		assert (! test_map.has_all (another_map));
	}

	public void test_gobject_properties () {
		// Check the map exists
		assert (test_map != null);
		Value value;

		value = Value (typeof (int));
		test_map.get_property ("size", ref value);
		assert (value.get_int () == test_map.size);
		value.unset ();
	}

	public void test_fold () {
		test_map.set ("one", "one");
		test_map.set ("two", "two");
		test_map.set ("three", "three");
		
		int count;
		
		count = test_map.map_iterator ().fold<int> ((x, y, z) => {return z + 1;}, 0);
		assert (count == 3);
		
		var iter = test_map.map_iterator ();
		assert (iter.next ());
		count = iter.fold<int> ((x, y, z) => {return z + 1;}, 0);
		assert (count == 3);
	}
	
	public void test_foreach () {
		test_map.set ("one", "one");
		test_map.set ("two", "two");
		test_map.set ("three", "three");
		
		int count = 0;
		
		test_map.map_iterator ().foreach ((x, y) => {count++; return true;});
		assert (count == 3);
		
		var iter = test_map.map_iterator ();
		assert (iter.next ());
		iter.foreach ((x, y) => {count++; return true;});
		assert (count == 6);
	}

	public static Map.Entry<string,string> entry_for (string key, string value) {
		return new TestEntry<string,string> (key, value);
	}
	
	public static bool check_entry (owned Map.Entry<string,string> e, string key, string value) {
		return e.key == key && e.value == value;
	}
	
	public static void assert_entry (Map.Entry<string,string> e, string key, string value) {
		assert (e.key == key);
		assert (e.value == value);
	}
	
	private class TestEntry<K,V> : Map.Entry<K,V> {
		public TestEntry (K key, V value) {
			this._key = key;
			this.value = value;
		}
		
		public override K key { get {return _key; } }
		private K _key;
		public override V value { get; set; }
		public override bool read_only { get { return false; } }
	}
}

