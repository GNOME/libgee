/* testhashmap.vala
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
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using Gee;

public class HashMapTests : MapTests {

	public HashMapTests () {
		base ("HashMap");
		add_test ("[HashMap] selected functions", test_selected_functions);
		add_test ("[HashMap] GObject properties", test_gobject_properties);
	}

	public override void set_up () {
		test_map = new HashMap<string,string> ();
	}

	public override void tear_down () {
		test_map = null;
	}

	public void test_selected_functions () {
		var test_hash_map = test_map as HashMap<string,string>;

		// Check the map exists
		assert (test_hash_map != null);

		// Check the selected hash and equal functions
		assert (test_hash_map.key_hash_func == str_hash);
		assert (test_hash_map.key_equal_func == str_equal);
		assert (test_hash_map.value_equal_func == str_equal);
	}

	public new void test_gobject_properties() {
		var test_hash_map = test_map as HashMap<string,string>;

		// Check the list exists
		assert (test_hash_map != null);
		Value value;

		value = Value (typeof (HashFunc));
		test_hash_map.get_property ("key-hash-func", ref value);
		assert (value.get_pointer () == (void*) test_hash_map.key_hash_func);
		value.unset ();

		value = Value (typeof (EqualFunc));
		test_hash_map.get_property ("key-equal-func", ref value);
		assert (value.get_pointer () == (void*) test_hash_map.key_equal_func);
		value.unset ();

		value = Value (typeof (EqualFunc));
		test_hash_map.get_property ("value-equal-func", ref value);
		assert (value.get_pointer () == (void*) test_hash_map.value_equal_func);
		value.unset ();
	}
}
