/* testhashset.vala
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

void test_hashset_int_add () {
	var hashset = new HashSet<int> ();

	hashset.add (42);
	assert (hashset.contains (42));
	assert (hashset.size == 1);
}

void test_hashset_int_iterator () {
	var hashset = new HashSet<int> ();
	hashset.add (42);

	var it = hashset.iterator ();
	assert (it.next ());
	assert (it.get () == 42);
	assert (!it.next ());
}

void test_hashset_int_remove () {
	var hashset = new HashSet<int> ();
	hashset.add (42);

	hashset.remove (42);
	assert (!hashset.contains (42));
	assert (hashset.size == 0);
}

void test_hashset_string_add () {
	var hashset = new HashSet<string> (str_hash, str_equal);

	hashset.add ("hello");
	assert (hashset.contains ("hello"));
	assert (hashset.size == 1);
}

void test_hashset_string_iterator () {
	var hashset = new HashSet<string> (str_hash, str_equal);
	hashset.add ("hello");

	var it = hashset.iterator ();
	assert (it.next ());
	assert (it.get () == "hello");
	assert (!it.next ());
}

void test_hashset_string_remove () {
	var hashset = new HashSet<string> (str_hash, str_equal);
	hashset.add ("hello");

	hashset.remove ("hello");
	assert (!hashset.contains ("hello"));
	assert (hashset.size == 0);
}

void main (string[] args) {
	Test.init (ref args);

	Test.add_func ("/hashset/int/add", test_hashset_int_add);
	Test.add_func ("/hashset/int/iterator", test_hashset_int_iterator);
	Test.add_func ("/hashset/int/remove", test_hashset_int_remove);

	Test.add_func ("/hashset/string/add", test_hashset_string_add);
	Test.add_func ("/hashset/string/iterator", test_hashset_string_iterator);
	Test.add_func ("/hashset/string/remove", test_hashset_string_remove);

	Test.run ();
}

