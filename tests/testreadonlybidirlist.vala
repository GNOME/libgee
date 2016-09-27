/* testreadonlybidirlist.vala
 *
 * Copyright (C) 2011  Maciej Piechotka
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

using Gee;

public class ReadOnlyBidirListTests : ReadOnlyListTests {

	public ReadOnlyBidirListTests () {
		base.with_name ("ReadOnlyBidirList");
		add_test ("[ReadOnlyBidirList] immutable iterator", test_immutable_iterator);
	}

	protected override Collection<string> get_ro_view (Collection<string> collection) {
		return ((Gee.BidirList<string>) collection).read_only_view;
	}

	public new void test_immutable_iterator () {
		var test_list = test_collection as Gee.BidirList<string>;
		var ro_list = ro_collection as Gee.BidirList<string>;

		assert (test_list.add ("one"));
		assert (test_list.add ("two"));

		assert (ro_list.size == 2);
		assert (ro_list.get (0) == "one");
		assert (ro_list.get (1) == "two");

		Gee.BidirListIterator<string> iterator = ro_list.bidir_list_iterator ();

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

		assert (iterator.has_previous ());
		assert (iterator.previous ());
		assert (iterator.get () == "one");
		assert (iterator.index () == 0);

		assert (iterator.last ());
		assert (iterator.get () == "two");
		assert (iterator.index () == 1);

		assert (iterator.first ());
		assert (iterator.get () == "one");
		assert (iterator.index () == 0);

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

		if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT |
		                       TestTrapFlags.SILENCE_STDERR)) {
			iterator.insert ("three");
			Posix.exit (0);
		}
		Test.trap_assert_failed ();
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
}
