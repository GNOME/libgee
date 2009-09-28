/* testarraylist.vala
 *
 * Copyright (C) 2008  Jürg Billeter
 * Copyright (C) 2009  Didier Villevalois, Julien Peeters
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
 * 	Jürg Billeter <j@bitron.ch>
 * 	Didier 'Ptitjes Villevalois <ptitjes@free.fr>
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using Gee;

public class ArrayListTests : ListTests {

	public ArrayListTests () {
		base ("ArrayList");
		add_test ("[ArrayList] selected functions", test_selected_functions);
		add_test ("[ArrayList] GObject properties", test_gobject_properties);
		add_test ("[ArrayList] small sort (insertion)", test_small_sort);
		add_test ("[ArrayList] big sort (timsort)", test_big_sort);
	}

	private static const int BIG_SORT_SIZE = 1000000;

	public override void set_up () {
		test_collection = new ArrayList<string> ();
	}

	public override void tear_down () {
		test_collection = null;
	}

	public void test_selected_functions () {
		var test_list = test_collection as ArrayList<string>;

		// Check the collection exists
		assert (test_list != null);

		// Check the selected equal function
		assert (test_list.equal_func == str_equal);
	}

	public new void test_gobject_properties () {
		var test_list = test_collection as ArrayList<string>;

		// Check the list exists
		assert (test_list != null);
		Value value;

		value = Value (typeof (EqualFunc));
		test_list.get_property ("equal-func", ref value);
		assert (value.get_pointer () == (void*) test_list.equal_func);
		value.unset ();
	}

	private void test_small_sort () {
		var test_list = test_collection as ArrayList<string>;

		// Check the collection exists
		assert (test_list != null);

		test_list.add ("one");
		test_list.add ("two");
		test_list.add ("three");
		test_list.add ("four");
		test_list.add ("five");
		test_list.add ("six");
		test_list.add ("seven");
		test_list.add ("eight");
		test_list.add ("nine");
		test_list.add ("ten");
		test_list.add ("eleven");
		test_list.add ("twelve");

		test_list.sort ();

		assert (test_list.get (0) == "eight");
		assert (test_list.get (1) == "eleven");
		assert (test_list.get (2) == "five");
		assert (test_list.get (3) == "four");
		assert (test_list.get (4) == "nine");
		assert (test_list.get (5) == "one");
		assert (test_list.get (6) == "seven");
		assert (test_list.get (7) == "six");
		assert (test_list.get (8) == "ten");
		assert (test_list.get (9) == "three");
		assert (test_list.get (10) == "twelve");
		assert (test_list.get (11) == "two");
	}

	private void test_big_sort () {
		Gee.List<int32> big_test_list = new ArrayList<int32> ();
		for (int i = 0; i < BIG_SORT_SIZE; i++) {
			big_test_list.add (GLib.Random.int_range (1, BIG_SORT_SIZE - 1));
		}

		big_test_list.sort ();

		for (int i = 1; i < BIG_SORT_SIZE; i++) {
			assert (big_test_list[i - 1] <= big_test_list[i]);
		}
	}
}
