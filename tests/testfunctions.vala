/* testfunctions.vala
 *
 * Copyright (C) 2010  Maciej Piechotka
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

public class FunctionsTests : Gee.TestCase {
	public FunctionsTests () {
		base ("Functions");
		add_test ("[Functions] comparing and hashing strings", test_string_func);
		add_test ("[Functions] comparing and hashing int", test_int_func);
		add_test ("[Functions] comparing instances of Comparable", test_compare_func);
		add_test ("[Functions] comparing and hashing instances of Hashable", test_hash_func);
		add_test ("[Iterator] unfold", test_unfold);
		add_test ("[Iterator] concat", test_concat);
	}

	public void test_string_func () {
		string one = "one";
		string two = "two";
		string two_copy = two.dup ();

		Gee.EqualDataFunc<string> eq = Gee.Functions.get_equal_func_for (typeof (string));
		CompareDataFunc<string> cmp = Gee.Functions.get_compare_func_for (typeof (string));
		Gee.HashDataFunc<string> hash = Gee.Functions.get_hash_func_for (typeof (string));
		assert (eq != null);
		assert (cmp != null);
		assert (hash != null);

		assert (eq (two, two));
		assert (cmp (two, two) == 0);
		assert (hash (two) == hash (two));

		assert (eq (two, two_copy));
		assert (cmp (two, two_copy) == 0);
		assert (hash (two) == hash (two_copy));

		assert (!eq (one, two));
		assert (cmp (one, two) < 0);
		
		assert (!eq (two, one));
		assert (cmp (two, one) > 0);
	}

	public void test_int_func () {
		int one = 1;
		int two = 2;

		Gee.EqualDataFunc<int> eq = Gee.Functions.get_equal_func_for (typeof (int));
		CompareDataFunc<int> cmp = Gee.Functions.get_compare_func_for (typeof (int));
		Gee.HashDataFunc<int> hash = Gee.Functions.get_hash_func_for (typeof (int));

		assert (eq != null);
		assert (cmp != null);
		assert (hash != null);

		assert (eq (two, two));
		assert (cmp (two, two) == 0);
		assert (hash (two) == hash (two));

		assert (!eq (one, two));
		assert (cmp (one, two) < 0);
		
		assert (!eq (two, one));
		assert (cmp (two, one) > 0);
	}

	public void test_compare_func () {
		MyComparable two = new MyComparable(2);
		MyComparable one = new MyComparable(1);
		MyComparable two_copy = new MyComparable(2);

		Gee.EqualDataFunc<MyComparable> eq = Gee.Functions.get_equal_func_for (typeof (MyComparable));
		CompareDataFunc<MyComparable> cmp = Gee.Functions.get_compare_func_for (typeof (MyComparable));
		//Gee.HashDataFunc hash = Gee.Functions.get_hash_func_for (typeof (MyComparable));

		assert (eq != null);
		assert (cmp != null);
		//assert (hash != null);

		assert (eq (two, two));
		assert (cmp (two, two) == 0);
		//assert (hash (two) == hash (two));

		assert (eq (two, two_copy));
		assert (cmp (two, two_copy) == 0);
		//assert (hash (two) == hash (two_copy));

		assert (!eq (one, two));
		assert (cmp (one, two) < 0);
		
		assert (!eq (two, one));
		assert (cmp (two, one) > 0);
	}

	public void test_hash_func () {
		MyHashable two = new MyHashable(2);
		MyHashable one = new MyHashable(1);
		MyHashable two_copy = new MyHashable(2);
		MyHashable minus_one = new MyHashable(-1);
		MyHashable minus_one2 = new MyHashable(-1);

		Gee.EqualDataFunc<MyHashable> eq = Gee.Functions.get_equal_func_for (typeof (MyHashable));
		CompareDataFunc<MyHashable> cmp = Gee.Functions.get_compare_func_for (typeof (MyHashable));
		Gee.HashDataFunc<MyHashable> hash = Gee.Functions.get_hash_func_for (typeof (MyHashable));

		assert (eq != null);
		assert (cmp != null);
		assert (hash != null);

		assert (eq (two, two));
		assert (cmp (two, two) == 0);
		assert (hash (two) == hash (two));

		assert (eq (two, two_copy));
		assert (cmp (two, two_copy) == 0);
		assert (hash (two) == hash (two_copy));

		assert (!eq (one, two));
		assert (cmp (one, two) < 0);
		
		assert (!eq (two, one));
		assert (cmp (two, one) > 0);

		// Check if correct functions taken
		assert (hash (one) == 1);
		assert (!eq (minus_one, minus_one2));
	}

	public void test_unfold () {
		int i = 0;
		int j = -1;
		var iter = Gee.Iterator.unfold<int> (() => {
			assert (j + 1 == i);
			if (i == 10)
				return null;
			int k = i++;
			return new Gee.Lazy<int> (() => {
				assert (k + 1 == i);
				j = k;
				return k;
			});
		});
		int k = 0;
		while (iter.next ()) {
			assert (iter.get () == k);
			assert (iter.get () == k);
			k++;
		}
		assert (k == 10);
	}

	public void test_concat () {
		int i = 0;
		var iter_ = Gee.Iterator.unfold<Gee.Iterator<int>> (() => {
			if (i >= 3)
				return null;
			int j = i++*3;
			int start = j;
			var iter = Gee.Iterator.unfold<int> (() => {
				if (j == start + 3)
					return null;
				return new Gee.Lazy<int>.from_value (j++);
			});
			return new Gee.Lazy<Gee.Iterator<int>>.from_value (iter);
		});

		int j = 0;
		var iter = Gee.Iterator.concat<int> (iter_);
		while (iter.next()) {
			assert (j == iter.get ());
			assert (j == iter.get ());
			j++;
		}
		assert (i == 3);
		assert (j == 9);
	}

	private class MyComparable : GLib.Object, Gee.Comparable<MyComparable> {
		public MyComparable (int i) {
			this.i = i;
		}

		public int compare_to (MyComparable cmp) {
			if (i == cmp.i)
				return 0;
			else if (i >= cmp.i)
				return 1;
			else
				return -1;
		}

		int i;
	}

	private class MyHashable : GLib.Object, Gee.Comparable<MyHashable>, Gee.Hashable<MyHashable> {
		public MyHashable (int i) {
			this.i = i;
		}

		public int compare_to (MyHashable cmp) {
			if (i == cmp.i)
				return 0;
			else if (i >= cmp.i)
				return 1;
			else
				return -1;
		}

		public uint hash () {
			return i;
		}

		public bool equal_to (MyHashable hash) {
			// -1 break API but it is used for checks
			return i == hash.i && i != -1;
		}

		int i;
	}
}

