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

public class TreeSetTests : BidirSortedSetTests {

	public TreeSetTests () {
		base ("TreeSet");
		add_test ("[TreeSet] add and remove", test_add_remove);
	}

	public override void set_up () {
		test_collection = new TreeSet<string> ();
	}

	public override void tear_down () {
		test_collection = null;
	}

	public new void test_add_remove () {
		var test_set = test_collection as TreeSet<string>;

		// Check the set exists
		assert (test_set != null);

		base.test_remove_all ();

		var to_add = new string[] {
			"3", "10", "5", "6", "13", "8", "12", "11", "1", "0", "9", "2", "14", "7", "15", "4"
		};
		var to_remove = new string[] {
			"11", "13", "1", "12", "4", "0", "2", "5", "6", "3", "14", "10", "7", "15", "8", "9"
		};

		foreach (var s in to_add) {
			assert (!test_set.contains (s));
			assert (test_set.add (s));
			assert (test_set.contains (s));
		}
		foreach (var s in to_remove) {
			assert (test_set.contains (s));
			assert (test_set.remove (s));

			assert (!test_set.contains (s));
		}

		to_add = new string[] {
			"2", "9", "13", "7", "12", "14", "8", "1", "5", "6", "11", "15", "3", "10", "0", "4"
		};
		to_remove = new string[] {
			"11", "10", "14", "6", "13", "4", "3", "15", "8", "5", "7", "0", "12", "2", "9", "1"
		};

		foreach (var s in to_add) {
			assert (!test_set.contains (s));
			assert (test_set.add (s));
			assert (test_set.contains (s));
		}
		foreach (var s in to_remove) {
			assert (test_set.contains (s));
			assert (test_set.remove (s));
			assert (!test_set.contains (s));
		}
	}
}
