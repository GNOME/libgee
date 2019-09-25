/* testbidirsortedmap.vala
 *
 * Copyright (C) 2012  Maciej Piechotka
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
using GLib;
using Gee;

public abstract class BidirSortedMapTests : SortedMapTests {
	protected BidirSortedMapTests(string name) {
		base (name);
		add_test ("[SortedMap] bi-directional iterators can go backward",
		          test_bidir_iterator_can_go_backward);
		add_test ("[SortedSet] bi-directional iterators can to end",
		          test_bidir_iterator_last);
		get_suite ().add_suite (new BidirSubMapTests (this, SortedMapTests.SubMapTests.Type.HEAD).get_suite ());
		get_suite ().add_suite (new BidirSubMapTests (this, SortedMapTests.SubMapTests.Type.TAIL).get_suite ());
		get_suite ().add_suite (new BidirSubMapTests (this, SortedMapTests.SubMapTests.Type.SUB).get_suite ());
		get_suite ().add_suite (new BidirSubMapTests (this, SortedMapTests.SubMapTests.Type.EMPTY).get_suite ());
	}

	public void test_bidir_iterator_can_go_backward () {
		var test_sorted_map = test_map as BidirSortedMap<string,string>;
		var keys = (test_sorted_map.ascending_keys) as BidirSortedSet<string>;
		var entries = (test_sorted_map.ascending_entries) as BidirSortedSet<Map.Entry<string,string>>;

		var keys_iterator = keys.bidir_iterator ();
		var entries_iterator = entries.bidir_iterator ();
		var map_iterator = test_sorted_map.bidir_map_iterator ();

		assert (!keys_iterator.has_previous ());
		assert (!entries_iterator.has_previous ());

		assert (!map_iterator.has_previous ());
		assert (!keys_iterator.previous ());
		assert (!entries_iterator.has_previous ());

		assert (!map_iterator.previous ());

		test_sorted_map.set ("one", "one");
		test_sorted_map.set ("two", "two");
		test_sorted_map.set ("three", "three");
		test_sorted_map.set ("four", "four");
		test_sorted_map.set ("five", "five");
		test_sorted_map.set ("six", "six");

		keys_iterator = keys.bidir_iterator ();
		entries_iterator = entries.bidir_iterator ();
		map_iterator = test_sorted_map.bidir_map_iterator ();

		assert (keys_iterator.next ());
		assert (entries_iterator.next ());

		assert (map_iterator.next ());
		assert (keys_iterator.get () == "five");
		assert_entry (entries_iterator.get (), "five", "five");

		assert (map_iterator.get_key () == "five");
		assert (map_iterator.get_value () == "five");

		assert (!keys_iterator.has_previous ());
		assert (!entries_iterator.has_previous ());

		assert (!map_iterator.has_previous ());
		assert (keys_iterator.next ());
		assert (entries_iterator.next ());

		assert (map_iterator.next ());
		assert (keys_iterator.get () == "four");
		assert_entry (entries_iterator.get (), "four", "four");

		assert (map_iterator.get_key () == "four");
		assert (map_iterator.get_value () == "four");

		assert (keys_iterator.has_previous ());
		assert (entries_iterator.has_previous ());

		assert (map_iterator.has_previous ());
		assert (keys_iterator.next ());
		assert (entries_iterator.next ());

		assert (map_iterator.next ());
		assert (keys_iterator.get () == "one");
		assert_entry (entries_iterator.get (), "one", "one");

		assert (map_iterator.get_key () == "one");
		assert (map_iterator.get_value () == "one");

		assert (keys_iterator.has_previous ());
		assert (entries_iterator.has_previous ());

		assert (map_iterator.has_previous ());
		assert (keys_iterator.next ());
		assert (entries_iterator.next ());

		assert (map_iterator.next ());
		assert (keys_iterator.get () == "six");
		assert_entry (entries_iterator.get (), "six", "six");

		assert (map_iterator.get_key () == "six");
		assert (map_iterator.get_value () == "six");
		assert (keys_iterator.has_previous ());

		assert (entries_iterator.has_previous ());
		assert (map_iterator.has_previous ());
		assert (keys_iterator.next ());

		assert (entries_iterator.next ());
		assert (map_iterator.next ());
		assert (keys_iterator.get () == "three");

		assert_entry (entries_iterator.get (), "three", "three");
		assert (map_iterator.get_key () == "three");
		assert (map_iterator.get_value () == "three");

		assert (keys_iterator.has_previous ());
		assert (entries_iterator.has_previous ());
		assert (map_iterator.has_previous ());

		assert (keys_iterator.next ());
		assert (entries_iterator.next ());
		assert (map_iterator.next ());

		assert (keys_iterator.get () == "two");
		assert_entry (entries_iterator.get (), "two", "two");
		assert (map_iterator.get_key () == "two");
		assert (map_iterator.get_value () == "two");

		assert (keys_iterator.has_previous ());
		assert (entries_iterator.has_previous ());
		assert (map_iterator.has_previous ());

		assert (!keys_iterator.next ());
		assert (!entries_iterator.next ());
		assert (!map_iterator.next ());

		assert (keys_iterator.previous ());
		assert (entries_iterator.previous ());
		assert (map_iterator.previous ());

		assert (keys_iterator.get () == "three");
		assert_entry (entries_iterator.get (), "three", "three");
		assert (map_iterator.get_key () == "three");
		assert (map_iterator.get_value () == "three");

		assert (keys_iterator.previous ());
		assert (entries_iterator.previous ());
		assert (map_iterator.previous ());

		assert (keys_iterator.get () == "six");
		assert_entry (entries_iterator.get (), "six", "six");
		assert (map_iterator.get_key () == "six");
		assert (map_iterator.get_value () == "six");

		assert (keys_iterator.previous ());
		assert (entries_iterator.previous ());
		assert (map_iterator.previous ());

		assert (keys_iterator.get () == "one");
		assert_entry (entries_iterator.get (), "one", "one");
		assert (map_iterator.get_key () == "one");
		assert (map_iterator.get_value () == "one");

		assert (keys_iterator.previous ());
		assert (entries_iterator.previous ());
		assert (map_iterator.previous ());

		assert (keys_iterator.get () == "four");
		assert_entry (entries_iterator.get (), "four", "four");
		assert (map_iterator.get_key () == "four");
		assert (map_iterator.get_value () == "four");

		assert (keys_iterator.previous ());
		assert (entries_iterator.previous ());
		assert (map_iterator.previous ());

		assert (keys_iterator.get () == "five");
		assert_entry (entries_iterator.get (), "five", "five");
		assert (map_iterator.get_key () == "five");
		assert (map_iterator.get_value () == "five");

		assert (!keys_iterator.previous ());
		assert (!entries_iterator.previous ());
		assert (!map_iterator.previous ());

		assert (keys_iterator.get () == "five");
		assert_entry (entries_iterator.get (), "five", "five");
		assert (map_iterator.get_key () == "five");
		assert (map_iterator.get_value () == "five");
	}

	public void test_bidir_iterator_last () {
		var test_sorted_map = test_map as BidirSortedMap<string,string>;
		var keys = (test_sorted_map.ascending_keys) as BidirSortedSet<string>;
		var entries = (test_sorted_map.ascending_entries) as BidirSortedSet<Map.Entry<string,string>>;

		var keys_iterator = keys.bidir_iterator ();
		var entries_iterator = entries.bidir_iterator ();

		assert (!keys_iterator.last ());
		assert (!entries_iterator.last ());

		test_sorted_map.set ("one", "one");
		test_sorted_map.set ("two", "two");
		test_sorted_map.set ("three", "three");
		test_sorted_map.set ("four", "four");
		test_sorted_map.set ("five", "five");
		test_sorted_map.set ("six", "six");

		keys_iterator = keys.bidir_iterator ();
		entries_iterator = entries.bidir_iterator ();

		assert (keys_iterator.last ());
		assert (entries_iterator.last ());

		assert (keys_iterator.get () == "two");
		assert_entry (entries_iterator.get (), "two", "two");
	}


	public class BidirSubMapTests : Gee.TestCase {
		private BidirSortedMap<string,string> master;
		private BidirSortedMap<string,string> submap;
		private BidirSortedMapTests test;
		private SortedMapTests.SubMapTests.Type type;

		public BidirSubMapTests (BidirSortedMapTests test, SortedMapTests.SubMapTests.Type type) {
			base ("%s Subset".printf (type.to_string ()));
			this.test = test;
			this.type = type;
			add_test ("[BidirSortedSet] bi-directional iterator", test_bidir_iterators);
		}

		public override void set_up () {
			test.set_up ();
			master = test.test_map as BidirSortedMap<string,string>;
			switch (type) {
			case SortedMapTests.SubMapTests.Type.HEAD:
				submap = master.head_map ("one") as BidirSortedMap<string,string>; break;
			case SortedMapTests.SubMapTests.Type.TAIL:
				submap = master.tail_map ("six") as BidirSortedMap<string,string>; break;
			case SortedMapTests.SubMapTests.Type.SUB:
				submap = master.sub_map ("four", "three") as BidirSortedMap<string,string>; break;
			case SortedMapTests.SubMapTests.Type.EMPTY:
				submap = master.sub_map ("three", "four") as BidirSortedMap<string,string>; break;
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
			case SortedMapTests.SubMapTests.Type.HEAD:
				contains = {"five", "four"};
				not_contains = {"one", "two", "three", "six"};
				break;
			case SortedMapTests.SubMapTests.Type.TAIL:
				contains = {"six", "three", "two"};
				not_contains = {"one", "four", "five"};
				break;
			case SortedMapTests.SubMapTests.Type.SUB:
				contains = {"four", "one", "six"};
				not_contains = {"two", "three", "five"};
				break;
			case SortedMapTests.SubMapTests.Type.EMPTY:
				contains = {};
				not_contains = {"one", "two", "three", "four", "five", "six"};
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_bidir_iterators () {
			string[] contains, not_contains;

			var _map_iter = submap.bidir_map_iterator ();

			assert (!_map_iter.has_next ());
			assert (!_map_iter.next ());
			assert (!_map_iter.has_previous ());
			assert (!_map_iter.previous ());
			
			set_default_values (out contains, out not_contains);
			
			var i = 0;
			_map_iter = submap.bidir_map_iterator ();
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
			
			var keys_iter = ((BidirSortedSet<string>) submap.ascending_keys).bidir_iterator ();
			var entries_iter = ((BidirSortedSet<Map.Entry<string,string>>) submap.ascending_entries).bidir_iterator ();
			var map_iter = submap.bidir_map_iterator ();
			if (type != SortedMapTests.SubMapTests.Type.EMPTY) {
				assert (map_iter.last ());
				assert (map_iter.get_key () == contains[contains.length - 1]);
				assert (map_iter.get_value () == contains[contains.length - 1]);

				map_iter = submap.bidir_map_iterator ();
				assert (map_iter.next ());

				assert (map_iter.get_key () == contains[0]);
				assert (map_iter.get_value () == contains[0]);

				assert (map_iter.has_next ());
				assert (map_iter.next ());
				assert (map_iter.get_key () == contains[1]);
				assert (map_iter.get_value () == contains[1]);

				assert (map_iter.has_previous ());
				map_iter.unset ();
				assert (map_iter.has_previous ());
				if (type != SortedMapTests.SubMapTests.Type.HEAD)
					assert (map_iter.has_next ());
				else
					assert (!map_iter.has_next ());
				assert (map_iter.previous ());
				assert (map_iter.get_key () == contains[0]);
				assert (map_iter.get_value () == contains[0]);
				
				// Repeat for keys
				master.clear ();
				set_default_values (out contains, out not_contains);
				
				assert (keys_iter.last ());
				assert (keys_iter.get () == contains[contains.length - 1]);
				assert (keys_iter.first ());

				assert (keys_iter.get () == contains[0]);
				assert (keys_iter.has_next ());
				assert (keys_iter.next ());
				assert (keys_iter.get () == contains[1]);
				assert (keys_iter.has_previous ());
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					keys_iter.remove ();
					Posix.exit (0);
				}
				assert (keys_iter.has_previous ());
				if (type != SortedMapTests.SubMapTests.Type.HEAD)
					assert (keys_iter.has_next ());
				else
					assert (!keys_iter.has_next ());
				assert (keys_iter.previous ());
				assert (keys_iter.get () == contains[0]);
				
				// Repeat for entries
				master.clear ();
				set_default_values (out contains, out not_contains);

				assert (entries_iter.last ());
				MapTests.assert_entry (entries_iter.get (), contains[contains.length - 1], contains[contains.length - 1]);
				assert (entries_iter.first ());

				MapTests.assert_entry (entries_iter.get (), contains[0], contains[0]);
				assert (entries_iter.has_next ());
				assert (entries_iter.next ());
				MapTests.assert_entry (entries_iter.get (), contains[1], contains[1]);
				assert (entries_iter.has_previous ());
				entries_iter.remove ();
				assert (entries_iter.has_previous ());
				if (type != SortedMapTests.SubMapTests.Type.HEAD)
					assert (entries_iter.has_next ());
				else
					assert (!entries_iter.has_next ());
				assert (entries_iter.previous ());
				MapTests.assert_entry (entries_iter.get (), contains[0], contains[0]);
			} else {
				assert (!keys_iter.first ());
				assert (!keys_iter.last ());
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					keys_iter.remove ();
					Posix.exit (0);
				}
				Test.trap_assert_failed ();
				assert (!entries_iter.first ());
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					entries_iter.remove ();
					Posix.exit (0);
				}
				Test.trap_assert_failed ();
			}
		}
	}
}

