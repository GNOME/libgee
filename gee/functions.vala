/* functions.vala
 *
 * Copyright (C) 2009  Didier Villevalois, Maciej Piechotka
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
 * 	Maciej Piechotka <uzytkownik2@gmail.com>
 */

using GLib;

namespace Gee {

	/**
	 * Helpers for equal, hash and compare functions.
	 *
	 * With those functions, you can retrieve the equal, hash and compare
	 * functions that best match your element, key or value types. Supported
	 * types are (non-boxed) primitive, string and `Object` types.
	 *
	 * A special care is taken for classes inheriting from the
	 * {@link Comparable} interface. For such types, an appropriate compare
	 * function is returned that calls {@link Comparable.compare_to}.
	 *
	 */
	namespace Functions {

		/**
		 * Get a equality testing function for a given type.
		 *
		 * @param t the type which to get an equality testing function for.
		 *
		 * @return the equality testing function corresponding to the given type.
		 */
		public static EqualFunc get_equal_func_for (Type t) {
			if (t == typeof (string)) {
				return str_equal;
			} else {
				return direct_equal;
			}
		}

		/**
		 * Get a hash function for a given type.
		 *
		 * @param t the type which to get the hash function for.
		 *
		 * @return the hash function corresponding to the given type.
		 */
		public static HashFunc get_hash_func_for (Type t) {
			if (t == typeof (string)) {
				return str_hash;
			} else {
				return direct_hash;
			}
		}

		/**
		 * Get a comparator function for a given type.
		 *
		 * @param t the type which to get a comparator function for.
		 *
		 * @return the comparator function corresponding to the given type.
		 */
		public static CompareFunc get_compare_func_for (Type t) {
			if (t == typeof (string)) {
				return (CompareFunc) strcmp;
			} else if (t.is_a (typeof (Comparable))) {
				return (CompareFunc) Comparable.compare_to;
			} else {
				return (CompareFunc) direct_compare;
			}
		}
	}

	/**
	 * Compares two arbitrary elements together.
	 *
	 * The comparison is done on pointers and not on values behind.
	 *
	 * @param _val1 the first value to compare.
	 * @param _val2 the second value to compare.
	 *
	 * @return a negative value if _val1 is lesser than _val2, a positive value
	 *         if _val1 is greater then _val2 and zero if both are equal.
	 */
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
