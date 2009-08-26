/* functions.vala
 *
 * Copyright (C) 2009  Maciej Piechotka
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

namespace Gee {

	public class Functions {

		public static EqualFunc get_equal_func_for (Type t) {
			if (t == typeof (string)) {
				return str_equal;
			} else {
				return direct_equal;
			}
		}

		public static HashFunc get_hash_func_for (Type t) {
			if (t == typeof (string)) {
				return str_hash;
			} else {
				return direct_hash;
			}
		}

		public static CompareFunc get_compare_func_for (Type t) {
			if (t == typeof (string)) {
				return (CompareFunc) strcmp;
			} else {
				return direct_compare;
			}
		}
	}

	public static int direct_compare (void* _val1, void* _val2) {
		long val1 = (long)_val1, val2 = (long)_val2;
		if (val1 > val2) {
			return 1;
		} else if (val1 == val2) {
			return 0;
		} else {
			return -1;
		}
	}
}
