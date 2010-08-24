/* testreadonlymap.vala
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
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 */

using Gee;

public class ReadOnlyMapTests : Gee.TestCase {

	public ReadOnlyMapTests () {
		base ("ReadOnlyMap");
		add_test ("[ReadOnlyMap] unique read-only view instance",
		          test_unique_read_only_view_instance);
		add_test ("[ReadOnlyMap] immutable iterator", test_immutable_iterator);
		add_test ("[ReadOnlyMap] immutable", test_immutable);
		add_test ("[ReadOnlyMap] accurate view", test_accurate_view);
	}

	protected Map<string,string> test_map;
	protected Map<string,string> ro_map;

	public override void set_up () {
		test_map = new TreeMap<string,string> ();
		ro_map = test_map.read_only_view;
	}

	public override void tear_down () {
		test_map = null;
		ro_map = null;
	}

	public void test_unique_read_only_view_instance () {
		var another_ro_map = test_map.read_only_view;
		assert (ro_map == another_ro_map);

		ro_map.set_data ("marker", new Object ());
		assert (another_ro_map.get_data<Object> ("marker") != null);

		another_ro_map = null;
		ro_map = null;

		another_ro_map = test_map.read_only_view;
		assert (another_ro_map.get_data<Object> ("marker") == null);

		// Check that the read-only view of the view is itself
		assert (another_ro_map == another_ro_map.read_only_view);
	}

	public void test_immutable_iterator () {
		test_map.set ("one", "one");
		test_map.set ("two", "two");

		assert (ro_map.size == 2);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));
		assert (ro_map.has_key ("two"));
		assert (ro_map.has ("two", "two"));

		Iterator<string> iterator = ro_map.keys.iterator ();

		assert (iterator.has_next ());
		assert (iterator.next ());
		assert (iterator.get () == "one");

		assert (iterator.has_next ());
		assert (iterator.next ());
		assert (iterator.get () == "two");

		assert (! iterator.has_next ());
		assert (! iterator.next ());

		iterator = ro_map.keys.iterator ();
		assert (iterator.has_next ());
		assert (iterator.next ());
		assert (iterator.get () == "one");

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			iterator.remove ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		assert (ro_map.size == 2);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));
		assert (ro_map.has_key ("two"));
		assert (ro_map.has ("two", "two"));
	}

	public void test_immutable () {
		test_map.set ("one", "one");
		assert (ro_map.size == 1);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));

		Map<string,string> dummy = new HashMap<string,string> ();
		dummy.set ("one", "one");
		dummy.set ("two", "two");

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_map.set ("two", "two");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_map.size == 1);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_map.clear ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_map.size == 1);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (ro_map.unset ("one"));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_map.size == 1);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_map.set_all (dummy);
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_map.size == 1);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (ro_map.unset_all (dummy));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_map.size == 1);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));
	}

	public void test_accurate_view () {
		Map<string,string> dummy = new HashMap<string,string> ();
		dummy.set ("one", "one");
		dummy.set ("two", "two");

		assert (ro_map.size == 0);
		assert (ro_map.is_empty);
		assert (! ro_map.has_key ("one"));
		assert (! ro_map.has ("one", "one"));
		assert (ro_map.get ("one") == null);

		test_map.set ("one", "one");
		assert (ro_map.size == 1);
		assert (! ro_map.is_empty);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));
		assert (ro_map.get ("one") == "one");

		test_map.set ("two", "two");
		assert (ro_map.size == 2);
		assert (! ro_map.is_empty);
		assert (ro_map.has_key ("one"));
		assert (ro_map.has ("one", "one"));
		assert (ro_map.get ("one") == "one");
		assert (ro_map.has_key ("two"));
		assert (ro_map.has ("two", "two"));
		assert (ro_map.get ("two") == "two");
		assert (ro_map.has_all (dummy));

		assert (test_map.unset ("one"));
		assert (ro_map.size == 1);
		assert (! ro_map.is_empty);
		assert (! ro_map.has_key ("one"));
		assert (! ro_map.has ("one", "one"));
		assert (ro_map.get ("one") == null);
		assert (ro_map.has_key ("two"));
		assert (ro_map.has ("two", "two"));
		assert (ro_map.get ("two") == "two");
		assert (! ro_map.has_all (dummy));

		test_map.clear ();
		assert (ro_map.size == 0);
		assert (ro_map.is_empty);
		assert (! ro_map.has ("one", "one"));
		assert (! ro_map.has ("two", "two"));
		assert (ro_map.get ("one") == null);
		assert (ro_map.get ("two") == null);
	}
}
