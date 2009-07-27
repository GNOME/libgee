/* testcollection.vala
 *
 * Copyright (C) 2008  Jürg Billeter
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
 * Author:
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 */

using GLib;
using Gee;

public abstract class CollectionTests : TestFixture {

	public CollectionTests (string name) {
		base(name);
		add_test ("Collection.to_array ", test_to_array);
	}

	protected Collection<int> int_collection;
	protected Collection<string> string_collection;
	protected Collection<Object> object_collection;

	public void test_to_array() {
		string_collection.add ("42");
		string_collection.add ("43");
		string_collection.add ("44");

		string[] array = (string[]) string_collection.to_array ();
		assert (array[0] == "42");
		assert (array[1] == "43");
		assert (array[2] == "44");	
	}
}
