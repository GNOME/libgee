/* testhashmap.vala
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
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 */

using GLib;
using Gee;

const string CODE_NOT_REACHABLE = "*code should not be reached*";

void test_hashmap_get () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);
	
	// Check get from empty map
	assert (hashmap.get ("foo") == null);
	
	// Check get from map with one items
	hashmap.set ("key", "value");
	assert (hashmap.get ("key") == "value");
	
	// Check get from non-existing key
	assert (hashmap.get ("foo") == null);
	
	// Check get from map with multiple items
	hashmap.set ("key2", "value2");
	hashmap.set ("key3", "value3");
	assert (hashmap.get ("key") == "value");
	assert (hashmap.get ("key2") == "value2");
	assert (hashmap.get ("key3") == "value3");
	
}

void test_hashmap_set () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);
	
	// check map is empty
	assert (hashmap.size == 0);
	
	// check set an item to map
	hashmap.set ("abc", "one");
	assert (hashmap.contains ("abc"));
	assert (hashmap.get ("abc") == "one");
	assert (hashmap.size == 1);
	
	// check set an item to map with same value
	hashmap.set ("def", "one");
	assert (hashmap.contains ("def"));
	assert (hashmap.get ("abc") == "one");
	assert (hashmap.get ("def") == "one");
	assert (hashmap.size == 2);
	
	// check set with same key
	hashmap.set ("def", "two");
	assert (hashmap.contains ("def"));
	assert (hashmap.get ("abc") == "one");
	assert (hashmap.get ("def") == "two");
	assert (hashmap.size == 2);
}

void test_hashmap_remove () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);
	string? value;
	
	// check removing when map is empty
	hashmap.remove ("foo");
	assert (hashmap.size == 0);
	
	// add items
	hashmap.set ("aaa", "111");
	hashmap.set ("bbb", "222");
	hashmap.set ("ccc", "333");
	hashmap.set ("ddd", "444");
	assert (hashmap.size == 4);
	
	// check remove on first place
	hashmap.remove ("aaa");
	assert (hashmap.size == 3);
	
	// check remove in between 
	hashmap.remove ("ccc", out value);
	assert (hashmap.size == 2);
	assert (value == "333");
	
	// check remove in last place
	hashmap.remove ("ddd");
	assert (hashmap.size == 1);
	
	// check remove invalid key
	hashmap.remove ("bar", out value);
	assert (value == null);
	
	// check remove last in map
	hashmap.remove ("bbb");
	assert (hashmap.size == 0);
}

void test_hashmap_contains () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);
	
	// Check on empty map
	assert (!hashmap.contains ("111"));
	
	// Check items
	hashmap.set ("10", "111");
	assert (hashmap.contains ("10"));
	assert (!hashmap.contains ("20"));
	assert (!hashmap.contains ("30"));
	
	assert (hashmap.get ("10") == "111");
	
	hashmap.set ("20", "222");
	assert (hashmap.contains ("10"));
	assert (hashmap.contains ("20"));
	assert (!hashmap.contains ("30"));
	
	assert (hashmap.get ("10") == "111");
	assert (hashmap.get ("20") == "222");
	
	hashmap.set ("30", "333");
	assert (hashmap.contains ("10"));
	assert (hashmap.contains ("20"));
	assert (hashmap.contains ("30"));
	
	assert (hashmap.get ("10") == "111");
	assert (hashmap.get ("20") == "222");
	assert (hashmap.get ("30") == "333");
	
	// Clear and recheck
	hashmap.clear ();
	assert (!hashmap.contains ("10"));
	assert (!hashmap.contains ("20"));
	assert (!hashmap.contains ("30"));
	
	var hashmapOfInt = new HashMap<int,int> ();
	
	// Check items
	hashmapOfInt.set (10, 111);
	assert (hashmapOfInt.contains (10));
	assert (!hashmapOfInt.contains (20));
	assert (!hashmapOfInt.contains (30));
	
	assert (hashmapOfInt.get (10) == 111);
	
	hashmapOfInt.set (20, 222);
	assert (hashmapOfInt.contains (10));
	assert (hashmapOfInt.contains (20));
	assert (!hashmapOfInt.contains (30));
	
	assert (hashmapOfInt.get (10) == 111);
	assert (hashmapOfInt.get (20) == 222);
	
	hashmapOfInt.set (30, 333);
	assert (hashmapOfInt.contains (10));
	assert (hashmapOfInt.contains (20));
	assert (hashmapOfInt.contains (30));
	
	assert (hashmapOfInt.get (10) == 111);
	assert (hashmapOfInt.get (20) == 222);
	assert (hashmapOfInt.get (30) == 333);
}

void test_hashmap_size () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);
	
	// Check empty map
	assert (hashmap.size == 0);
	
	// Check when one item
	hashmap.set ("1", "1");
	assert (hashmap.size == 1);
	
	// Check when more items
	hashmap.set ("2", "2");
	assert (hashmap.size == 2);
	
	// Check when items cleared
	hashmap.clear ();
	assert (hashmap.size == 0);
}

void test_hashmap_get_keys () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);
	
	// Check keys on empty map
	var keySet = hashmap.get_keys ();
	assert (keySet.size == 0);
	
	// Check keys on map with one item
	hashmap.set ("aaa", "111");
	assert (keySet.size == 1);
	assert (keySet.contains ("aaa"));
	keySet = hashmap.get_keys ();
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
	hashmap.set ("bbb", "222");
	assert (keySet.size == 2);
	assert (keySet.contains ("aaa"));
	assert (keySet.contains ("bbb"));
	keySet = hashmap.get_keys ();
	assert (keySet.size == 2);
	assert (keySet.contains ("aaa"));
	assert (keySet.contains ("bbb"));
	
	// Check keys on map clear
	hashmap.clear ();
	assert (keySet.size == 0);
	keySet = hashmap.get_keys ();
	assert (keySet.size == 0);
	
}

void test_hashmap_get_values () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);
	
	// Check keys on empty map
	var valueCollection = hashmap.get_values ();
	assert (valueCollection.size == 0);
	
	// Check keys on map with one item
	hashmap.set ("aaa", "111");
	assert (valueCollection.size == 1);
	assert (valueCollection.contains ("111"));
	valueCollection = hashmap.get_values ();
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
	hashmap.set ("bbb", "222");
	assert (valueCollection.size == 2);
	assert (valueCollection.contains ("111"));
	assert (valueCollection.contains ("222"));
	valueCollection = hashmap.get_values ();
	assert (valueCollection.size == 2);
	assert (valueCollection.contains ("111"));
	assert (valueCollection.contains ("222"));
	
	// Check keys on map clear
	hashmap.clear ();
	assert (valueCollection.size == 0);
	valueCollection = hashmap.get_values ();
	assert (valueCollection.size == 0);

}

void test_hashmap_clear () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);
	assert (hashmap.size == 0);
	
	// Check clear on empty map
	hashmap.clear ();
	assert (hashmap.size == 0);
	
	// Check clear one item
	hashmap.set ("1", "1");
	assert (hashmap.size == 1);
	hashmap.clear ();
	assert (hashmap.size == 0);
	
	// Check clear multiple items
	hashmap.set ("1", "1");
	hashmap.set ("2", "2");
	hashmap.set ("3", "3");
	assert (hashmap.size == 3);
	hashmap.clear ();
	assert (hashmap.size == 0);
}

void test_hashmap_empty () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);

	// Check empty map
	assert (hashmap.is_empty);

	// Check when one item
	hashmap.set ("1", "1");
	assert (!hashmap.is_empty);

	// Check when more items
	hashmap.set ("2", "2");
	assert (!hashmap.is_empty);

	// Check when items cleared
	hashmap.clear ();
	assert (hashmap.is_empty);
}

void test_hashmap_set_all () {
	var hashmap1 = new HashMap<string,string> (str_hash, str_equal, str_equal);
	var hashmap2 = new HashMap<string,string> (str_hash, str_equal, str_equal);

	hashmap1.set ("a", "1");
	hashmap1.set ("b", "2");
	hashmap1.set ("c", "3");
	hashmap2.set ("d", "4");
	hashmap2.set ("e", "5");
	hashmap2.set ("f", "6");

	hashmap1.set_all (hashmap2);

	assert (hashmap1.size == 6);
	assert (hashmap1.contains ("a"));
	assert (hashmap1.contains ("b"));
	assert (hashmap1.contains ("c"));
	assert (hashmap1.contains ("d"));
	assert (hashmap1.contains ("e"));
	assert (hashmap1.contains ("f"));

	assert (hashmap1.get ("a") == "1");
	assert (hashmap1.get ("b") == "2");
	assert (hashmap1.get ("c") == "3");
	assert (hashmap1.get ("d") == "4");
	assert (hashmap1.get ("e") == "5");
	assert (hashmap1.get ("f") == "6");
}

void test_hashmap_remove_all () {
	var map1 = new HashMap<string,string> (str_hash, str_equal, str_equal);
	var map2 = new HashMap<string,string> (str_hash, str_equal, str_equal);
	
	// Check remove all on empty maps.

	assert (map1.is_empty);
	assert (map2.is_empty);

	map1.remove_all (map2);	

	assert (map1.is_empty);
	assert (map2.is_empty);

	map1.clear ();
	map2.clear ();

	// Map1 is empty, map2 has entries. -> no change

	map2.set ("a", "1");
	map2.set ("b", "2");

	assert (map1.is_empty);
	assert (map2.size == 2);

	map1.remove_all (map2);	

	assert (map1.is_empty);
	assert (map2.size == 2);

	map1.clear ();
	map2.clear ();
	
	// Map1 has entries, map2 is empty. -> no change

	map1.set ("a", "1");
	map1.set ("b", "2");

	assert (map1.size == 2);
	assert (map2.is_empty);

	map1.remove_all (map2);	

	assert (map1.size == 2);
	assert (map2.is_empty);

	map1.clear ();
	map2.clear ();

	// Map1 and map2 have the same entries -> map1 is cleared

	map1.set ("a", "0");
	map1.set ("b", "1");
	map2.set ("a", "1");
	map2.set ("b", "0");

	assert (map1.size == 2);
	assert (map2.size == 2);

	map1.remove_all (map2);	

	assert (map1.is_empty);
	assert (map2.size == 2);

	map1.clear ();
	map2.clear ();

	// Map1 has some common keys with map2 but both have also unique keys -> common key are cleared from map1

	map1.set ("x", "2");
	map1.set ("a", "1");
	map1.set ("b", "1");
	map1.set ("y", "2");

	map2.set ("i", "100");
	map2.set ("a", "200");
	map2.set ("j", "300");
	map2.set ("b", "400");
	map2.set ("k", "500");

	assert (map1.size == 4);
	assert (map2.size == 5);

	map1.remove_all (map2);	

	assert (map1.size == 2);
	assert (map2.size == 5);
	
	assert (map1.contains ("x"));
	assert (map1.contains ("y"));

	map1.clear ();
	map2.clear ();

}

void test_hashmap_contains_all() {
	var map1 = new HashMap<string,string> (str_hash, str_equal, str_equal);
	var map2 = new HashMap<string,string> (str_hash, str_equal, str_equal);

	// Check empty.
	assert (map1.contains_all (map2));

	// Map1 has items, map2 is empty.
	
	map1.set ("1", "1");

	assert (map1.contains_all (map2));

	map1.clear ();
	map2.clear ();

	// Map1 is empty, map2 has items.
	
	map2.set ("1", "1");

	assert (!map1.contains_all (map2));

	map1.clear ();
	map2.clear ();

	// Map1 and map2 are the same.
	
	map1.set ("1", "a");
	map1.set ("2", "b");

	map2.set ("1", "c");
	map2.set ("2", "d");

	assert (map1.contains_all (map2));

	map1.clear ();
	map2.clear ();

	// Map1 and map2 are not the same
	map1.set ("1", "a");
	map2.set ("2", "b");

	assert (!map1.contains_all (map2));

	map1.clear ();
	map2.clear ();

	// Map1 has a subset of map2
	map1.set ("1", "a");
	map1.set ("2", "b");
	map1.set ("3", "c");
	map1.set ("4", "d");
	map1.set ("5", "e");
	map1.set ("6", "f");

	map2.set ("2", "g");
	map2.set ("4", "h");
	map2.set ("6", "i");

	assert (map1.contains_all (map2));

	map1.clear ();
	map2.clear ();

	// Map1 has a subset of map2 in all but one element map2
	map1.set ("1", "a");
	map1.set ("2", "b");
	map1.set ("3", "c");
	map1.set ("4", "d");
	map1.set ("5", "e");
	map1.set ("6", "f");

	map2.set ("2", "g");
	map2.set ("4", "h");
	map2.set ("6", "i");
	map2.set ("7", "j");

	assert (!map1.contains_all (map2));

	map1.clear ();
	map2.clear ();
}

void main (string[] args) {
	Test.init (ref args);

	// Methods of Map interface
	Test.add_func ("/HashMap/Map/get", test_hashmap_get);
	Test.add_func ("/HashMap/Map/set", test_hashmap_set);
	Test.add_func ("/HashMap/Map/remove", test_hashmap_remove);
	Test.add_func ("/HashMap/Map/contains", test_hashmap_contains);
	Test.add_func ("/HashMap/Map/size", test_hashmap_size);
	Test.add_func ("/HashMap/Map/get_keys", test_hashmap_get_keys);
	Test.add_func ("/HashMap/Map/get_values", test_hashmap_get_values);
	Test.add_func ("/HashMap/Map/clear", test_hashmap_clear);
	Test.add_func ("/HashMap/Map/empty", test_hashmap_empty);
	Test.add_func ("/HashMap/Map/set_all", test_hashmap_set_all);
	Test.add_func ("/HashMap/Map/remove_all", test_hashmap_remove_all);
	Test.add_func ("/HashMap/Map/contains_all", test_hashmap_contains_all);

	Test.run ();
}

