/* testreadonlylist.vala
 *
 * Copyright (C) 2008  Jürg Billeter
 * Copyright (C) 2009  Didier Villevalois
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
 * 	Tomaž Vajngerl <quikee@gmail.com>
 * 	Julien Peeters <contact@julienpeeters.fr>
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 */

using Gee;

public class ReadOnlyListTests : ReadOnlyCollectionTests {

	public ReadOnlyListTests () {
		this.with_name ("ReadOnlyList");
	}

	public ReadOnlyListTests.with_name (string name) {
		base.with_name (name);
		add_test ("[ReadOnlyList] immutable iterator", test_immutable_iterator);
		add_test ("[ReadOnlyList] immutable", test_immutable);
		add_test ("[ReadOnlyList] accurate view", test_accurate_view);
	}

	public override void set_up () {
		test_collection = new ArrayList<string> ();
		ro_collection = get_ro_view (test_collection);
	}

	public override void tear_down () {
		test_collection = null;
		ro_collection = null;
	}

	protected override Collection<string> get_ro_view (Collection<string> collection) {
		return ((Gee.List<string>) collection).read_only_view;
	}

	public new void test_immutable_iterator () {
		var test_list = test_collection as Gee.List<string>;
		var ro_list = ro_collection as Gee.List<string>;

		assert (test_list.add ("one"));
		assert (test_list.add ("two"));

		assert (ro_list.size == 2);
		assert (ro_list.get (0) == "one");
		assert (ro_list.get (1) == "two");

		ListIterator<string> iterator = ro_list.list_iterator ();

		assert (iterator.has_next ());
		assert (iterator.next ());
		assert (iterator.get () == "one");
		assert (iterator.index () == 0);

		assert (iterator.has_next ());
		assert (iterator.next ());
		assert (iterator.get () == "two");
		assert (iterator.index () == 1);

		assert (! iterator.has_next ());
		assert (! iterator.next ());

		iterator = ro_list.list_iterator ();
		assert (iterator.next ());

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			iterator.remove ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_list.size == 2);
		assert (ro_list.get (0) == "one");
		assert (ro_list.get (1) == "two");
		assert (iterator.index () == 0);

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			iterator.set ("three");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_list.size == 2);
		assert (ro_list.get (0) == "one");
		assert (ro_list.get (1) == "two");
		assert (iterator.index () == 0);

		assert (ro_list.size == 2);
		assert (ro_list.get (0) == "one");
		assert (ro_list.get (1) == "two");
		assert (iterator.index () == 0);

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			iterator.add ("three");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_list.size == 2);
		assert (ro_list.get (0) == "one");
		assert (ro_list.get (1) == "two");
		assert (iterator.index () == 0);
	}

	public new void test_immutable () {
		var test_list = test_collection as Gee.List<string>;
		var ro_list = ro_collection as Gee.List<string>;

		assert (test_list.add ("one"));
		assert (ro_list.size == 1);
		assert (ro_list.contains ("one"));

		Collection<string> dummy = new ArrayList<string> ();
		assert (dummy.add ("one"));
		assert (dummy.add ("two"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_list.set (0, "two");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_list.size == 1);
		assert (ro_list.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_list.insert (1, "two");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_list.size == 1);
		assert (ro_list.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_list.remove_at (1);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_list.size == 1);
		assert (ro_list.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_list.insert_all (1, dummy);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_list.size == 1);
		assert (ro_list.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_list.sort ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_list.size == 1);
		assert (ro_list.contains ("one"));
	}

	public new void test_accurate_view () {
		var test_list = test_collection as Gee.List<string>;
		var ro_list = ro_collection as Gee.List<string>;

		Collection<string> dummy = new ArrayList<string> ();
		assert (dummy.add ("one"));
		assert (dummy.add ("two"));

		assert (ro_list.element_type == typeof (string));

		assert (ro_list.size == 0);
		assert (ro_list.is_empty);
		assert (! ro_list.contains ("one"));
		assert (ro_list.index_of ("one") == -1);

		assert (test_list.add ("one"));
		assert (ro_list.size == 1);
		assert (! ro_list.is_empty);
		assert (ro_list.get (0) == "one");
		assert (ro_list.index_of ("one") == 0);
		assert (ro_list.first () == "one");
		assert (ro_list.last () == "one");

		assert (test_list.add ("two"));
		assert (ro_list.size == 2);
		assert (! ro_list.is_empty);
		assert (ro_list.get (0) == "one");
		assert (ro_list.index_of ("one") == 0);
		assert (ro_list.get (1) == "two");
		assert (ro_list.index_of ("two") == 1);
		assert (ro_list.first () == "one");
		assert (ro_list.last () == "two");

		assert (test_list.remove ("one"));
		assert (ro_list.size == 1);
		assert (! ro_list.is_empty);
		assert (! ro_list.contains ("one"));
		assert (ro_list.index_of ("one") == -1);
		assert (ro_list.contains ("two"));
		assert (ro_list.get (0) == "two");
		assert (ro_list.index_of ("two") == 0);
		assert (ro_list.first () == "two");
		assert (ro_list.last () == "two");

		test_list.clear ();
		assert (ro_list.size == 0);
		assert (ro_list.is_empty);
		assert (ro_list.index_of ("one") == -1);
		assert (ro_list.index_of ("two") == -1);
	}
}
