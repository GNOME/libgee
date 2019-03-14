/* testbidirlist.vala
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

using GLib;
using Gee;

public abstract class BidirListTests : ListTests {

	protected BidirListTests (string name) {
		base (name);
		add_test ("[List] bi-directional list iterator", test_bidir_list_iterator);
	}

	public void test_bidir_list_iterator () {
		var test_list = test_collection as Gee.BidirList<string>;

		// Check the test list is not null
		assert (test_list != null);

		// Check iterate empty list
		var iterator = test_list.bidir_list_iterator ();
		assert (! iterator.has_next ());
		assert (! iterator.next ());
		assert (! iterator.has_previous ());
		assert (! iterator.previous ());
		assert (! iterator.first ());
		assert (! iterator.last ());

		// Check iterate list
		assert (test_list.add ("one"));
		assert (test_list.add ("two"));
		assert (test_list.add ("three"));

		iterator = test_list.bidir_list_iterator ();
		assert (iterator.next());
		assert (iterator.get () == "one");
		assert (iterator.index () == 0);
		((ListIterator<string>)iterator).set ("new one");
		assert (iterator.next());
		assert (iterator.get () == "two");
		assert (iterator.index () == 1);
		((ListIterator<string>)iterator).set ("new two");
		assert (test_list.size == 3);
		assert (iterator.index () == 1);
		iterator.insert ("before two");
		assert (test_list.size == 4);
		assert (iterator.index () == 2);
		iterator.add ("after two");
		assert (test_list.size == 5);
		assert (iterator.index () == 3);
		assert (iterator.next());
		assert (iterator.get () == "three");
		assert (iterator.index () == 4);
		((ListIterator<string>)iterator).set ("new three");
		assert (! iterator.has_next ());
		assert (! iterator.next ());

		assert (iterator.first ());
		assert (iterator.get () == "new one");
		assert (iterator.index () == 0);
		assert (! iterator.has_previous ());
		assert (! iterator.previous ());

		assert (iterator.last ());
		assert (iterator.get () == "new three");
		assert (iterator.index () == 4);
		assert (! iterator.has_next ());
		assert (! iterator.next ());

		assert (iterator.has_previous ());
		assert (iterator.previous ());
		assert (iterator.get () == "after two");
		assert (iterator.index () == 3);
		assert (iterator.has_previous ());
		assert (iterator.previous ());
		assert (iterator.get () == "new two");
		assert (iterator.index () == 2);
		assert (iterator.has_previous ());
		assert (iterator.previous ());
		assert (iterator.get () == "before two");
		assert (iterator.index () == 1);
		assert (iterator.has_previous ());
		assert (iterator.previous ());
		assert (iterator.get () == "new one");
		assert (iterator.index () == 0);
	}
}

