/* testbidirsortedset.vala
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

public abstract class BidirSortedSetTests : SortedSetTests {
	protected BidirSortedSetTests(string name) {
		base (name);
		add_test ("[SortedSet] bi-directional iterators can go backward",
		          test_bidir_iterator_can_go_backward);
		add_test ("[SortedSet] bi-directional iterators are mutable",
		          test_mutable_bidir_iterator);
		add_test ("[SortedSet] bi-directional iterators can to beginning",
		          test_bidir_iterator_first);
		add_test ("[SortedSet] bi-directional iterators can to end",
		          test_bidir_iterator_last);
		get_suite ().add_suite (new BidirSubSetTests (this, SortedSetTests.SubSetTests.Type.HEAD).get_suite ());
		get_suite ().add_suite (new BidirSubSetTests (this, SortedSetTests.SubSetTests.Type.TAIL).get_suite ());
		get_suite ().add_suite (new BidirSubSetTests (this, SortedSetTests.SubSetTests.Type.SUB).get_suite ());
		get_suite ().add_suite (new BidirSubSetTests (this, SortedSetTests.SubSetTests.Type.EMPTY).get_suite ());
	}

	public void test_bidir_iterator_can_go_backward () {
		var test_set = test_collection as BidirSortedSet<string>;

		var iterator = test_set.bidir_iterator ();
		assert (!iterator.has_previous ());

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		iterator = test_set.bidir_iterator ();
		assert (iterator.next ());
		assert (iterator.get () == "five");
		assert (!iterator.has_previous ());
		assert (iterator.next ());
		assert (iterator.get () == "four");
		assert (iterator.has_previous ());
		assert (iterator.next ());
		assert (iterator.get () == "one");
		assert (iterator.has_previous ());
		assert (iterator.next ());
		assert (iterator.get () == "six");
		assert (iterator.has_previous ());
		assert (iterator.next ());
		assert (iterator.get () == "three");
		assert (iterator.has_previous ());
		assert (iterator.next ());
		assert (iterator.get () == "two");
		assert (iterator.has_previous ());
		assert (!iterator.next ());
		assert (iterator.previous ());
		assert (iterator.get () == "three");
		assert (iterator.previous ());
		assert (iterator.get () == "six");
		assert (iterator.previous ());
		assert (iterator.get () == "one");
		assert (iterator.previous ());
		assert (iterator.get () == "four");
		assert (iterator.previous ());
		assert (iterator.get () == "five");
		assert (!iterator.previous ());
		assert (iterator.get () == "five");
	}

	public void test_bidir_iterator_first () {
		var test_set = test_collection as BidirSortedSet<string>;

		var iterator = test_set.bidir_iterator ();

		assert (!iterator.first ());

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		iterator = test_set.bidir_iterator ();
		assert (iterator.last ());
		assert (iterator.get () == "two");
		assert (iterator.first ());
		assert (iterator.get () == "five");
	}

	public void test_bidir_iterator_last () {
		var test_set = test_collection as BidirSortedSet<string>;

		var iterator = test_set.bidir_iterator ();

		assert (!iterator.last ());

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		iterator = test_set.bidir_iterator ();
		assert (iterator.last ());
		assert (iterator.get () == "two");
	}

	public void test_mutable_bidir_iterator () {
		var test_set = test_collection as BidirSortedSet<string>;

		var iterator = test_set.bidir_iterator ();
		assert (!iterator.has_previous ());

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		iterator = test_set.bidir_iterator ();

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			iterator.remove ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		assert (iterator.next ());
		assert (iterator.get () == "five");
		iterator.remove ();
		assert (!test_set.contains ("five"));
		assert (iterator.has_next ());
		assert (!iterator.has_previous ());
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			iterator.get ();
			Posix.exit (0);
		}
		assert (!iterator.previous ());

		assert (iterator.next ());
		assert (iterator.get () == "four");
		assert (iterator.next ());
		assert (iterator.get () == "one");
		iterator.remove ();
		assert (!test_set.contains ("one"));
		assert (iterator.has_next ());
		assert (iterator.has_previous ());
		assert (iterator.previous ());
		assert (iterator.get () == "four");
	}

	public class BidirSubSetTests : Gee.TestCase {
		private BidirSortedSet<string> master;
		private BidirSortedSet<string> subset;
		private BidirSortedSetTests test;
		private SortedSetTests.SubSetTests.Type type;

		public BidirSubSetTests(BidirSortedSetTests test, SortedSetTests.SubSetTests.Type type) {
			base ("%s Subset".printf (type.to_string ()));
			this.test = test;
			this.type = type;
			add_test ("[BidirSortedSet] bi-directional iterator", test_bidir_iterator);
		}

		public override void set_up () {
			test.set_up ();
			master = test.test_collection as BidirSortedSet<string>;
			switch (type) {
			case SortedSetTests.SubSetTests.Type.HEAD:
				subset = master.head_set ("one") as BidirSortedSet<string>; break;
			case SortedSetTests.SubSetTests.Type.TAIL:
				subset = master.tail_set ("six") as BidirSortedSet<string>; break;
			case SortedSetTests.SubSetTests.Type.SUB:
				subset = master.sub_set ("four", "three") as BidirSortedSet<string>; break;
			case SortedSetTests.SubSetTests.Type.EMPTY:
				subset = master.sub_set ("three", "four") as BidirSortedSet<string>; break;
			default:
				assert_not_reached ();
			}
		}

		public override void tear_down () {
			test.tear_down ();
		}

		public void test_bidir_iterator () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			string[] contains;
			switch (type) {
			case SortedSetTests.SubSetTests.Type.HEAD:
				contains = {"five", "four"};
				break;
			case SortedSetTests.SubSetTests.Type.TAIL:
				contains = {"six", "three", "two"};
				break;
			case SortedSetTests.SubSetTests.Type.SUB:
				contains = {"four", "one", "six"};
				break;
			case SortedSetTests.SubSetTests.Type.EMPTY:
				contains = {};
				break;
			default:
				assert_not_reached ();
			}

			uint i = 0;
			foreach (var e in subset) {
				assert (e == contains[i++]);
			}
			assert (i == contains.length);


			var iter = subset.bidir_iterator ();
			if (type != SortedSetTests.SubSetTests.Type.EMPTY) {
				assert (iter.last ());
				assert (iter.get () == contains[contains.length - 1]);
				assert (iter.first ());

				assert (iter.get () == contains[0]);
				assert (iter.has_next ());
				assert (iter.next ());
				assert (iter.get () == contains[1]);
				assert (iter.has_previous ());
				iter.remove ();
				assert (iter.has_previous ());
				if (type != SortedSetTests.SubSetTests.Type.HEAD)
					assert (iter.has_next ());
				else
					assert (!iter.has_next ());
				assert (iter.previous ());
				assert (iter.get () == contains[0]);
			} else {
				assert (!iter.first ());
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					iter.remove ();
					Posix.exit (0);
				}
				Test.trap_assert_failed ();
			}
		}
	}
}

