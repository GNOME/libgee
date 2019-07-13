/* testset.vala
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

public abstract class SetTests : CollectionTests {

	protected SetTests (string name) {
		base (name);
		add_test ("[Set] duplicates are ignored", test_duplicates_are_ignored);
	}

	public virtual void test_duplicates_are_ignored () {
		var test_set = test_collection as Set<string>;

		// Check the test list is not null
		assert (test_set != null);

		assert (test_set.add ("one"));
		assert (test_set.contains ("one"));
		assert (test_set.size == 1);

		assert (! test_set.add ("one"));
		assert (test_set.contains ("one"));
		assert (test_set.size == 1);

		assert (test_set.remove ("one"));
		assert (! test_set.contains ("one"));
		assert (test_set.size == 0);

		assert (! test_set.remove ("one"));
		assert (! test_set.contains ("one"));
		assert (test_set.size == 0);
	}
}
