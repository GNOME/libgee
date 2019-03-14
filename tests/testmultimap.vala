/* testmultimap.vala
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
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using GLib;
using Gee;

public abstract class MultiMapTests : Gee.TestCase {

	protected MultiMapTests (string name) {
		base (name);
		add_test ("[MultiMap] type correctness", test_type_correctness);
		add_test ("[MultiMap] size", test_size);
		add_test ("[MultiMap] getting and setting", test_getting_setting);
		add_test ("[MultiMap] keys, all keys and values", test_keys_all_keys_values);
	}

	protected MultiMap<string,string> test_multi_map;

	public void test_type_correctness () {
		// Check the multimap exists
		assert (test_multi_map != null);

		// Check the advertised key and value types
		assert (test_multi_map.key_type == typeof (string));
		assert (test_multi_map.value_type == typeof (string));
	}

	private void test_size () {
		// Check the map exists
		assert (test_multi_map != null);

		assert (test_multi_map.size == 0);
		test_multi_map.set ("0", "0");
		assert (test_multi_map.size == 1);
		test_multi_map.set ("0", "1");
		assert (test_multi_map.size == 2);
		test_multi_map.remove ("0", "1");
		assert (test_multi_map.size == 1);
		test_multi_map.set ("0", "1");
		test_multi_map.remove_all ("0");
		assert (test_multi_map.size == 0);
		test_multi_map.set ("0", "0");
		assert (test_multi_map.size == 1);
		test_multi_map.set ("1", "1");
		assert (test_multi_map.size == 2);
	}

	private void test_getting_setting () {
		// Check the map exists
		assert (test_multi_map != null);

		test_multi_map.set ("0", "0");
		assert (test_multi_map.contains ("0"));
		assert (test_multi_map.get ("0").size == 1);
		assert (test_multi_map.get ("0").contains ("0"));

		assert (test_multi_map.get ("1").size == 0);

		test_multi_map.set ("0", "1");
		assert (test_multi_map.get ("0").size == 2);
		assert (test_multi_map.get ("0").contains ("0"));
		assert (test_multi_map.get ("0").contains ("1"));

		test_multi_map.set ("1", "1");
		assert (test_multi_map.contains ("1"));
		assert (test_multi_map.get ("0").size == 2);
		assert (test_multi_map.get ("0").contains ("0"));
		assert (test_multi_map.get ("0").contains ("1"));
		assert (test_multi_map.get ("1").size == 1);
		assert (test_multi_map.get ("0").contains ("1"));

		// Check remove if bindings exist
		assert (test_multi_map.remove ("0", "0"));
		assert (test_multi_map.contains ("0"));
		assert (! test_multi_map.get ("0").contains ("0"));
		assert (test_multi_map.get ("0").contains ("1"));
		assert (test_multi_map.contains ("1"));
		assert (test_multi_map.get ("1").contains ("1"));

		// Check remove if only one binding exists
		assert (test_multi_map.remove ("0", "1"));
		assert (! test_multi_map.contains ("0"));
		assert (! test_multi_map.get ("0").contains ("0"));
		assert (! test_multi_map.get ("0").contains ("1"));
		assert (test_multi_map.contains ("1"));
		assert (test_multi_map.get ("1").contains ("1"));

		// Check remove if no binding exists
		assert (! test_multi_map.remove ("0", "1"));
		assert (! test_multi_map.contains ("0"));
		assert (! test_multi_map.get ("0").contains ("0"));
		assert (! test_multi_map.get ("0").contains ("1"));
		assert (test_multi_map.contains ("1"));
		assert (test_multi_map.get ("1").contains ("1"));

		test_multi_map.clear ();
		assert (! test_multi_map.contains ("0"));
		assert (! test_multi_map.contains ("1"));

		// Check remove_all
		test_multi_map.set ("0", "0");
		test_multi_map.set ("0", "1");
		test_multi_map.set ("1", "1");
		assert (test_multi_map.size == 3);

		assert (test_multi_map.contains ("0"));
		assert (test_multi_map.contains ("1"));
		assert (test_multi_map.get ("0").size == 2);
		assert (test_multi_map.get ("0").contains ("0"));
		assert (test_multi_map.get ("0").contains ("1"));
		assert (test_multi_map.get ("1").size == 1);
		assert (test_multi_map.get ("0").contains ("1"));

		// Check remove_all if bindings exist
		assert (test_multi_map.remove_all ("0"));
		assert (! test_multi_map.contains ("0"));
		assert (! test_multi_map.get ("0").contains ("0"));
		assert (! test_multi_map.get ("0").contains ("1"));
		assert (test_multi_map.contains ("1"));
		assert (test_multi_map.get ("1").contains ("1"));

		// Check remove_all if no binding exists
		assert (! test_multi_map.remove_all ("0"));
		assert (! test_multi_map.contains ("0"));
		assert (! test_multi_map.get ("0").contains ("0"));
		assert (! test_multi_map.get ("0").contains ("1"));
		assert (test_multi_map.contains ("1"));
		assert (test_multi_map.get ("1").contains ("1"));
	}

	private void test_keys_all_keys_values () {
		// Check the map exists
		assert (test_multi_map != null);

		test_multi_map.set ("0", "0");
		test_multi_map.set ("0", "1");
		test_multi_map.set ("1", "1");

		// Check for keys, all_keys and values
		Set<string> keys = test_multi_map.get_keys ();
		MultiSet<string> all_keys = test_multi_map.get_all_keys ();
		Collection<string> values = test_multi_map.get_values ();

		assert (keys.contains ("0"));
		assert (keys.contains ("1"));
		assert (all_keys.count ("0") == 2);
		assert (all_keys.count ("1") == 1);
		assert (values.contains ("0"));
		assert (values.contains ("1"));

		bool zero_found = false;
		bool zero_found_once = true;
		bool one_found = false;
		bool one_found_twice = false;
		bool nothing_more = true;
		foreach (string value in values) {
			if (value == "0") {
				if (zero_found) {
					zero_found_once = false;
				}
				zero_found = true;
			} else if (value == "1") {
				if (one_found) {
					if (one_found_twice) {
						one_found_twice = false;
					} else {
						one_found_twice = true;
					}
				}
				one_found = true;
			} else {
				nothing_more = false;
			}
		}
		assert (zero_found);
		assert (zero_found_once);
		assert (one_found);
		assert (one_found_twice);
		assert (nothing_more);
	}
}
