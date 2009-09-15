/* testtreeset.vala
 *
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
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using Gee;

public class TreeSetTests : SetTests {

	public TreeSetTests () {
		base ("TreeSet");
		add_test ("[TreeSet] selected functions", test_selected_functions);
		add_test ("[TreeSet] GObject properties", test_gobject_properties);
		add_test ("[TreeSet] ordering", test_ordering);
	}

	public override void set_up () {
		test_collection = new TreeSet<string> ();
	}

	public override void tear_down () {
		test_collection = null;
	}

	public void test_selected_functions () {
		var test_set = test_collection as TreeSet<string>;

		// Check the set exists
		assert (test_set != null);

		// Check the selected compare function
		assert (test_set.compare_func == strcmp);
	}

	public new void test_gobject_properties() {
		var test_set = test_collection as TreeSet<string>;

		// Check the set exists
		assert (test_set != null);
		Value value;

		value = Value (typeof (CompareFunc));
		test_set.get_property ("compare-func", ref value);
		assert (value.get_pointer () == (void*) test_set.compare_func);
		value.unset ();
	}

	public void test_ordering () {
		var test_set = test_collection as Set<string>;

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
