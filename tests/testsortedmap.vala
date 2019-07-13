/* sortedset.vala
 *
 * Copyright (C) 2009-2011  Maciej Piechotka
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
 * 	Maciej Piechotka <uzytkownik2@gmail.com>
 */

public abstract class Gee.SortedMapTests : MapTests {
	protected SortedMapTests (string name) {
		base (name);
		add_test ("[SortedMap] key ordering", test_key_ordering);
		add_test ("[SortedMap] first", test_first);
		add_test ("[SortedMap] last", test_last);
		add_test ("[SortedMap] iterator_at", test_iterator_at);
		add_test ("[SortedMap] lower", test_lower);
		add_test ("[SortedMap] higher", test_higher);
		add_test ("[SortedMap] floor", test_floor);
		add_test ("[SortedMap] ceil", test_ceil);
		get_suite ().add_suite (new SubMapTests (this, SubMapTests.Type.HEAD).get_suite ());
		get_suite ().add_suite (new SubMapTests (this, SubMapTests.Type.TAIL).get_suite ());
		get_suite ().add_suite (new SubMapTests (this, SubMapTests.Type.SUB).get_suite ());
		get_suite ().add_suite (new SubMapTests (this, SubMapTests.Type.EMPTY).get_suite ());
	}

	public void test_key_ordering () {
		var test_sorted_map = test_map as SortedMap<string,string>;

		// Check the map exists
		assert (test_sorted_map != null);

		test_sorted_map.set ("one", "one");
		test_sorted_map.set ("two", "two");
		test_sorted_map.set ("three", "three");
		test_sorted_map.set ("four", "four");
		test_sorted_map.set ("five", "five");
		test_sorted_map.set ("six", "six");
		test_sorted_map.set ("seven", "seven");
		test_sorted_map.set ("eight", "eight");
		test_sorted_map.set ("nine", "nine");
		test_sorted_map.set ("ten", "ten");
		test_sorted_map.set ("eleven", "eleven");
		test_sorted_map.set ("twelve", "twelve");

		Iterator<string> iterator = test_sorted_map.keys.iterator ();
		assert (iterator.next ());
		assert (iterator.get () == "eight");
		assert (iterator.next ());
		assert (iterator.get () == "eleven");
		assert (iterator.next ());
		assert (iterator.get () == "five");
		assert (iterator.next ());
		assert (iterator.get () == "four");
		assert (iterator.next ());
		assert (iterator.get () == "nine");
		assert (iterator.next ());
		assert (iterator.get () == "one");
		assert (iterator.next ());
		assert (iterator.get () == "seven");
		assert (iterator.next ());
		assert (iterator.get () == "six");
		assert (iterator.next ());
		assert (iterator.get () == "ten");
		assert (iterator.next ());
		assert (iterator.get () == "three");
		assert (iterator.next ());
		assert (iterator.get () == "twelve");
		assert (iterator.next ());
		assert (iterator.get () == "two");
		assert (iterator.next () == false);
	}
	
	public void test_first () {
		var test_sorted_map = test_map as SortedMap<string,string>;
		var keys = test_sorted_map.ascending_keys;
		var entries = test_sorted_map.ascending_entries;

		// Check the map exists
		assert (test_sorted_map != null);
		
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			keys.first ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			entries.first ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		test_sorted_map.set ("one", "one");
		test_sorted_map.set ("two", "two");
		test_sorted_map.set ("three", "three");
		test_sorted_map.set ("four", "four");
		test_sorted_map.set ("five", "five");
		test_sorted_map.set ("six", "six");
		test_sorted_map.set ("seven", "seven");
		test_sorted_map.set ("eight", "eight");
		test_sorted_map.set ("nine", "nine");
		test_sorted_map.set ("ten", "ten");
		test_sorted_map.set ("eleven", "eleven");
		test_sorted_map.set ("twelve", "twelve");
		
		assert (keys.first () == "eight");
		/*assert_entry (entries.first (), "eight", "eight");*/
	}

	public void test_last () {
		var test_sorted_map = test_map as SortedMap<string,string>;
		var keys = test_sorted_map.ascending_keys;
		var entries = test_sorted_map.ascending_entries;
		// Check the map exists
		assert (test_sorted_map != null);
		
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			keys.last ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			entries.last ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		test_sorted_map.set ("one", "one");
		test_sorted_map.set ("two", "two");
		test_sorted_map.set ("three", "three");
		test_sorted_map.set ("four", "four");
		test_sorted_map.set ("five", "five");
		test_sorted_map.set ("six", "six");
		test_sorted_map.set ("seven", "seven");
		test_sorted_map.set ("eight", "eight");
		test_sorted_map.set ("nine", "nine");
		test_sorted_map.set ("ten", "ten");
		test_sorted_map.set ("eleven", "eleven");
		test_sorted_map.set ("twelve", "twelve");
		
		assert (keys.last () == "two");
		assert_entry (entries.last (), "two", "two");
	}

	public void test_iterator_at () {
		var test_sorted_map = test_map as SortedMap<string,string>;
		var keys = test_sorted_map.ascending_keys;
		var entries = test_sorted_map.ascending_entries;

		test_map.set ("one", "one");
		test_map.set ("two", "two");
		test_map.set ("three", "three");

		var keys_iter = keys.iterator_at ("one");
		assert (keys_iter != null);
		assert (keys_iter.get () == "one");

		var entries_iter = entries.iterator_at (entry_for ("one", "one"));
		assert (entries_iter != null);
		assert_entry (entries_iter.get (), "one", "one");

		keys_iter = keys.iterator_at ("two");
		assert (keys_iter != null);
		assert (keys_iter.get () == "two");

		entries_iter = entries.iterator_at (entry_for ("two", "two"));
		assert (entries_iter != null);
		assert_entry (entries_iter.get (), "two", "two");

		keys_iter = keys.iterator_at ("three");
		assert (keys_iter != null);
		assert (keys_iter.get () == "three");

		entries_iter = entries.iterator_at (entry_for ("three", "three"));
		assert (entries_iter != null);
		assert_entry (entries_iter.get (), "three", "three");

		keys_iter = keys.iterator_at ("zero");
		assert (keys_iter == null);

		entries_iter = entries.iterator_at (entry_for ("zero", "zero"));
		assert (entries_iter == null);
	}
	
	public void test_lower () {
		var test_sorted_map = test_map as SortedMap<string,string>;
		var keys = test_sorted_map.ascending_keys;
		var entries = test_sorted_map.ascending_entries;

		assert (keys.lower ("one") == null);

		test_sorted_map.set ("one", "one");
		test_sorted_map.set ("two", "two");
		test_sorted_map.set ("three", "three");
		test_sorted_map.set ("four", "four");
		test_sorted_map.set ("five", "five");
		test_sorted_map.set ("six", "six");

		assert (keys.lower ("one") == "four");
		assert_entry (entries.lower (entry_for ("one", "one")), "four", "four");

		assert (keys.lower ("o") == "four");
		assert_entry (entries.lower (entry_for ("o", "one")), "four", "four");

		assert (keys.lower ("two") == "three");
		assert_entry (entries.lower (entry_for ("two", "two")), "three", "three");

		assert (keys.lower ("t") == "six");
		assert_entry (entries.lower (entry_for ("t", "two")), "six", "six");

		assert (keys.lower ("three") == "six");
		assert_entry (entries.lower (entry_for ("three", "three")), "six", "six");

		assert (keys.lower ("four") == "five");
		assert_entry (entries.lower (entry_for ("four", "four")), "five", "five");

		assert (keys.lower ("f") == null);
		assert (entries.lower (entry_for ("f", "four")) == null);

		assert (keys.lower ("five") == null);
		assert (entries.lower (entry_for ("five", "five")) == null);

		assert (keys.lower ("six") == "one");
		assert_entry (entries.lower (entry_for ("six", "six")), "one", "one");

		assert (keys.lower ("s") == "one");
		assert_entry (entries.lower (entry_for ("s", "six")), "one", "one");

	}
	
	public void test_higher () {
		var test_sorted_map = test_map as SortedMap<string,string>;
		var keys = test_sorted_map.ascending_keys;
		var entries = test_sorted_map.ascending_entries;

		assert (keys.higher ("one") == null);

		test_sorted_map.set ("one", "one");
		test_sorted_map.set ("two", "two");
		test_sorted_map.set ("three", "three");
		test_sorted_map.set ("four", "four");
		test_sorted_map.set ("five", "five");
		test_sorted_map.set ("six", "six");

		assert (keys.higher ("one") == "six");
		assert_entry (entries.higher (entry_for ("one", "one")), "six", "six");

		assert (keys.higher ("o") == "one");
		assert_entry (entries.higher (entry_for ("o", "one")), "one", "one");

		assert (keys.higher ("two") == null);
		assert (entries.higher (entry_for ("two", "two")) == null);

		assert (keys.higher ("t") == "three");
		assert_entry (entries.higher (entry_for ("t", "two")), "three", "three");

		assert (keys.higher ("three") == "two");
		assert_entry (entries.higher (entry_for ("three", "three")), "two", "two");

		assert (keys.higher ("four") == "one");
		assert_entry (entries.higher (entry_for ("four", "four")), "one", "one");

		assert (keys.higher ("f") == "five");
		assert_entry (entries.higher (entry_for ("f", "four")), "five", "five");

		assert (keys.higher ("five") == "four");
		assert_entry (entries.higher (entry_for ("five", "five")), "four", "four");

		assert (keys.higher ("six") == "three");
		assert_entry (entries.higher (entry_for ("six", "six")), "three", "three");

		assert (keys.higher ("s") == "six");
		assert_entry (entries.higher (entry_for ("s", "six")), "six", "six");
	}
	
	public void test_floor () {
		var test_sorted_map = test_map as SortedMap<string,string>;
		var keys = test_sorted_map.ascending_keys;
		var entries = test_sorted_map.ascending_entries;

		assert (keys.floor ("one") == null);

		test_sorted_map.set ("one", "one");
		test_sorted_map.set ("two", "two");
		test_sorted_map.set ("three", "three");
		test_sorted_map.set ("four", "four");
		test_sorted_map.set ("five", "five");
		test_sorted_map.set ("six", "six");

		assert (keys.floor ("one") == "one");
		assert_entry (entries.floor (entry_for ("one", "one")), "one", "one");

		assert (keys.floor ("o") == "four");
		assert_entry (entries.floor (entry_for ("o", "one")), "four", "four");

		assert (keys.floor ("two") == "two");
		assert_entry (entries.floor (entry_for ("two", "two")), "two", "two");

		assert (keys.floor ("t") == "six");
		assert_entry (entries.floor (entry_for ("t", "two")), "six", "six");

		assert (keys.floor ("three") == "three");
		assert_entry (entries.floor (entry_for ("three", "three")), "three", "three");

		assert (keys.floor ("four") == "four");
		assert_entry (entries.floor (entry_for ("four", "four")), "four", "four");

		assert (keys.floor ("f") == null);
		assert (entries.floor (entry_for ("f", "four")) == null);

		assert (keys.floor ("five") == "five");
		assert_entry (entries.floor (entry_for ("five", "five")), "five", "five");

		assert (keys.floor ("six") == "six");
		assert_entry (entries.floor (entry_for ("six", "six")), "six", "six");

		assert (keys.floor ("s") == "one");
		assert_entry (entries.floor (entry_for ("s", "six")), "one", "one");
	}
	
	public void test_ceil () {
		var test_sorted_map = test_map as SortedMap<string,string>;
		var keys = test_sorted_map.ascending_keys;
		var entries = test_sorted_map.ascending_entries;

		assert (keys.ceil ("one") == null);

		test_sorted_map.set ("one", "one");
		test_sorted_map.set ("two", "two");
		test_sorted_map.set ("three", "three");
		test_sorted_map.set ("four", "four");
		test_sorted_map.set ("five", "five");
		test_sorted_map.set ("six", "six");

		assert (keys.ceil ("one") == "one");
		assert_entry (entries.ceil (entry_for ("one", "one")), "one", "one");

		assert (keys.ceil ("o") == "one");
		assert_entry (entries.ceil (entry_for ("o", "one")), "one", "one");

		assert (keys.ceil ("two") == "two");
		assert_entry (entries.ceil (entry_for ("two", "two")), "two", "two");

		assert (keys.ceil ("t") == "three");
		assert_entry (entries.ceil (entry_for ("t", "two")), "three", "three");

		assert (keys.ceil ("three") == "three");
		assert_entry (entries.ceil (entry_for ("three", "three")), "three", "three");

		assert (keys.ceil ("four") == "four");
		assert_entry (entries.ceil (entry_for ("four", "four")), "four", "four");

		assert (keys.ceil ("f") == "five");
		assert_entry (entries.ceil (entry_for ("f", "four")), "five", "five");

		assert (keys.ceil ("five") == "five");
		assert_entry (entries.ceil (entry_for ("five", "five")), "five", "five");

		assert (keys.ceil ("six") == "six");
		assert_entry (entries.ceil (entry_for ("six", "six")), "six", "six");

		assert (keys.ceil ("s") == "six");
		assert_entry (entries.ceil (entry_for ("s", "six")), "six", "six");
	}

	public class SubMapTests : Gee.TestCase {
		private SortedMap<string,string> master;
		private SortedMap<string,string> submap;
		private SortedMapTests test;
		public enum Type {
			HEAD,
			TAIL,
			SUB,
			EMPTY;
			public unowned string to_string () {
				switch (this) {
				case Type.HEAD: return "Head";
				case Type.TAIL: return "Tail";
				case Type.SUB: return "Range";
				case Type.EMPTY: return "Empty";
				default: assert_not_reached ();
				}
			}
		}
		private Type type;
		
		public SubMapTests (SortedMapTests test, Type type) {
			base ("%s Submap".printf (type.to_string ()));
			this.test = test;
			this.type = type;
			add_test ("[Map] has_key, size and is_empty",
			          test_has_key_size_is_empty);
			add_test ("[Map] keys", test_keys);
			add_test ("[Map] values", test_values);
			add_test ("[Map] entries", test_entries);
			add_test ("[Map] get", test_get);
			add_test ("[Map] set", test_set);
			add_test ("[Map] unset", test_unset);
			add_test ("[Map] clear", test_clear);
			add_test ("[Map] iterators", test_iterators);
			add_test ("[SortedMap] boundaries", test_boundaries);
			add_test ("[SortedMap] lower", test_lower);
			add_test ("[SortedMap] higher", test_higher);
			add_test ("[SortedMap] floor", test_floor);
			add_test ("[SortedMap] ceil", test_ceil);
			add_test ("[SortedMap] iterator_at", test_iterator_at);
			add_test ("[SortedMap] submap and subsets", test_submap_and_subsets);
		}

		public override void set_up () {
			test.set_up ();
			master = test.test_map as SortedMap<string,string>;
			switch (type) {
			case Type.HEAD:
				submap = master.head_map ("one"); break;
			case Type.TAIL:
				submap = master.tail_map ("six"); break;
			case Type.SUB:
				submap = master.sub_map ("four", "three"); break;
			case Type.EMPTY:
				submap = master.sub_map ("three", "four"); break;
			default:
				assert_not_reached ();
			}
		}

		public override void tear_down () {
			test.tear_down ();
		}
		
		protected void set_default_values (out string[] contains = null, out string[] not_contains = null) {
			master.set ("one", "one");
			master.set ("two", "two");
			master.set ("three", "three");
			master.set ("four", "four");
			master.set ("five", "five");
			master.set ("six", "six");
			switch (type) {
			case Type.HEAD:
				contains = {"five", "four"};
				not_contains = {"one", "two", "three", "six"};
				break;
			case Type.TAIL:
				contains = {"six", "three", "two"};
				not_contains = {"one", "four", "five"};
				break;
			case Type.SUB:
				contains = {"four", "one", "six"};
				not_contains = {"two", "three", "five"};
				break;
			case Type.EMPTY:
				contains = {};
				not_contains = {"one", "two", "three", "four", "five", "six"};
				break;
			default:
				assert_not_reached ();
			}
		}
		
		public void test_has_key_size_is_empty () {
			string[] contains, not_contains;
			
			set_default_values (out contains, out not_contains);
			
			assert (submap.size == contains.length);
			assert (submap.is_empty == (contains.length == 0));

			foreach (var s in contains) {
				assert (submap.has_key (s));
				assert (submap.has (s, s));
			}
			foreach (var s in not_contains) {
				assert (!submap.has_key (s));
				assert (!submap.has (s, s));
			}
		}

		public void test_get () {
			string[] contains, not_contains;
			
			set_default_values (out contains, out not_contains);
			
			foreach (var s in contains) {
				assert (submap.get (s) == s);
			}
		}
		
		public void test_keys () {
			var keys = submap.keys;
			
			assert (keys.size == 0);
			assert (keys.is_empty);

			string[] contains, not_contains;
			
			set_default_values (out contains, out not_contains);
			
			assert (keys.size == contains.length);
			foreach (var s in contains)
				assert (keys.contains (s));
			foreach (var s in not_contains)
				assert (!keys.contains (s));
	
			if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
			                   TestTrapFlags.SILENCE_STDERR)) {
				keys.add ("three");
				Posix.exit (0);
			}
			Test.trap_assert_failed ();
	
			if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
			                   TestTrapFlags.SILENCE_STDERR)) {
				keys.remove ("three");
				Posix.exit (0);
			}
			Test.trap_assert_failed ();
		}

		public void test_values () {
			var values = submap.values;
			
			assert (values.size == 0);
			assert (values.is_empty);

			string[] contains, not_contains;
			
			set_default_values (out contains, out not_contains);
			
			assert (values.size == contains.length);
			foreach (var s in contains)
				assert (values.contains (s));
			foreach (var s in not_contains)
				assert (!values.contains (s));

			if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
			                   TestTrapFlags.SILENCE_STDERR)) {
				values.add ("three");
				Posix.exit (0);
			}
			Test.trap_assert_failed ();

			if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
			                   TestTrapFlags.SILENCE_STDERR)) {
				values.remove ("three");
				Posix.exit (0);
			}
			Test.trap_assert_failed ();
		}

		public void test_entries () {
			var entries = submap.entries;
			
			assert (entries.size == 0);
			assert (entries.is_empty);

			string[] contains, not_contains;
			
			set_default_values (out contains, out not_contains);
			
			assert (entries.size == contains.length);
			foreach (var s in contains)
				assert (entries.contains (MapTests.entry_for (s, s)));
			foreach (var s in not_contains)
				assert (!entries.contains (MapTests.entry_for (s, s)));

			if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
			                   TestTrapFlags.SILENCE_STDERR)) {
				entries.add (MapTests.entry_for ("three", "three"));
				Posix.exit (0);
			}
			Test.trap_assert_failed ();

			if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
			                   TestTrapFlags.SILENCE_STDERR)) {
				entries.remove (MapTests.entry_for ("three", "three"));
				Posix.exit (0);
			}
			Test.trap_assert_failed ();
		}
		
		public void test_set () {
			string[] contains, not_contains;
			
			set_default_values (out contains, out not_contains);
			
			string[] success, fail;
			switch (type) {
			case Type.HEAD:
				success = {"a", "o"};
				fail = {"oz", "z"};
				break;
			case Type.TAIL:
				success = {"siz", "z"};
				fail = {"sia", "a"};
				break;
			case Type.SUB:
				success = {"o", "th"};
				fail = {"f", "u"};
				break;
			case Type.EMPTY:
				success = {};
				fail = {"o", "th", "f", "u"};
				break;
			default:
				assert_not_reached ();
			}
			
			foreach (var s in success) {
				submap.set (s, s);
				assert (submap.has (s, s));
				assert (master.has (s, s));
			}

			foreach (var s in fail) {
				submap.set (s, s);
				assert (!submap.has_key (s));
				assert (!master.has_key (s));
			}
			
			assert (master.size == 6 + success.length);
		}
		
		public void test_unset () {
			string[] contains, not_contains;
			
			set_default_values (out contains, out not_contains);
			
			foreach (var s in contains) {
				string? value;
				assert (submap.unset (s, out value));
				assert (value == s);
				assert (!master.has_key (s));
			}
			foreach (var s in not_contains) {
				assert (!submap.unset (s));
				assert (master.has (s, s));
			}

			assert (master.size == 6 - contains.length);
		}

		public void test_clear () {
			string[] contains, not_contains;

			set_default_values (out contains, out not_contains);

			submap.clear ();
			
			foreach (var s in contains) {
				assert (!master.has_key (s));
			}
			foreach (var s in not_contains) {
				assert (!submap.unset (s));
				assert (master.has (s, s));
			}
			
			assert (master.size == 6 - contains.length);
		}

		public void test_iterators () {
			string[] contains, not_contains;

			var _map_iter = submap.map_iterator ();

			assert (!_map_iter.has_next ());
			assert (!_map_iter.next ());

			set_default_values (out contains, out not_contains);

			var i = 0;
			_map_iter = submap.map_iterator ();
			while (_map_iter.next ()) {
				assert (_map_iter.get_key () == contains[i]);
				assert (_map_iter.get_value () == contains[i]);
				i++;
			}
			assert (i == contains.length);

			i = 0;
			foreach (var k in submap.keys)
				assert (k == contains[i++]);
			assert (i == contains.length);

			i = 0;
			foreach (var e in submap.entries) {
				MapTests.assert_entry (e, contains[i], contains[i]);
				i++;
			}
			assert (i == contains.length);

			if (type != Type.EMPTY) {
				var map_iter = submap.map_iterator ();
				assert (map_iter.next ());

				assert (map_iter.get_key () == contains[0]);
				assert (map_iter.get_value () == contains[0]);

				assert (map_iter.has_next ());
				assert (map_iter.next ());
				assert (map_iter.get_key () == contains[1]);
				assert (map_iter.get_value () == contains[1]);

				// Repeat for keys
				master.clear ();
				set_default_values (out contains, out not_contains);
				var keys_iter = submap.ascending_keys.iterator ();

				assert (keys_iter.has_next ());
				assert (keys_iter.next ());

				assert (keys_iter.get () == contains[0]);
				assert (keys_iter.has_next ());
				assert (keys_iter.next ());
				assert (keys_iter.get () == contains[1]);
				
				// Repeat for entries
				master.clear ();
				set_default_values (out contains, out not_contains);
				var entries_iter = submap.ascending_entries.iterator ();

				assert (entries_iter.has_next ());
				assert (entries_iter.next ());

				MapTests.assert_entry (entries_iter.get (), contains[0], contains[0]);
				assert (entries_iter.has_next ());
				assert (entries_iter.next ());
				MapTests.assert_entry (entries_iter.get (), contains[1], contains[1]);
			} else {
				var keys_iter = submap.ascending_keys.iterator ();
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					keys_iter.remove ();
					Posix.exit (0);
				}
				Test.trap_assert_failed ();
			}
		}
		
		public void test_boundaries () {
			var keys = submap.ascending_keys;
			var entries = submap.ascending_entries;

			string[] contains, not_contains;
			
			set_default_values (out contains, out not_contains);
			
			switch (type) {
			case Type.HEAD:
				assert (keys.first () == "five");
				assert (keys.last () == "four");
				assert_entry (entries.first (), "five", "five");
				assert_entry (entries.last (), "four", "four");
				break;
			case Type.TAIL:
				assert (keys.first () == "six");
				assert (keys.last () == "two");
				assert_entry (entries.first (), "six", "six");
				assert_entry (entries.last (), "two", "two");
				break;
			case Type.SUB:
				assert (keys.first () == "four");
				assert (keys.last () == "six");
				assert_entry (entries.first (), "four", "four");
				assert_entry (entries.last (), "six", "six");
				break;
			case Type.EMPTY:
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					keys.first ();
					Posix.exit (0);
				}
				Test.trap_assert_failed ();
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					keys.last ();
					Posix.exit (0);
				}
				Test.trap_assert_failed ();
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					entries.first ();
					Posix.exit (0);
				}
				Test.trap_assert_failed ();
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					entries.last ();
					Posix.exit (0);
				}
				Test.trap_assert_failed ();
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_lower () {
			string[] contains, not_contains;
			var keys = submap.ascending_keys;
			var entries = submap.ascending_entries;
			
			set_default_values (out contains, out not_contains);
			
			switch (type) {
			case Type.HEAD:
				assert (keys.lower ("a") == null);
				assert (entries.lower (MapTests.entry_for ("a", "a")) == null);
				assert (keys.lower ("five") == null);
				assert (entries.lower (MapTests.entry_for ("five", "five")) == null);
				assert (keys.lower ("four") == "five");
				MapTests.assert_entry (entries.lower (MapTests.entry_for ("four", "four")), "five", "five");
				assert (keys.lower ("six") == "four");
				MapTests.assert_entry (entries.lower (MapTests.entry_for ("six", "six")), "four", "four");
				break;
			case Type.TAIL:
				assert (keys.lower ("one") == null);
				assert (entries.lower (MapTests.entry_for ("one", "one")) == null);
				assert (keys.lower ("six") == null);
				assert (entries.lower (MapTests.entry_for ("six", "six")) == null);
				assert (keys.lower ("three") == "six");
				MapTests.assert_entry (entries.lower (MapTests.entry_for ("three", "three")), "six", "six");
				assert (keys.lower ("two") == "three");
				MapTests.assert_entry (entries.lower (MapTests.entry_for ("two", "two")), "three", "three");
				assert (keys.lower ("z") == "two");
				MapTests.assert_entry (entries.lower (MapTests.entry_for ("z", "z")), "two", "two");
				break;
			case Type.SUB:
				assert (keys.lower ("five") == null);
				assert (entries.lower (MapTests.entry_for ("five", "five")) == null);
				assert (keys.lower ("four") == null);
				assert (entries.lower (MapTests.entry_for ("four", "four")) == null);
				assert (keys.lower ("one") == "four");
				MapTests.assert_entry (entries.lower (MapTests.entry_for ("one", "one")), "four", "four");
				assert (keys.lower ("six") == "one");
				MapTests.assert_entry (entries.lower (MapTests.entry_for ("six", "six")), "one", "one");
				assert (keys.lower ("three") == "six");
				MapTests.assert_entry (entries.lower (MapTests.entry_for ("three", "three")), "six", "six");
				break;
			case Type.EMPTY:
				assert (keys.lower ("six") == null);
				assert (entries.lower (MapTests.entry_for ("six", "six")) == null);
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_higher () {
			string[] contains, not_contains;
			var keys = submap.ascending_keys;
			var entries = submap.ascending_entries;
			
			set_default_values (out contains, out not_contains);
			
			switch (type) {
			case Type.HEAD:
				assert (keys.higher ("a") == "five");
				MapTests.assert_entry (entries.higher (MapTests.entry_for ("a", "a")), "five", "five");
				assert (keys.higher ("five") == "four");
				MapTests.assert_entry (entries.higher (MapTests.entry_for ("five", "five")), "four", "four");
				assert (keys.higher ("four") == null);
				assert (entries.higher (MapTests.entry_for ("four", "four")) == null);
				assert (keys.higher ("six") == null);
				assert (entries.higher (MapTests.entry_for ("six", "six")) == null);
				break;
			case Type.TAIL:
				assert (keys.higher ("one") == "six");
				MapTests.assert_entry (entries.higher (MapTests.entry_for ("one", "one")), "six", "six");
				assert (keys.higher ("six") == "three");
				MapTests.assert_entry (entries.higher (MapTests.entry_for ("six", "six")), "three", "three");
				assert (keys.higher ("three") == "two");
				MapTests.assert_entry (entries.higher (MapTests.entry_for ("three", "three")), "two", "two");
				assert (keys.higher ("two") == null);
				assert (entries.higher (MapTests.entry_for ("two", "two")) == null);
				assert (keys.higher ("z") == null);
				assert (entries.higher (MapTests.entry_for ("z", "z")) == null);
				break;
			case Type.SUB:
				assert (keys.higher ("five") == "four");
				MapTests.assert_entry (entries.higher (MapTests.entry_for ("five", "five")), "four", "four");
				assert (keys.higher ("four") == "one");
				MapTests.assert_entry (entries.higher (MapTests.entry_for ("four", "four")), "one", "one");
				assert (keys.higher ("one") == "six");
				MapTests.assert_entry (entries.higher (MapTests.entry_for ("one", "one")), "six", "six");
				assert (keys.higher ("six") == null);
				assert (entries.higher (MapTests.entry_for ("six", "six")) == null);
				assert (keys.higher ("three") == null);
				assert (entries.higher (MapTests.entry_for ("three", "three")) == null);
				break;
			case Type.EMPTY:
				assert (keys.higher ("six") == null);
				assert (entries.higher (MapTests.entry_for ("six", "six")) == null);
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_floor () {
			string[] contains, not_contains;
			var keys = submap.ascending_keys;
			var entries = submap.ascending_entries;
			
			set_default_values (out contains, out not_contains);
			
			switch (type) {
			case Type.HEAD:
				assert (keys.floor ("a") == null);
				assert (entries.floor (MapTests.entry_for ("a", "a")) == null);
				assert (keys.floor ("five") == "five");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("five", "fiv")), "five", "five");
				assert (keys.floor ("four") == "four");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("four", "four")), "four", "four");
				assert (keys.floor ("six") == "four");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("six", "six")), "four", "four");
				break;
			case Type.TAIL:
				assert (keys.floor ("one") == null);
				assert (entries.floor (MapTests.entry_for ("one", "one")) == null);
				assert (keys.floor ("six") == "six");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("six", "six")), "six", "six");
				assert (keys.floor ("three") == "three");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("three", "three")), "three", "three");
				assert (keys.floor ("two") == "two");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("two", "two")), "two", "two");
				assert (keys.floor ("z") == "two");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("z", "z")), "two", "two");
				break;
			case Type.SUB:
				assert (keys.floor ("five") == null);
				assert (entries.floor (MapTests.entry_for ("five", "five")) == null);
				assert (keys.floor ("four") == "four");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("four", "four")), "four", "four");
				assert (keys.floor ("one") == "one");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("one", "one")), "one", "one");
				assert (keys.floor ("six") == "six");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("six", "six")), "six", "six");
				assert (keys.floor ("three") == "six");
				MapTests.assert_entry (entries.floor (MapTests.entry_for ("three", "three")), "six", "six");
				break;
			case Type.EMPTY:
				assert (keys.floor ("six") == null);
				assert (entries.floor (MapTests.entry_for ("six", "six")) == null);
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_ceil () {
			string[] contains, not_contains;
			var keys = submap.ascending_keys;
			var entries = submap.ascending_entries;
			
			set_default_values (out contains, out not_contains);
			
			switch (type) {
			case Type.HEAD:
				assert (keys.ceil ("a") == "five");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("a", "a")), "five", "five");
				assert (keys.ceil ("five") == "five");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("five", "five")), "five", "five");
				assert (keys.ceil ("four") == "four");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("four", "four")), "four", "four");
				assert (keys.ceil ("six") == null);
				assert (entries.ceil (MapTests.entry_for ("six", "six")) == null);
				break;
			case Type.TAIL:
				assert (keys.ceil ("one") == "six");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("one", "one")), "six", "six");
				assert (keys.ceil ("six") == "six");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("six", "six")), "six", "six");
				assert (keys.ceil ("three") == "three");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("three", "three")), "three", "three");
				assert (keys.ceil ("two") == "two");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("two", "two")), "two", "two");
				assert (keys.ceil ("z") == null);
				assert (entries.ceil (MapTests.entry_for ("z", "z")) == null);
				break;
			case Type.SUB:
				assert (keys.ceil ("five") == "four");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("five", "five")), "four", "four");
				assert (keys.ceil ("four") == "four");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("four", "four")), "four", "four");
				assert (keys.ceil ("one") == "one");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("one", "one")), "one", "one");
				assert (keys.ceil ("six") == "six");
				MapTests.assert_entry (entries.ceil (MapTests.entry_for ("six", "six")), "six", "six");
				assert (keys.ceil ("three") == null);
				assert (entries.ceil (MapTests.entry_for ("three", "three")) == null);
				break;
			case Type.EMPTY:
				assert (keys.ceil ("six") == null);
				assert (entries.ceil (MapTests.entry_for ("six", "six")) == null);
				break;
			default:
				assert_not_reached ();
			}
		}
		
		public void test_iterator_at () {
			string[] contains, not_contains;
			var keys = submap.ascending_keys;
			var entries = submap.ascending_entries;
			
			set_default_values (out contains, out not_contains);
			
			foreach (var s in contains) {
				var key_iter = keys.iterator_at (s);
				var entry_iter = entries.iterator_at (MapTests.entry_for (s, s));
				assert (key_iter != null);
				assert (key_iter.get () == s);
				MapTests.assert_entry (entry_iter.get (), s, s);
			}
			foreach (var s in not_contains) {
				var key_iter = keys.iterator_at (s);
				var entry_iter = entries.iterator_at (MapTests.entry_for (s, s));
				assert (key_iter == null);
				assert (entry_iter == null);
			}
			assert (keys.iterator_at ("seven") == null);
			assert (entries.iterator_at (MapTests.entry_for ("seven", "seven")) == null);
		}
		
		public void test_submap_and_subsets () {
			string[] contains, not_contains;
			var keys = submap.ascending_keys;
			var entries = submap.ascending_entries;
			
			set_default_values (out contains, out not_contains);
			
			switch (type) {
			case Type.HEAD:
				var subsubmap = submap.head_map ("four");
				var keyssubset = keys.head_set ("four");
				var entriessubset = entries.head_set (MapTests.entry_for ("four", "four"));

				assert (subsubmap.size == 1);
				assert (keyssubset.size == 1);
				assert (entriessubset.size == 1);

				subsubmap = submap.tail_map ("four");
				keyssubset = keys.tail_set ("four");
				entriessubset = entries.tail_set (MapTests.entry_for ("four", "four"));

				assert (subsubmap.size == 1);
				assert (keyssubset.size == 1);
				assert (entriessubset.size == 1);

				subsubmap = submap.sub_map ("four", "one");
				keyssubset = keys.sub_set ("four", "one");
				entriessubset = entries.sub_set (MapTests.entry_for ("four", "four"), MapTests.entry_for ("one", "one"));

				assert (subsubmap.size == 1);
				assert (keyssubset.size == 1);
				assert (entriessubset.size == 1);

				subsubmap = submap.sub_map ("four", "four");
				keyssubset = keys.sub_set ("four", "four");
				entriessubset = entries.sub_set (MapTests.entry_for ("four", "four"), MapTests.entry_for ("four", "four"));

				assert (subsubmap.size == 0);
				assert (keyssubset.size == 0);
				assert (entriessubset.size == 0);
				break;
			case Type.TAIL:
				var subsubmap = submap.head_map ("two");
				var keyssubset = keys.head_set ("two");
				var entriessubset = entries.head_set (MapTests.entry_for ("two", "two"));

				assert (subsubmap.size == 2);
				assert (keyssubset.size == 2);
				assert (entriessubset.size == 2);

				subsubmap = submap.tail_map ("three");
				keyssubset = keys.tail_set ("three");
				entriessubset = entries.tail_set (MapTests.entry_for ("three", "three"));

				assert (subsubmap.size == 2);
				assert (keyssubset.size == 2);
				assert (entriessubset.size == 2);

				subsubmap = submap.sub_map ("three", "two");
				keyssubset = keys.sub_set ("three", "two");
				entriessubset = entries.sub_set (MapTests.entry_for ("three", "three"), MapTests.entry_for ("two", "two"));

				assert (subsubmap.size == 1);
				assert (keyssubset.size == 1);
				assert (entriessubset.size == 1);
				break;
			case Type.SUB:
				var subsubmap = submap.head_map ("six");
				var keyssubset = keys.head_set ("six");
				var entriessubset = entries.head_set (MapTests.entry_for ("six", "six"));

				assert (subsubmap.size == 2);
				assert (keyssubset.size == 2);
				assert (entriessubset.size == 2);

				subsubmap = submap.tail_map ("one");
				keyssubset = keys.tail_set ("one");
				entriessubset = entries.tail_set (MapTests.entry_for ("one", "one"));

				assert (subsubmap.size == 2);
				assert (keyssubset.size == 2);
				assert (entriessubset.size == 2);

				subsubmap = submap.sub_map ("one", "six");
				keyssubset = keys.sub_set ("one", "six");
				entriessubset = entries.sub_set (MapTests.entry_for ("one", "one"), MapTests.entry_for ("six", "six"));

				assert (subsubmap.size == 1);
				assert (keyssubset.size == 1);
				assert (entriessubset.size == 1);

				subsubmap = submap.sub_map ("five", "two");
				keyssubset = keys.sub_set ("five", "two");
				entriessubset = entries.sub_set (MapTests.entry_for ("five", "five"), MapTests.entry_for ("two", "two"));

				assert (subsubmap.size == 3);
				assert (keyssubset.size == 3);
				assert (entriessubset.size == 3);
				break;
			case Type.EMPTY:
				var subsubmap = submap.head_map ("six");
				var keyssubset = keys.head_set ("six");
				var entriessubset = entries.head_set (MapTests.entry_for ("six", "six"));

				assert (subsubmap.size == 0);
				assert (keyssubset.size == 0);
				assert (entriessubset.size == 0);

				subsubmap = submap.tail_map ("three");
				keyssubset = keys.tail_set ("three");
				entriessubset = entries.tail_set (MapTests.entry_for ("three", "three"));

				assert (subsubmap.size == 0);
				assert (keyssubset.size == 0);
				assert (entriessubset.size == 0);

				subsubmap = submap.sub_map ("one", "six");
				keyssubset = keys.sub_set ("one", "six");
				entriessubset = entries.sub_set (MapTests.entry_for ("one", "one"), MapTests.entry_for ("six", "six"));

				assert (subsubmap.size == 0);
				assert (keyssubset.size == 0);
				assert (entriessubset.size == 0);
				break;
			default:
				assert_not_reached ();
			}
		}
	}
}

