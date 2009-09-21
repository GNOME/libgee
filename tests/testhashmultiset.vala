/* testhashmultiset.vala
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

public class HashMultiSetTests : MultiSetTests {

	public HashMultiSetTests () {
		base ("HashMultiSet");
		add_test ("[HashMultiSet] selected functions", test_selected_functions);
	}

	public override void set_up () {
		test_collection = new HashMultiSet<string> ();
	}

	public override void tear_down () {
		test_collection = null;
	}

	private void test_selected_functions () {
		var test_multi_set = test_collection as HashMultiSet<string>;

		// Check the collection exists
		assert (test_multi_set != null);
	}
}
