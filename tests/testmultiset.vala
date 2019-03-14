/* testmultiset.vala
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

public abstract class MultiSetTests : CollectionTests {

	protected MultiSetTests (string name) {
		base (name);
		add_test ("[MultiSet] duplicates are retained",
		          test_duplicates_are_retained);
	}

	private void test_duplicates_are_retained () {
		var test_multi_set = test_collection as MultiSet<string>;

		// Check the test set is not null
		assert (test_multi_set != null);

		assert (test_multi_set.count ("one") == 0);

		assert (test_multi_set.add ("one"));
		assert (test_multi_set.contains ("one"));
		assert (test_multi_set.size == 1);
		assert (test_multi_set.count ("one") == 1);

		assert (test_multi_set.add ("one"));
		assert (test_multi_set.contains ("one"));
		assert (test_multi_set.size == 2);
		assert (test_multi_set.count ("one") == 2);

		assert (test_multi_set.add ("one"));
		assert (test_multi_set.contains ("one"));
		assert (test_multi_set.size == 3);
		assert (test_multi_set.count ("one") == 3);

		assert (test_multi_set.remove ("one"));
		assert (test_multi_set.contains ("one"));
		assert (test_multi_set.size == 2);
		assert (test_multi_set.count ("one") == 2);

		assert (test_multi_set.remove ("one"));
		assert (test_multi_set.contains ("one"));
		assert (test_multi_set.size == 1);
		assert (test_multi_set.count ("one") == 1);

		assert (test_multi_set.remove ("one"));
		assert (!test_multi_set.contains ("one"));
		assert (test_multi_set.size == 0);
		assert (test_multi_set.count ("one") == 0);
	}
}
