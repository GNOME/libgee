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

public class ArrayListTests : BidirListTests {

	public ArrayListTests () {
		base ("ArrayList");
		add_test ("[ArrayList] selected functions", test_selected_functions);
		add_test ("[ArrayList] small sort (insertion)", test_small_sort);
		add_test ("[ArrayList] big sort (timsort)", test_big_sort);
		add_test ("[ArrayList] typed to_array calls", test_typed_to_array);
	}

	private const int BIG_SORT_SIZE = 1000000;

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

	private enum TestEnum {
		ONE, TWO, THREE
	}

	private void test_typed_to_array () {
		// Test with a bool collection
		Gee.List<bool> bool_list = new ArrayList<bool> ();
		assert (bool_list.add (true));
		assert (bool_list.add (true));
		assert (bool_list.add (false));

		bool[] bool_array = bool_list.to_array ();
		int index = 0;
		foreach (bool element in bool_list) {
			assert (element == bool_array[index++]);
		}

		// Test with an int collection
		Gee.List<int> int_list = new ArrayList<int> ();
		assert (int_list.add (1));
		assert (int_list.add (2));
		assert (int_list.add (3));

		int[] int_array = int_list.to_array ();
		index = 0;
		foreach (int element in int_list) {
			assert (element == int_array[index++]);
		}

		// Test with a double collection
		Gee.List<double?> double_list = new ArrayList<double?> ();
		assert (double_list.add (1.0d));
		assert (double_list.add (1.5d));
		assert (double_list.add (2.0d));

		double?[] double_array = double_list.to_array ();
		index = 0;
		foreach (double element in double_list) {
			assert (element == double_array[index++]);
		}

		// Test with an enum collection
		Gee.List<TestEnum> enum_list = new ArrayList<TestEnum> ();
		assert (enum_list.add (TestEnum.ONE));
		assert (enum_list.add (TestEnum.TWO));
		assert (enum_list.add (TestEnum.THREE));

		TestEnum[] enum_array = enum_list.to_array ();
		index = 0;
		foreach (TestEnum element in enum_list) {
			assert (element == enum_array[index++]);
		}
	}
}
