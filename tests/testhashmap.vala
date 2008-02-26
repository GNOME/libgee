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

void test_hashmap_int_int_remove () {
	var hashmap = new HashMap<int,int> ();
	hashmap.set (42, 23);

	hashmap.remove (42);
	assert (!hashmap.contains (42));
	assert (hashmap.size == 0);
}

void test_hashmap_int_int_set () {
	var hashmap = new HashMap<int,int> ();

	hashmap.set (42, 23);
	assert (hashmap.contains (42));
	assert (hashmap.get (42) == 23);
	assert (hashmap.size == 1);
}

void test_hashmap_string_string_remove () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);
	hashmap.set ("hello", "world");

	hashmap.remove ("hello");
	assert (!hashmap.contains ("hello"));
	assert (hashmap.size == 0);
}

void test_hashmap_string_string_set () {
	var hashmap = new HashMap<string,string> (str_hash, str_equal, str_equal);

	hashmap.set ("hello", "world");
	assert (hashmap.contains ("hello"));
	assert (hashmap.get ("hello") == "world");
	assert (hashmap.size == 1);
}

void main (string[] args) {
	Test.init (ref args);

	Test.add_func ("/hashmap/int-int/remove", test_hashmap_int_int_remove);
	Test.add_func ("/hashmap/int-int/set", test_hashmap_int_int_set);

	Test.add_func ("/hashmap/string-string/remove", test_hashmap_string_string_remove);
	Test.add_func ("/hashmap/string-string/set", test_hashmap_string_string_set);

	Test.run ();
}

