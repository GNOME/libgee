/* testsortedset.vala
 *
 * Copyright (C) 2009  Maciej Piechotka
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

public abstract class SortedSetTests : SetTests {
	protected SortedSetTests (string name, bool strict = true) {
		base (name);
		this.strict = strict;
		add_test ("[SortedSet] first", test_first);
		add_test ("[SortedSet] last", test_last);
		add_test ("[SortedSet] ordering", test_ordering);
		add_test ("[SortedSet] iterator at", test_iterator_at);
		add_test ("[SortedSet] lower", test_lower);
		add_test ("[SortedSet] higher", test_higher);
		add_test ("[SortedSet] floor", test_floor);
		add_test ("[SortedSet] ceil", test_ceil);
		get_suite ().add_suite (new SubSetTests (this, SubSetTests.Type.HEAD, strict).get_suite ());
		get_suite ().add_suite (new SubSetTests (this, SubSetTests.Type.TAIL, strict).get_suite ());
		get_suite ().add_suite (new SubSetTests (this, SubSetTests.Type.SUB, strict).get_suite ());
		get_suite ().add_suite (new SubSetTests (this, SubSetTests.Type.EMPTY, strict).get_suite ());
	}

	public void test_ordering () {
		var test_set = test_collection as SortedSet<string>;

		// Check the set exists
		assert (test_set != null);

		test_set.add ("one");
		test_set.add ("two");
		test_set.add ("three");
		test_set.add ("four");
		test_set.add ("five");
		test_set.add ("six");
		test_set.add ("seven");
		test_set.add ("eight");
		test_set.add ("nine");
		test_set.add ("ten");
		test_set.add ("eleven");
		test_set.add ("twelve");

		Iterator<string> iterator = test_set.iterator ();
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
		var test_set = test_collection as SortedSet<string>;

		if (strict) {
			if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
			                       TestTrapFlags.SILENCE_STDERR)) {
				test_set.first ();
				Posix.exit (0);
			}
			Test.trap_assert_failed ();
		}

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		assert (test_set.first () == "five");
	}

	public void test_last () {
		var test_set = test_collection as SortedSet<string>;

		if (strict) {
			if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
			                       TestTrapFlags.SILENCE_STDERR)) {
				test_set.last ();
				Posix.exit (0);
			}
			Test.trap_assert_failed ();
		}

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		assert (test_set.last () == "two");
	}

	public void test_iterator_at () {
		var test_set = test_collection as SortedSet<string>;

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));

		var iter = test_set.iterator_at ("one");
		assert (iter != null);
		assert (iter.get () == "one");

		iter = test_set.iterator_at ("two");
		assert (iter != null);
		assert (iter.get () == "two");

		iter = test_set.iterator_at ("three");
		assert (iter != null);
		assert (iter.get () == "three");

		iter = test_set.iterator_at ("zero");
		assert (iter == null);
	}

	public void test_lower () {
		var test_set = test_collection as SortedSet<string>;

		assert (test_set.lower ("one") == null);

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		assert (test_set.lower ("one") == "four");
		assert (test_set.lower ("o") == "four");
		assert (test_set.lower ("two") == "three");
		assert (test_set.lower ("t") == "six");
		assert (test_set.lower ("three") == "six");
		assert (test_set.lower ("four") == "five");
		assert (test_set.lower ("f") == null);
		assert (test_set.lower ("five") == null);
		assert (test_set.lower ("six") == "one");
		assert (test_set.lower ("s") == "one");
	}

	public void test_higher () {
		var test_set = test_collection as SortedSet<string>;

		assert (test_set.higher ("one") == null);

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		assert (test_set.higher ("one") == "six");
		assert (test_set.higher ("o") == "one");
		assert (test_set.higher ("two") == null);
		assert (test_set.higher ("t") == "three");
		assert (test_set.higher ("three") == "two");
		assert (test_set.higher ("four") == "one");
		assert (test_set.higher ("f") == "five");
		assert (test_set.higher ("five") == "four");
		assert (test_set.higher ("six") == "three");
		assert (test_set.higher ("s") == "six");
	}

	public void test_floor () {
		var test_set = test_collection as SortedSet<string>;

		assert (test_set.floor ("one") == null);

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		assert (test_set.floor ("one") == "one");
		assert (test_set.floor ("o") == "four");
		assert (test_set.floor ("two") == "two");
		assert (test_set.floor ("t") == "six");
		assert (test_set.floor ("three") == "three");
		assert (test_set.floor ("four") == "four");
		assert (test_set.floor ("f") == null);
		assert (test_set.floor ("five") == "five");
		assert (test_set.floor ("six") == "six");
		assert (test_set.floor ("s") == "one");
	}

	public void test_ceil () {
		var test_set = test_collection as SortedSet<string>;

		assert (test_set.ceil ("one") == null);

		assert (test_set.add ("one"));
		assert (test_set.add ("two"));
		assert (test_set.add ("three"));
		assert (test_set.add ("four"));
		assert (test_set.add ("five"));
		assert (test_set.add ("six"));

		assert (test_set.ceil ("one") == "one");
		assert (test_set.ceil ("o") == "one");
		assert (test_set.ceil ("two") == "two");
		assert (test_set.ceil ("t") == "three");
		assert (test_set.ceil ("three") == "three");
		assert (test_set.ceil ("four") == "four");
		assert (test_set.ceil ("f") == "five");
		assert (test_set.ceil ("five") == "five");
		assert (test_set.ceil ("six") == "six");
		assert (test_set.ceil ("s") == "six");
	}

	protected class SubSetTests : Gee.TestCase {
		private SortedSet<string> master;
		private SortedSet<string> subset;
		private SortedSetTests test;
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

		public SubSetTests (SortedSetTests test, Type type, bool strict) {
			base ("%s Subset".printf (type.to_string ()));
			this.test = test;
			this.type = type;
			this.strict = strict;
			add_test ("[Collection] size", test_size);
			add_test ("[Collection] contains", test_contains);
			add_test ("[Collection] add", test_add);
			add_test ("[Collection] remove", test_remove);
			add_test ("[Collection] iterator", test_iterator);
			add_test ("[Collection] clear", test_clear);
			add_test ("[SortedSet] iterator at", test_iterator_at);
			add_test ("[SortedSet] lower", test_lower);
			add_test ("[SortedSet] higher", test_higher);
			add_test ("[SortedSet] ceil", test_ceil);
			add_test ("[SortedSet] floor", test_floor);
			add_test ("[SortedSet] subsets", test_subsets);
			add_test ("[SortedSet] boundaries", test_boundaries);
		}

		public override void set_up () {
			test.set_up ();
			master = test.test_collection as SortedSet<string>;
			switch (type) {
			case Type.HEAD:
				subset = master.head_set ("one"); break;
			case Type.TAIL:
				subset = master.tail_set ("six"); break;
			case Type.SUB:
				subset = master.sub_set ("four", "three"); break;
			case Type.EMPTY:
				subset = master.sub_set ("three", "four"); break;
			default:
				assert_not_reached ();
			}
		}

		public override void tear_down () {
			test.tear_down ();
		}

		public void test_size () {
			assert (subset.is_empty);
			assert (subset.size == 0);

			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			switch (type) {
			case Type.HEAD:
				assert (!subset.is_empty);
				assert (subset.size == 2);
				break;
			case Type.TAIL:
				assert (!subset.is_empty);
				assert (subset.size == 3);
				break;
			case Type.SUB:
				assert (!subset.is_empty);
				assert (subset.size == 3);
				break;
			case Type.EMPTY:
				assert (subset.is_empty);
				assert (subset.size == 0);
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_contains () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			string[] contains, not_contains;
			switch (type) {
			case Type.HEAD:
				contains = {"four", "five"};
				not_contains = {"one", "two", "three", "six"};
				break;
			case Type.TAIL:
				contains = {"two", "three", "six"};
				not_contains = {"one", "four", "five"};
				break;
			case Type.SUB:
				contains = {"one", "four", "six"};
				not_contains = {"two", "three", "five"};
				break;
			case Type.EMPTY:
				contains = {};
				not_contains = {"one", "two", "three", "four", "five", "six"};
				break;
			default:
				assert_not_reached ();
			}

			foreach (var s in contains)
				assert (subset.contains (s));
			foreach (var s in not_contains)
				assert (!subset.contains (s));
		}

		public void test_add () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

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
				assert (subset.add (s));
				assert (subset.contains (s));
				assert (master.contains (s));
			}

			foreach (var s in fail) {
				assert (!subset.add (s));
				assert (!subset.contains (s));
				assert (!master.contains (s));
			}

			assert (master.size == 6 + success.length);
		}

		public void test_remove () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			string[] contains, not_contains;
			switch (type) {
			case Type.HEAD:
				contains = {"four", "five"};
				not_contains = {"one", "two", "three", "six"};
				break;
			case Type.TAIL:
				contains = {"two", "three", "six"};
				not_contains = {"one", "four", "five"};
				break;
			case Type.SUB:
				contains = {"one", "four", "six"};
				not_contains = {"two", "three", "five"};
				break;
			case Type.EMPTY:
				contains = {};
				not_contains = {"one", "two", "three", "four", "five", "six"};
				break;
			default:
				assert_not_reached ();
			}

			foreach (var s in contains) {
				assert (subset.remove (s));
				assert (!master.contains (s));
			}
			foreach (var s in not_contains) {
				assert (!subset.remove (s));
				assert (master.contains (s));
			}

			assert (master.size == 6 - contains.length);
		}

		public void test_iterator () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			string[] contains;
			switch (type) {
			case Type.HEAD:
				contains = {"five", "four"};
				break;
			case Type.TAIL:
				contains = {"six", "three", "two"};
				break;
			case Type.SUB:
				contains = {"four", "one", "six"};
				break;
			case Type.EMPTY:
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


			var iter = subset.iterator ();
			if (type != Type.EMPTY) {
				assert (iter.has_next ());
				assert (iter.next ());
				assert (iter.get () == contains[0]);
				assert (iter.has_next ());
				assert (iter.next ());
				assert (iter.get () == contains[1]);
			} else {
				if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
				                       TestTrapFlags.SILENCE_STDERR)) {
					iter.remove ();
					Posix.exit (0);
				}
				Test.trap_assert_failed ();
			}
		}

		public void test_clear () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			string[] contains, not_contains;
			switch (type) {
			case Type.HEAD:
				contains = {"four", "five"};
				not_contains = {"one", "two", "three", "six"};
				break;
			case Type.TAIL:
				contains = {"two", "three", "six"};
				not_contains = {"one", "four", "five"};
				break;
			case Type.SUB:
				contains = {"one", "four", "six"};
				not_contains = {"two", "three", "five"};
				break;
			case Type.EMPTY:
				contains = {};
				not_contains = {"one", "two", "three", "four", "five", "six"};
				break;
			default:
				assert_not_reached ();
			}

			subset.clear ();
			foreach (var s in contains)
				assert (!master.contains (s));
			foreach (var s in not_contains)
				assert (master.contains (s));
		}

		public void test_boundaries () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			switch (type) {
			case Type.HEAD:
				assert (subset.first () == "five");
				assert (subset.last () == "four");
				break;
			case Type.TAIL:
				assert (subset.first () == "six");
				assert (subset.last () == "two");
				break;
			case Type.SUB:
				assert (subset.first () == "four");
				assert (subset.last () == "six");
				break;
			case Type.EMPTY:
				if (strict) {
					if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
					                       TestTrapFlags.SILENCE_STDERR)) {
						subset.first ();
						Posix.exit (0);
					}
					Test.trap_assert_failed ();
					if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
					                       TestTrapFlags.SILENCE_STDERR)) {
						subset.last ();
						Posix.exit (0);
					}
					Test.trap_assert_failed ();
				}
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_iterator_at () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			string[] contains, not_contains;
			switch (type) {
			case Type.HEAD:
				contains = {"four", "five"};
				not_contains = {"one", "two", "three", "six"};
				break;
			case Type.TAIL:
				contains = {"two", "three", "six"};
				not_contains = {"one", "four", "five"};
				break;
			case Type.SUB:
				contains = {"one", "four", "six"};
				not_contains = {"two", "three", "five"};
				break;
			case Type.EMPTY:
				contains = {};
				not_contains = {"one", "two", "three", "four", "five", "six"};
				break;
			default:
				assert_not_reached ();
			}

			foreach (var s in contains) {
				var iter = subset.iterator_at (s);
				assert (iter != null);
				assert (iter.get () == s);
			}
			foreach (var s in not_contains) {
				var iter = subset.iterator_at (s);
				assert (iter == null);
			}
		}

		public void test_lower () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			switch (type) {
			case Type.HEAD:
				assert (subset.lower ("a") == null);
				assert (subset.lower ("five") == null);
				assert (subset.lower ("four") == "five");
				assert (subset.lower ("six") == "four");
				break;
			case Type.TAIL:
				assert (subset.lower ("one") == null);
				assert (subset.lower ("six") == null);
				assert (subset.lower ("three") == "six");
				assert (subset.lower ("two") == "three");
				assert (subset.lower ("z") == "two");
				break;
			case Type.SUB:
				assert (subset.lower ("five") == null);
				assert (subset.lower ("four") == null);
				assert (subset.lower ("one") == "four");
				assert (subset.lower ("six") == "one");
				assert (subset.lower ("three") == "six");
				break;
			case Type.EMPTY:
				assert (subset.lower ("six") == null);
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_higher () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			switch (type) {
			case Type.HEAD:
				assert (subset.higher ("a") == "five");
				assert (subset.higher ("five") == "four");
				assert (subset.higher ("four") == null);
				assert (subset.higher ("six") == null);
				break;
			case Type.TAIL:
				assert (subset.higher ("one") == "six");
				assert (subset.higher ("six") == "three");
				assert (subset.higher ("three") == "two");
				assert (subset.higher ("two") == null);
				assert (subset.higher ("z") == null);
				break;
			case Type.SUB:
				assert (subset.higher ("five") == "four");
				assert (subset.higher ("four") == "one");
				assert (subset.higher ("one") == "six");
				assert (subset.higher ("six") == null);
				assert (subset.higher ("three") == null);
				break;
			case Type.EMPTY:
				assert (subset.higher ("six") == null);
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_floor () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			switch (type) {
			case Type.HEAD:
				assert (subset.floor ("a") == null);
				assert (subset.floor ("five") == "five");
				assert (subset.floor ("four") == "four");
				assert (subset.floor ("six") == "four");
				break;
			case Type.TAIL:
				assert (subset.floor ("one") == null);
				assert (subset.floor ("six") == "six");
				assert (subset.floor ("three") == "three");
				assert (subset.floor ("two") == "two");
				assert (subset.floor ("z") == "two");
				break;
			case Type.SUB:
				assert (subset.floor ("five") == null);
				assert (subset.floor ("four") == "four");
				assert (subset.floor ("one") == "one");
				assert (subset.floor ("six") == "six");
				assert (subset.floor ("three") == "six");
				break;
			case Type.EMPTY:
				assert (subset.floor ("six") == null);
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_ceil () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			switch (type) {
			case Type.HEAD:
				assert (subset.ceil ("a") == "five");
				assert (subset.ceil ("five") == "five");
				assert (subset.ceil ("four") == "four");
				assert (subset.ceil ("six") == null);
				break;
			case Type.TAIL:
				assert (subset.ceil ("one") == "six");
				assert (subset.ceil ("six") == "six");
				assert (subset.ceil ("three") == "three");
				assert (subset.ceil ("two") == "two");
				assert (subset.ceil ("z") == null);
				break;
			case Type.SUB:
				assert (subset.ceil ("five") == "four");
				assert (subset.ceil ("four") == "four");
				assert (subset.ceil ("one") == "one");
				assert (subset.ceil ("six") == "six");
				assert (subset.ceil ("three") == null);
				break;
			case Type.EMPTY:
				assert (subset.ceil ("six") == null);
				break;
			default:
				assert_not_reached ();
			}
		}

		public void test_subsets () {
			assert (master.add ("one"));
			assert (master.add ("two"));
			assert (master.add ("three"));
			assert (master.add ("four"));
			assert (master.add ("five"));
			assert (master.add ("six"));
			assert (master.size == 6);

			switch (type) {
			case Type.HEAD:
				var subsubset = subset.head_set ("four");
				assert (subsubset.size == 1);
				subsubset = subset.tail_set ("four");
				assert (subsubset.size == 1);
				subsubset = subset.sub_set ("four", "one");
				assert (subsubset.size == 1);
				subsubset = subset.sub_set ("four", "four");
				assert (subsubset.size == 0);
				break;
			case Type.TAIL:
				var subsubset = subset.head_set ("two");
				assert (subsubset.size == 2);
				subsubset = subset.tail_set ("three");
				assert (subsubset.size == 2);
				subsubset = subset.sub_set ("three", "two");
				assert (subsubset.size == 1);
				break;
			case Type.SUB:
				var subsubset = subset.head_set ("six");
				assert (subsubset.size == 2);
				subsubset = subset.tail_set ("one");
				assert (subsubset.size == 2);
				subsubset = subset.sub_set ("one", "six");
				assert (subsubset.size == 1);
				subsubset = subset.sub_set ("five", "two");
				assert (subsubset.size == 3);
				break;
			case Type.EMPTY:
				var subsubset = subset.head_set ("six");
				assert (subsubset.size == 0);
				subsubset = subset.tail_set ("three");
				assert (subsubset.size == 0);
				subsubset = subset.sub_set ("one", "six");
				assert (subsubset.size == 0);
				break;
			default:
				assert_not_reached ();
			}
		}

		private bool strict;
	}

	private bool strict;
}

