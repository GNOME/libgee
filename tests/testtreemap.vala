/* testtreemap.vala
 *
 * Copyright (C) 2008  Maciej Piechotka
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
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using Gee;

public class TreeMapTests : MapTests {

	public TreeMapTests () {
		base ("TreeMap");
		add_test ("[TreeMap] selected functions", test_selected_functions);
		add_test ("[TreeMap] GObject properties", test_gobject_properties);
		add_test ("[TreeMap] key ordering", test_key_ordering);
	}

	public override void set_up () {
		test_map = new TreeMap<string,string> ();
	}

	public override void tear_down () {
		test_map = null;
	}

	public void test_selected_functions () {
		var test_tree_map = test_map as TreeMap<string,string>;

		// Check the map exists
		assert (test_tree_map != null);

		// Check the selected compare and equal functions
		assert (test_tree_map.key_compare_func == (CompareFunc) strcmp);
		assert (test_tree_map.value_equal_func == str_equal);
	}

	public new void test_gobject_properties() {
		var test_tree_map = test_map as TreeMap<string,string>;

		// Check the list exists
		assert (test_tree_map != null);
		Value value;

		value = Value (typeof (CompareFunc));
		test_tree_map.get_property ("key-compare-func", ref value);
		assert (value.get_pointer () == (void*) test_tree_map.key_compare_func);
		value.unset ();

		value = Value (typeof (EqualFunc));
		test_tree_map.get_property ("value-equal-func", ref value);
		assert (value.get_pointer () == (void*) test_tree_map.value_equal_func);
		value.unset ();
	}

	public void test_key_ordering () {
		var test_tree_map = test_map as TreeMap<string,string>;

		// Check the map exists
		assert (test_tree_map != null);

		test_tree_map.set ("one", "one");
		test_tree_map.set ("two", "two");
		test_tree_map.set ("three", "three");
		test_tree_map.set ("four", "four");
		test_tree_map.set ("five", "five");
		test_tree_map.set ("six", "six");
		test_tree_map.set ("seven", "seven");
		test_tree_map.set ("eight", "eight");
		test_tree_map.set ("nine", "nine");
		test_tree_map.set ("ten", "ten");
		test_tree_map.set ("eleven", "eleven");
		test_tree_map.set ("twelve", "twelve");

		Iterator<string> iterator = test_tree_map.keys.iterator ();
		assert (iterator.next () == true);
		assert (iterator.get () == "eight");
		assert (iterator.next () == true);
		assert (iterator.get () == "eleven");
		assert (iterator.next () == true);
		assert (iterator.get () == "five");
		assert (iterator.next () == true);
		assert (iterator.get () == "four");
		assert (iterator.next () == true);
		assert (iterator.get () == "nine");
		assert (iterator.next () == true);
		assert (iterator.get () == "one");
		assert (iterator.next () == true);
		assert (iterator.get () == "seven");
		assert (iterator.next () == true);
		assert (iterator.get () == "six");
		assert (iterator.next () == true);
		assert (iterator.get () == "ten");
		assert (iterator.next () == true);
		assert (iterator.get () == "three");
		assert (iterator.next () == true);
		assert (iterator.get () == "twelve");
		assert (iterator.next () == true);
		assert (iterator.get () == "two");
		assert (iterator.next () == false);
	}
}
