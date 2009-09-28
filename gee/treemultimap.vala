/* treemultimap.vala
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
 * 	Didier 'Ptitjes Villevalois <ptitjes@free.fr>
 */

/**
 * Left-leaning red-black tree implementation of the {@link MultiMap}
 * interface.
 */
public class Gee.TreeMultiMap<K,V> : AbstractMultiMap<K,V> {
	public CompareFunc key_compare_func {
		get { return ((TreeMap<K, Set<V>>) _storage_map).key_compare_func; }
	}

	public CompareFunc value_compare_func { private set; get; }

	public TreeMultiMap (CompareFunc? key_compare_func = null, CompareFunc? value_compare_func = null) {
		base (new TreeMap<K, Set<V>> (key_compare_func, direct_equal));
		if (value_compare_func == null) {
			value_compare_func = Functions.get_compare_func_for (typeof (V));
		}
		this.value_compare_func = value_compare_func;
	}

	protected override Collection<V> create_value_storage () {
		return new TreeSet<V> (_value_compare_func);
	}

	protected override MultiSet<K> create_multi_key_set () {
		return new TreeMultiSet<K> (key_compare_func);
	}

	protected override EqualFunc get_value_equal_func () {
		return Functions.get_equal_func_for (typeof (V));
	}
}
