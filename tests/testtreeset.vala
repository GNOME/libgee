/* testtreeset.vala
 *
 * Copyright (C) 2008  Maciej Piechotka
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
 * 	Maciej Piechotka <uzytkownik2@gmail.com>
 */

using GLib;
using Gee;

void test_treeset_add () {
	// Check adding of strings
	var treeset = new TreeSet<string> ((CompareFunc) strcmp);

	treeset.add ("42");
	assert (treeset.contains ("42"));
	assert (treeset.size == 1);

	treeset.add ("43");
	assert (treeset.contains ("42"));
	assert (treeset.contains ("43"));
	assert (treeset.size == 2);

	// Check add same element
	assert (treeset.size == 2);
	treeset.add ("43");
	assert (treeset.contains ("42"));
	assert (treeset.contains ("43"));
	assert (treeset.size == 2);

	// Check adding of ints
	var treesetInt = new TreeSet<int> ();

	treesetInt.add (42);
	assert (treesetInt.contains (42));
	assert (treesetInt.size == 1);

	treesetInt.add (43);
	assert (treesetInt.contains (42));
	assert (treesetInt.contains (43));
	assert (treesetInt.size == 2);

	// Check add same element
	assert (treesetInt.size == 2);
	treesetInt.add (43);
	assert (treesetInt.contains (42));
	assert (treesetInt.contains (43));
	assert (treesetInt.size == 2);

	// Check adding of objects
	var treesetObject = new TreeSet<Object> ();

	var fooObject = new Object();
	treesetObject.add (fooObject);
	assert (treesetObject.contains (fooObject));
	assert (treesetObject.size == 1);

	var fooObject2 = new Object();
	treesetObject.add (fooObject2);
	assert (treesetObject.contains (fooObject));
	assert (treesetObject.contains (fooObject2));
	assert (treesetObject.size == 2);

	// Check add same element
	assert (treesetObject.size == 2);
	treesetObject.add (fooObject2);
	assert (treesetObject.contains (fooObject));
	assert (treesetObject.contains (fooObject2));
	assert (treesetObject.size == 2);
}

void test_treeset_clear () {
	var treeset = new TreeSet<string> ((CompareFunc) strcmp);
	assert (treeset.size == 0);

	// Check clear on empty set
	treeset.clear ();
	assert (treeset.size == 0);

	// Check clear one item
	treeset.add ("1");
	assert (treeset.size == 1);
	treeset.clear ();
	assert (treeset.size == 0);

	// Check clear multiple items
	treeset.add ("1");
	treeset.add ("2");
	treeset.add ("3");
	assert (treeset.size == 3);
	treeset.clear ();
	assert (treeset.size == 0);
}

void test_treeset_contains () {
	var treesetString = new TreeSet<string> ((CompareFunc) strcmp);

	// Check on empty set
	assert (!treesetString.contains ("1"));

	// Check items
	treesetString.add ("10");
	assert (treesetString.contains ("10"));
	assert (!treesetString.contains ("20"));
	assert (!treesetString.contains ("30"));

	treesetString.add ("20");
	assert (treesetString.contains ("10"));
	assert (treesetString.contains ("20"));
	assert (!treesetString.contains ("30"));

	treesetString.add ("30");
	assert (treesetString.contains ("10"));
	assert (treesetString.contains ("20"));
	assert (treesetString.contains ("30"));

	// Clear and recheck
	treesetString.clear ();
	assert (!treesetString.contains ("10"));
	assert (!treesetString.contains ("20"));
	assert (!treesetString.contains ("30"));

	var treesetInt = new TreeSet<int> ();

	// Check items
	treesetInt.add (10);
	assert (treesetInt.contains (10));
	assert (!treesetInt.contains (20));
	assert (!treesetInt.contains (30));

	treesetInt.add (20);
	assert (treesetInt.contains (10));
	assert (treesetInt.contains (20));
	assert (!treesetInt.contains (30));

	treesetInt.add (30);
	assert (treesetInt.contains (10));
	assert (treesetInt.contains (20));
	assert (treesetInt.contains (30));

	// Clear and recheck
	treesetInt.clear ();
	assert (!treesetInt.contains (10));
	assert (!treesetInt.contains (20));
	assert (!treesetInt.contains (30));
}

void test_treeset_remove () {
	var treesetString = new TreeSet<string> ((CompareFunc) strcmp);

	// Check remove if list is empty
	treesetString.remove ("42");

	// Add 5 different elements
	treesetString.add ("42");
	treesetString.add ("43");
	treesetString.add ("44");
	treesetString.add ("45");
	treesetString.add ("46");
	assert (treesetString.size == 5);

	// Check remove first
	treesetString.remove ("42");
	assert (treesetString.size == 4);
	assert (treesetString.contains ("43"));
	assert (treesetString.contains ("44"));
	assert (treesetString.contains ("45"));
	assert (treesetString.contains ("46"));

	// Check remove last
	treesetString.remove ("46");
	assert (treesetString.size == 3);
	assert (treesetString.contains ("43"));
	assert (treesetString.contains ("44"));
	assert (treesetString.contains ("45"));

	// Check remove in between
	treesetString.remove ("44");
	assert (treesetString.size == 2);
	assert (treesetString.contains ("43"));
	assert (treesetString.contains ("45"));

	// Check removing of int element
	var treesetInt = new TreeSet<int> ();

	// Add 5 different elements
	treesetInt.add (42);
	treesetInt.add (43);
	treesetInt.add (44);
	treesetInt.add (45);
	treesetInt.add (46);
	assert (treesetInt.size == 5);

	// Remove first
	treesetInt.remove (42);
	assert (treesetInt.size == 4);
	assert (treesetInt.contains (43));
	assert (treesetInt.contains (44));
	assert (treesetInt.contains (45));
	assert (treesetInt.contains (46));

	// Remove last
	treesetInt.remove (46);
	assert (treesetInt.size == 3);
	assert (treesetInt.contains (43));
	assert (treesetInt.contains (44));
	assert (treesetInt.contains (45));

	// Remove in between
	treesetInt.remove (44);
	assert (treesetInt.size == 2);
	assert (treesetInt.contains (43));
	assert (treesetInt.contains (45));
}

void test_treeset_size () {
	var treeset = new TreeSet<string> ((CompareFunc) strcmp);

	// Check empty list
	assert (treeset.size == 0);

	// Check when one item
	treeset.add ("1");
	assert (treeset.size == 1);

	// Check when more items
	treeset.add ("2");
	assert (treeset.size == 2);

	// Check when items cleared
	treeset.clear ();
	assert (treeset.size == 0);
}

void test_treeset_iterator () {
	var treeset = new TreeSet<string> ((CompareFunc) strcmp);

	// Check iterate empty list
	var iterator = treeset.iterator ();
	assert (!iterator.next());

	// Check iterate list
	treeset.add ("42");
	treeset.add ("43");

	iterator = treeset.iterator ();

	assert (iterator.next());
	string firstString = iterator.get();
	assert (treeset.contains (firstString)); 
	assert (firstString == "42");

	assert (iterator.next());
	string secondString = iterator.get();
	assert (treeset.contains (secondString));
	assert (secondString == "43");

	assert (!iterator.next());
}

void main (string[] args) {
	Test.init (ref args);

	Test.add_func ("/TreeSet/Collection/add", test_treeset_add);
	Test.add_func ("/TreeSet/Collection/clear", test_treeset_clear);
	Test.add_func ("/TreeSet/Collection/contains", test_treeset_contains);
	Test.add_func ("/TreeSet/Collection/remove", test_treeset_remove);
	Test.add_func ("/TreeSet/Collection/size", test_treeset_size);
	Test.add_func ("/TreeSet/Iterable/iterator", test_treeset_iterator);

	Test.run ();
}
