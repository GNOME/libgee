/* testcollection.vala
 *
 * Copyright (C) 2012  Maciej Piechotka
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
 *      Maciej Piechotka <uzytkownik2@gmail.com>
 */
public class TestData {
	private static string?[] ones = {null, "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"};
	private static string[] tens = {null, null, "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"};
	private static string hundred = "hundred";
	private static string?[] thousands = {null, "thousand", "million", "billion", "trillion"};

	private static uint data_size () {
		return Test.quick() ? 128 : 1024;
	}

	private static uint DATA_SIZE = data_size ();
	private const uint RND_IDX_SIZE = 8;

	private static string[] data = create_data (DATA_SIZE);
	private static string[] sorted_data = sort_array (data);
	private static uint[] random_idx = draw_numbers(DATA_SIZE, RND_IDX_SIZE);

	public static unowned string[] get_data () {
		TypeClass klass = typeof (TestData).class_ref ();
		klass.get_type ();
		return data;
	}

	public static unowned string[] get_sorted_data () {
		TypeClass klass = typeof (TestData).class_ref ();
		klass.get_type ();
		return sorted_data;
	}

	public static unowned uint[] get_drawn_numbers () {
		TypeClass klass = typeof (TestData).class_ref ();
		klass.get_type ();
		return random_idx;
	}

	private static uint[] draw_numbers (uint n, uint k) {
		uint[] result = new uint[n];
		// Initialize array
		for (uint i = 0; i < n; i++) {
			result[i] = i;
		}
		// Fisher-Yates shuffle algorithm. Possibly not the most efficient implementation but oh well
		for (uint i = n - 1; i >= 1; i--) {
			int j = Test.rand_int_range (0, (int32)(i + 1));
			uint tmp = result[i];
			result[i] = result[j];
			result[j] = tmp;
		}
		result.resize ((int)k);
		return (owned)result;
	}

	private static string print3digit (uint n) {
		string? h = (n >= 200) ? "%s %s".printf(ones[n / 100], hundred) : ((n >= 100) ? hundred : null);
		n = n % 100;
		unowned string? t = tens[n / 10];
		n = (n >= ones.length) ? n % 10 : n;
		unowned string? o = ones[n];
		return "%s%s%s%s%s".printf(h != null ? h : "", h != null && (t != null || o != null) ? " " : "", t != null ? t : "", t != null && o != null ? "-" : "", o != null ? o : "");
	}

	private static string[] create_data (uint count) {
		string[] numbers = new string[count];
		for (uint idx = 0; idx < count; idx++) {
			uint n = idx + 1;
			string? num = null;
			uint th = 0;
			while (n != 0) {
				if (n % 1000 != 0) {
					string? t = thousands[th];
					string c = print3digit (n % 1000);
					num = "%s%s%s%s%s".printf(c, t != null ? " " : "", t != null ? t : "", num != null ? " " : "", num != null ? num : "");
				}
				n /= 1000;
				th++;
			}
			if (num == null) {
				num = "zero";
			}
			numbers[idx] = (owned)num;
		}
		return (owned)numbers;
	}

	private static string[] sort_array (owned string[] array) {
		qsort_with_data<string> (array, sizeof(string), (a, b) => {return strcmp(a, b);});
		return (owned)array;
	}
}

