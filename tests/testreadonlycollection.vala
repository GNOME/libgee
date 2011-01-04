/* testreadonlycollection.vala
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
 */

using Gee;

public class ReadOnlyCollectionTests : Gee.TestCase {

	public ReadOnlyCollectionTests () {
		this.with_name ("ReadOnlyCollection");
	}

	public ReadOnlyCollectionTests.with_name (string name) {
		base (name);
		add_test ("[ReadOnlyCollection] unique read-only view instance",
		          test_unique_read_only_view_instance);
		add_test ("[ReadOnlyCollection] immutable iterator", test_immutable_iterator);
		add_test ("[ReadOnlyCollection] immutable", test_immutable);
		add_test ("[ReadOnlyCollection] accurate view", test_accurate_view);
	}

	protected Collection<string> test_collection;
	protected Collection<string> ro_collection;

	public override void set_up () {
		test_collection = new HashMultiSet<string> ();
		ro_collection = get_ro_view (test_collection);
	}

	public override void tear_down () {
		test_collection = null;
		ro_collection = null;
	}

	protected virtual Collection<string> get_ro_view (Collection<string> collection) {
		return collection.read_only_view;
	}

	public void test_unique_read_only_view_instance () {
		var another_ro_collection = get_ro_view (test_collection);
		assert (ro_collection == another_ro_collection);

		ro_collection.set_data ("marker", new Object ());
		assert (another_ro_collection.get_data<Object> ("marker") != null);

		another_ro_collection = null;
		ro_collection = null;

		another_ro_collection = get_ro_view (test_collection);
		assert (another_ro_collection.get_data<Object> ("marker") == null);

		// Check that the read-only view of the view is itself
		assert (another_ro_collection == get_ro_view (another_ro_collection));
	}

	public void test_immutable_iterator () {
		assert (test_collection.add ("one"));
		assert (test_collection.add ("two"));

		assert (ro_collection.size == 2);
		assert (ro_collection.contains ("one"));
		assert (ro_collection.contains ("two"));

		Iterator<string> iterator = ro_collection.iterator ();

		bool one_found = false;
		bool two_found = false;

		while (iterator.next ()) {
			assert (iterator.valid);
			switch(iterator.get ()) {
			case "one":
				assert (! one_found);
				one_found = true;
				break;
			case "two":
				assert (! two_found);
				two_found = true;
				break;
			default:
				assert_not_reached ();
			}
		}

		assert (one_found);
		assert (two_found);

		assert (! iterator.has_next ());
		assert (! iterator.next ());

		iterator = ro_collection.iterator ();
		assert (iterator.has_next ());
		assert (iterator.next ());

		assert (iterator.read_only);
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			iterator.remove ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();

		assert (ro_collection.size == 2);
		assert (ro_collection.contains ("one"));
		assert (ro_collection.contains ("two"));
	}

	public void test_immutable () {
		assert (test_collection.add ("one"));
		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));

		Collection<string> dummy = new ArrayList<string> ();
		assert (dummy.add ("one"));
		assert (dummy.add ("two"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (ro_collection.add ("two"));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_collection.clear ();
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (ro_collection.remove ("one"));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (ro_collection.add_all (dummy));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (ro_collection.remove_all (dummy));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));

		assert (dummy.remove ("one"));
		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (ro_collection.retain_all (dummy));
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));
	}

	public void test_accurate_view () {
		Collection<string> dummy = new ArrayList<string> ();
		assert (dummy.add ("one"));
		assert (dummy.add ("two"));

		assert (ro_collection.element_type == typeof (string));

		assert (ro_collection.size == 0);
		assert (ro_collection.is_empty);
		assert (! ro_collection.contains ("one"));

		assert (test_collection.add ("one"));
		assert (ro_collection.size == 1);
		assert (! ro_collection.is_empty);
		assert (ro_collection.contains ("one"));

		assert (test_collection.add ("two"));
		assert (ro_collection.size == 2);
		assert (! ro_collection.is_empty);
		assert (ro_collection.contains ("one"));
		assert (ro_collection.contains ("two"));
		assert (ro_collection.contains_all (dummy));

		assert (test_collection.remove ("one"));
		assert (ro_collection.size == 1);
		assert (! ro_collection.is_empty);
		assert (! ro_collection.contains ("one"));
		assert (ro_collection.contains ("two"));
		assert (! ro_collection.contains_all (dummy));

		test_collection.clear ();
		assert (ro_collection.size == 0);
		assert (ro_collection.is_empty);
		assert (! ro_collection.contains ("one"));
		assert (! ro_collection.contains ("two"));
	}
}
