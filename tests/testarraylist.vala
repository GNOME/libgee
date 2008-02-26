/* testarraylist.vala
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

void test_arraylist_int_add () {
	var arraylist = new ArrayList<int> ();

	arraylist.add (42);
	assert (arraylist.contains (42));
	assert (arraylist.size == 1);
}

void test_arraylist_int_iterator () {
	var arraylist = new ArrayList<int> ();
	arraylist.add (42);

	var it = arraylist.iterator ();
	assert (it.next ());
	assert (it.get () == 42);
	assert (!it.next ());
}

void test_arraylist_int_remove () {
	var arraylist = new ArrayList<int> ();
	arraylist.add (42);

	arraylist.remove (42);
	assert (!arraylist.contains (42));
	assert (arraylist.size == 0);
}

void test_arraylist_string_add () {
	var arraylist = new ArrayList<string> (str_equal);

	arraylist.add ("hello");
	assert (arraylist.contains ("hello"));
	assert (arraylist.size == 1);
}

void test_arraylist_string_iterator () {
	var arraylist = new ArrayList<string> (str_equal);
	arraylist.add ("hello");

	var it = arraylist.iterator ();
	assert (it.next ());
	assert (it.get () == "hello");
	assert (!it.next ());
}

void test_arraylist_string_remove () {
	var arraylist = new ArrayList<string> (str_equal);
	arraylist.add ("hello");

	arraylist.remove ("hello");
	assert (!arraylist.contains ("hello"));
	assert (arraylist.size == 0);
}

void main (string[] args) {
	Test.init (ref args);

	Test.add_func ("/arraylist/int/add", test_arraylist_int_add);
	Test.add_func ("/arraylist/int/iterator", test_arraylist_int_iterator);
	Test.add_func ("/arraylist/int/remove", test_arraylist_int_remove);

	Test.add_func ("/arraylist/string/add", test_arraylist_string_add);
	Test.add_func ("/arraylist/string/iterator", test_arraylist_string_iterator);
	Test.add_func ("/arraylist/string/remove", test_arraylist_string_remove);

	Test.run ();
}

