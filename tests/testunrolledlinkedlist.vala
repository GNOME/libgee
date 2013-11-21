/* testunrolledLinkedList.vala
 *
 * Copyright (C) 2008  Jürg Billeter
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
 * Authors:
 * 	Jürg Billeter <j@bitron.ch>
 * 	Mark Lee <marklee@src.gnome.org> (port to UnrolledLinkedList)
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using Gee;

public class UnrolledLinkedListTests : BidirListTests {

	public UnrolledLinkedListTests () {
		base ("UnrolledLinkedList");
		add_test ("[UnrolledLinkedList] sort", test_sort);
	}

	public override void set_up () {
		test_collection = new UnrolledLinkedList<string> ();
	}

	public override void tear_down () {
		test_collection = null;
	}

	private void test_sort () {
		var test_list = test_collection as UnrolledLinkedList<string>;

		// Check the collection exists
		assert (test_list != null);

		test_list.add ("one");
		test_list.add ("two");
		test_list.add ("three");
		test_list.add ("four");
		test_list.add ("five");
		test_list.add ("six");
		test_list.add ("seven");
		test_list.add ("eight");
		test_list.add ("nine");
		test_list.add ("ten");
		test_list.add ("eleven");
		test_list.add ("twelve");

		test_list.sort ();

		assert (test_list.get (0) == "eight");
		assert (test_list.get (1) == "eleven");
		assert (test_list.get (2) == "five");
		assert (test_list.get (3) == "four");
		assert (test_list.get (4) == "nine");
		assert (test_list.get (5) == "one");
		assert (test_list.get (6) == "seven");
		assert (test_list.get (7) == "six");
		assert (test_list.get (8) == "ten");
		assert (test_list.get (9) == "three");
		assert (test_list.get (10) == "twelve");
		assert (test_list.get (11) == "two");
	}
}
