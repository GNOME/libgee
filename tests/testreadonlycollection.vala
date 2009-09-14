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

public abstract class ReadOnlyCollectionTests : Gee.TestCase {

	public ReadOnlyCollectionTests (string name) {
		base (name);
		add_test ("[ReadOnlyCollection] unique read-only view instance",
		          test_unique_read_only_view_instance);
		add_test ("[ReadOnlyCollection] add", test_add);
		add_test ("[ReadOnlyCollection] clear", test_clear);
		add_test ("[ReadOnlyCollection] remove", test_remove);
		add_test ("[ReadOnlyCollection] contains", test_contains);
		add_test ("[ReadOnlyCollection] size", test_size);
	}

	protected Collection<string> test_collection;
	protected Collection<string> ro_collection;

	public void test_unique_read_only_view_instance () {
		var another_ro_collection = test_collection.read_only_view;
		assert (ro_collection == another_ro_collection);

		ro_collection.set_data ("marker", new Object ());
		assert (another_ro_collection.get_data ("marker") != null);

		another_ro_collection = null;
		ro_collection = null;

		another_ro_collection = test_collection.read_only_view;
		assert (another_ro_collection.get_data ("marker") == null);
	}

	public void test_add () {
		assert (test_collection.add ("one"));

		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (ro_collection.add ("two"));
			return;
		}
		Test.trap_assert_failed ();

		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));
	}

	public void test_clear () {
		assert (test_collection.add ("one"));

		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			ro_collection.clear ();
			return;
		}
		Test.trap_assert_failed ();

		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));
	}

	public void test_contains () {
		assert (! ro_collection.contains ("one"));
		assert (test_collection.add ("one"));
		assert (ro_collection.contains ("one"));
		assert (test_collection.remove ("one"));
		assert (! ro_collection.contains ("one"));
	}

	public void test_remove () {
		assert (test_collection.add ("one"));

		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			assert (ro_collection.remove ("one"));
			return;
		}
		Test.trap_assert_failed ();

		assert (ro_collection.size == 1);
		assert (ro_collection.contains ("one"));
	}

	public void test_size () {
		assert (ro_collection.size == 0);
		assert (test_collection.add ("one"));
		assert (ro_collection.size == 1);
		assert (test_collection.add ("two"));
		assert (ro_collection.size == 2);
		test_collection.clear ();
		assert (ro_collection.size == 0);
	}
}
