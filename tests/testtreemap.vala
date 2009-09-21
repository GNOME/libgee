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
		add_test ("[TreeMap] key ordering", test_key_ordering);
	}

	public override void set_up () {
		test_map = new TreeMap<string,string> ();
	}

	public override void tear_down () {
		test_map = null;
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
		assert (iterator.next ());
		assert (iterator.get () == "eight");
		assert (iterator.next ());
		assert (iterator.get () == "eleven");
		assert (iterator.next ());
		assert (iterator.get () == "five");
		assert (iterator.next ());
		assert (iterator.get () == "four");
		assert (iterator.next ());
		assert (iterator.get () == "nine");
		assert (iterator.next ());
		assert (iterator.get () == "one");
		assert (iterator.next ());
		assert (iterator.get () == "seven");
		assert (iterator.next ());
		assert (iterator.get () == "six");
		assert (iterator.next ());
		assert (iterator.get () == "ten");
		assert (iterator.next ());
		assert (iterator.get () == "three");
		assert (iterator.next ());
		assert (iterator.get () == "twelve");
		assert (iterator.next ());
		assert (iterator.get () == "two");
		assert (iterator.next () == false);
	}
}
