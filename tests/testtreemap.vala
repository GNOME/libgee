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

const string CODE_NOT_REACHABLE = "*code should not be reached*";

void test_treemap_get () {
	var treemap = new TreeMap<string,string> ((CompareFunc) strcmp, str_equal);

	// Check get from empty map
	assert (treemap.get ("foo") == null);

	// Check get from map with one items
	treemap.set ("key", "value");
	assert (treemap.get ("key") == "value");

	// Check get from non-existing key
	assert (treemap.get ("foo") == null);

	// Check get from map with multiple items
	treemap.set ("key2", "value2");
	treemap.set ("key3", "value3");
	assert (treemap.get ("key") == "value");
	assert (treemap.get ("key2") == "value2");
	assert (treemap.get ("key3") == "value3");
}

void test_treemap_set () {
	var treemap = new TreeMap<string,string> ((CompareFunc) strcmp, str_equal);

	// check map is empty
	assert (treemap.size == 0);

	// check set an item to map
	treemap.set ("abc", "one");
	assert (treemap.contains ("abc"));
	assert (treemap.get ("abc") == "one");
	assert (treemap.size == 1);

	// check set an item to map with same value
	treemap.set ("def", "one");
	assert (treemap.contains ("def"));
	assert (treemap.get ("abc") == "one");
	assert (treemap.get ("def") == "one");
	assert (treemap.size == 2);

	// check set with same key
	treemap.set ("def", "two");
	assert (treemap.contains ("def"));
	assert (treemap.get ("abc") == "one");
	assert (treemap.get ("def") == "two");
	assert (treemap.size == 2);
}

void test_treemap_remove () {
	var treemap = new TreeMap<string,string> ((CompareFunc) strcmp, str_equal);
	string? value;

	// check removing when map is empty
	treemap.remove ("foo");
	assert (treemap.size == 0);

	// add items
	treemap.set ("aaa", "111");
	treemap.set ("bbb", "222");
	treemap.set ("ccc", "333");
	treemap.set ("ddd", "444");
	assert (treemap.size == 4);

	// check remove on first place
	treemap.remove ("aaa");
	assert (treemap.size == 3);

	// check remove in between 
	treemap.remove ("ccc", out value);
	assert (treemap.size == 2);
	assert (value == "333");

	// check remove in last place
	treemap.remove ("ddd");
	assert (treemap.size == 1);

	// check remove invalid key
	treemap.remove ("bar", out value);
	assert (value == null);

	// check remove last in map
	treemap.remove ("bbb");
	assert (treemap.size == 0);
}

void test_treemap_contains () {
	var treemap = new TreeMap<string,string> ((CompareFunc) strcmp, str_equal);

	// Check on empty map
	assert (!treemap.contains ("111"));

	// Check items
	treemap.set ("10", "111");
	assert (treemap.contains ("10"));
	assert (!treemap.contains ("20"));
	assert (!treemap.contains ("30"));

	assert (treemap.get ("10") == "111");

	treemap.set ("20", "222");
	assert (treemap.contains ("10"));
	assert (treemap.contains ("20"));
	assert (!treemap.contains ("30"));

	assert (treemap.get ("10") == "111");
	assert (treemap.get ("20") == "222");

	treemap.set ("30", "333");
	assert (treemap.contains ("10"));
	assert (treemap.contains ("20"));
	assert (treemap.contains ("30"));

	assert (treemap.get ("10") == "111");
	assert (treemap.get ("20") == "222");
	assert (treemap.get ("30") == "333");

	// Clear and recheck
	treemap.clear ();
	assert (!treemap.contains ("10"));
	assert (!treemap.contains ("20"));
	assert (!treemap.contains ("30"));

	var treemapOfInt = new TreeMap<int,int> ();

	// Check items
	treemapOfInt.set (10, 111);
	assert (treemapOfInt.contains (10));
	assert (!treemapOfInt.contains (20));
	assert (!treemapOfInt.contains (30));

	assert (treemapOfInt.get (10) == 111);

	treemapOfInt.set (20, 222);
	assert (treemapOfInt.contains (10));
	assert (treemapOfInt.contains (20));
	assert (!treemapOfInt.contains (30));

	assert (treemapOfInt.get (10) == 111);
	assert (treemapOfInt.get (20) == 222);

	treemapOfInt.set (30, 333);
	assert (treemapOfInt.contains (10));
	assert (treemapOfInt.contains (20));
	assert (treemapOfInt.contains (30));

	assert (treemapOfInt.get (10) == 111);
	assert (treemapOfInt.get (20) == 222);
	assert (treemapOfInt.get (30) == 333);
}

void test_treemap_size () {
	var treemap = new TreeMap<string,string> ((CompareFunc) strcmp, str_equal);

	// Check empty map
	assert (treemap.size == 0);

	// Check when one item
	treemap.set ("1", "1");
	assert (treemap.size == 1);

	// Check when more items
	treemap.set ("2", "2");
	assert (treemap.size == 2);

	// Check when items cleared
	treemap.clear ();
	assert (treemap.size == 0);
}

void test_treemap_get_keys () {
	var treemap = new TreeMap<string,string> ((CompareFunc) strcmp, str_equal);

	// Check keys on empty map
	var keySet = treemap.get_keys ();
	assert (keySet.size == 0);

	// Check keys on map with one item
	treemap.set ("aaa", "111");
	assert (keySet.size == 1);
	assert (keySet.contains ("aaa"));
	keySet = treemap.get_keys ();
	assert (keySet.size == 1);
	assert (keySet.contains ("aaa"));

	// Check modify key set directly
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		keySet.add ("ccc");
		return;
	}
	Test.trap_assert_failed ();
	Test.trap_assert_stderr (CODE_NOT_REACHABLE);

	// Check keys on map with multiple items
	treemap.set ("bbb", "222");
	assert (keySet.size == 2);
	assert (keySet.contains ("aaa"));
	assert (keySet.contains ("bbb"));
	keySet = treemap.get_keys ();
	assert (keySet.size == 2);
	assert (keySet.contains ("aaa"));
	assert (keySet.contains ("bbb"));

	// Check keys on map clear
	treemap.clear ();
	assert (keySet.size == 0);
	keySet = treemap.get_keys ();
	assert (keySet.size == 0);
}

void test_treemap_get_values () {
	var treemap = new TreeMap<string,string> ((CompareFunc) strcmp, str_equal);

	// Check keys on empty map
	var valueCollection = treemap.get_values ();
	assert (valueCollection.size == 0);

	// Check keys on map with one item
	treemap.set ("aaa", "111");
	assert (valueCollection.size == 1);
	assert (valueCollection.contains ("111"));
	valueCollection = treemap.get_values ();
	assert (valueCollection.size == 1);
	assert (valueCollection.contains ("111"));

	// Check modify key set directly
	if (Test.trap_fork (0, TestTrapFlags.SILENCE_STDOUT | TestTrapFlags.SILENCE_STDERR)) {
		valueCollection.add ("ccc");
		return;
	}
	Test.trap_assert_failed ();
	Test.trap_assert_stderr (CODE_NOT_REACHABLE);

	// Check keys on map with multiple items
	treemap.set ("bbb", "222");
	assert (valueCollection.size == 2);
	assert (valueCollection.contains ("111"));
	assert (valueCollection.contains ("222"));
	valueCollection = treemap.get_values ();
	assert (valueCollection.size == 2);
	assert (valueCollection.contains ("111"));
	assert (valueCollection.contains ("222"));

	// Check keys on map clear
	treemap.clear ();
	assert (valueCollection.size == 0);
	valueCollection = treemap.get_values ();
	assert (valueCollection.size == 0);
}

void test_treemap_clear () {
	var treemap = new TreeMap<string,string> ((CompareFunc) strcmp, str_equal);
	assert (treemap.size == 0);

	// Check clear on empty map
	treemap.clear ();
	assert (treemap.size == 0);

	// Check clear one item
	treemap.set ("1", "1");
	assert (treemap.size == 1);
	treemap.clear ();
	assert (treemap.size == 0);

	// Check clear multiple items
	treemap.set ("1", "1");
	treemap.set ("2", "2");
	treemap.set ("3", "3");
	assert (treemap.size == 3);
	treemap.clear ();
	assert (treemap.size == 0);
}

void main (string[] args) {
	Test.init (ref args);

	Test.add_func ("/TreeMap/Map/get", test_treemap_get);
	Test.add_func ("/TreeMap/Map/set", test_treemap_set);
	Test.add_func ("/TreeMap/Map/remove", test_treemap_remove);
	Test.add_func ("/TreeMap/Map/contains", test_treemap_contains);
	Test.add_func ("/TreeMap/Map/size", test_treemap_size);
	Test.add_func ("/TreeMap/Map/get_keys", test_treemap_get_keys);
	Test.add_func ("/TreeMap/Map/get_values", test_treemap_get_values);
	Test.add_func ("/TreeMap/Map/clear", test_treemap_clear);

	Test.run ();
}
