/* testlist.vala
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

	public MultiMapTests (string name) {
		base (name);
		add_test ("[MultiMap] size", test_size);
		add_test ("[MultiMap] getting and setting", test_getting_setting);
	}

	protected MultiMap<string,string> test_multi_map;

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
		assert (test_multi_map.get ("0").size == 1);
		assert (test_multi_map.get ("0").contains ("0"));

		assert (test_multi_map.get ("1").size == 0);

		test_multi_map.set ("0", "1");
		assert (test_multi_map.get ("0").size == 2);
		assert (test_multi_map.get ("0").contains ("0"));
		assert (test_multi_map.get ("0").contains ("1"));

		test_multi_map.set ("1", "1");
		assert (test_multi_map.get ("0").size == 2);
		assert (test_multi_map.get ("0").contains ("0"));
		assert (test_multi_map.get ("0").contains ("1"));
		assert (test_multi_map.get ("1").size == 1);
		assert (test_multi_map.get ("0").contains ("1"));
	}
}
