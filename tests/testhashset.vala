/* testhashset.vala
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

public class HashSetTests : SetTests {

	public HashSetTests () {
		base ("HashSet");
		add_test ("[HashSet] selected functions", test_selected_functions);
		add_test ("[HashSet] GObject properties", test_gobject_properties);
	}

	public override void set_up () {
		test_collection = new HashSet<string> ();
	}

	public override void tear_down () {
		test_collection = null;
	}

	public void test_selected_functions () {
		var test_set = test_collection as HashSet<string>;

		// Check the map exists
		assert (test_set != null);

		// Check the selected hash and equal functions
		assert (test_set.hash_func == str_hash);
		assert (test_set.equal_func == str_equal);
	}

	public new void test_gobject_properties () {
		var test_set = test_collection as HashSet<string>;

		// Check the list exists
		assert (test_set != null);
		Value value;

		value = Value (typeof (HashFunc));
		test_set.get_property ("hash-func", ref value);
		assert (value.get_pointer () == (void*) test_set.hash_func);
		value.unset ();

		value = Value (typeof (EqualFunc));
		test_set.get_property ("equal-func", ref value);
		assert (value.get_pointer () == (void*) test_set.equal_func);
		value.unset ();
	}
}
