/* hashmultimap.vala
 *
 * Copyright (C) 2009  Ali Sabil
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
 * 	Ali Sabil <ali.sabil@gmail.com>
 */

/**
 * Hash table implementation of the {@link MultiMap} interface.
 */
public class Gee.HashMultiMap<K,V> : AbstractMultiMap<K,V> {
	public HashFunc key_hash_func {
		get { return ((HashMap<K, Set<V>>) _storage_map).key_hash_func; }
	}

	public EqualFunc key_equal_func {
		get { return ((HashMap<K, Set<V>>) _storage_map).key_equal_func; }
	}

	public HashFunc value_hash_func { private set; get; }

	public EqualFunc value_equal_func { private set; get; }

	public HashMultiMap (HashFunc? key_hash_func = null, EqualFunc? key_equal_func = null, HashFunc? value_hash_func = null, EqualFunc? value_equal_func = null) {
		base (new HashMap<K, Set<V>> (key_hash_func, key_equal_func, direct_equal));
		if (value_hash_func == null) {
			value_hash_func = Functions.get_hash_func_for (typeof (V));
		}
		if (value_equal_func == null) {
			value_equal_func = Functions.get_equal_func_for (typeof (V));
		}
		this.value_hash_func = value_hash_func;
		this.value_equal_func = value_equal_func;
	}

	protected override Collection<V> create_value_storage () {
		return new HashSet<V> (_value_hash_func, _value_equal_func);
	}

	protected override MultiSet<K> create_multi_key_set () {
		return new HashMultiSet<K> (key_hash_func, key_equal_func);
	}

	protected override EqualFunc get_value_equal_func () {
		return _value_equal_func;
	}
}
