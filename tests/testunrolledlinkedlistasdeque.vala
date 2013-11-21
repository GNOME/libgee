/* testunrolledLinkedListasdeque.vala
 *
 * Copyright (C) 2009  Didier Villevalois
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
 * 	Didier 'Ptitjes Villevalois <ptitjes@free.fr>
 */

using Gee;

public class UnrolledLinkedListAsDequeTests : DequeTests {

	public UnrolledLinkedListAsDequeTests () {
		base ("UnrolledLinkedList as Deque");
		add_test ("[UnrolledLinkedList] selected functions", test_selected_functions);
	}

	public override void set_up () {
		test_collection = new UnrolledLinkedList<string> ();
	}

	public override void tear_down () {
		test_collection = null;
	}

	private void test_selected_functions () {
		var test_list = test_collection as UnrolledLinkedList<string>;

		// Check the collection exists
		assert (test_list != null);
	}
}
