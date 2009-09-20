/* testcomparable.vala
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
 * Author:
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 */

using Gee;

public class ComparableTests : Gee.TestCase {

	public ComparableTests () {
		base("Comparable");
		add_test ("[Comparable] selected functions", test_selected_functions);
	}

	private class TestComparable : Object, Comparable<TestComparable> {
		public int _a;

		public TestComparable (int a) {
			_a = a;
		}

		public int compare_to (TestComparable object) {
			return _a - object._a;
		}
	}

	public void test_selected_functions () {
		TestComparable o1 = new TestComparable (10);
		TestComparable o2 = new TestComparable (20);

		CompareFunc compare = Functions.get_compare_func_for (typeof (TestComparable));
		assert (compare (o1, o2) < 0);

		o1._a = 42;
		assert (compare (o1, o2) > 0);
	}
}
