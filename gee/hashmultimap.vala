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
 * A MultiMap implemented using a HashMap of Sets
 */
public class Gee.HashMultiMap<K,V> : GLib.Object, MultiMap<K,V> {
	public int size {
		get { return _nitems; }
	}

	public HashFunc key_hash_func { private set; get; }

	public EqualFunc key_equal_func { private set; get; }

	public HashFunc value_hash_func { private set; get; }

	public EqualFunc value_equal_func { private set; get; }

	private Map<K, Collection<V>> _items;
	private int _nitems = 0;
	private Set<V> _empty_value_set;

	public HashMultiMap (HashFunc? key_hash_func = null, EqualFunc? key_equal_func = null, HashFunc? value_hash_func = null, EqualFunc? value_equal_func = null) {
		if (key_hash_func == null) {
			key_hash_func = Functions.get_hash_func_for (typeof (K));
		}
		if (key_equal_func == null) {
			key_equal_func = Functions.get_equal_func_for (typeof (K));
		}
		if (value_hash_func == null) {
			value_hash_func = Functions.get_hash_func_for (typeof (V));
		}
		if (value_equal_func == null) {
			value_equal_func = Functions.get_equal_func_for (typeof (V));
		}
		this.key_hash_func = key_hash_func;
		this.key_equal_func = key_equal_func;
		this.value_hash_func = value_hash_func;
		this.value_equal_func = value_equal_func;
		this._items = new HashMap<K, Set<V>> (key_hash_func, key_equal_func, direct_equal);
		this._empty_value_set = new ReadOnlySet<V> (new HashSet<V> (_value_hash_func, _value_equal_func));
	}

	public Set<K> get_keys () {
		return _items.keys;
	}

	public MultiSet<K> get_all_keys () {
		MultiSet<K> result = new HashMultiSet<K> (_key_hash_func, _key_equal_func);
		foreach (var entry in _items.entries) {
			for (int i = 0; i < entry.value.size; i++) {
				result.add (entry.key);
			}
		}
		return result;
	}

	public Collection<V> get_values () {
		var result = new ArrayList<V> (_value_equal_func);
		foreach (var entry in _items.entries) {
			foreach (var value in entry.value) {
				result.add (value);
			}
		}
		return result;
	}

	public bool contains (K key) {
		return _items.contains (key);
	}

	public new Collection<V> get (K key) {
		if (_items.contains (key)) {
			return new ReadOnlyCollection<V> (_items.get (key));
		} else {
			return _empty_value_set;
		}
	}

	public new void set (K key, V value) {
		if (_items.contains (key)) {
			if (_items.get (key).add (value)) {
				_nitems++;
			}
		} else {
			var s = new HashSet<V> (_value_hash_func, _value_equal_func);
			s.add (value);
			_items.set (key, s);
			_nitems++;
		}
	}

	public bool remove (K key, V value) {
		if (_items.contains (key)) {
			var values = _items.get (key);
			if (values.contains (value)) {
				values.remove (value);
				_nitems--;
				if (values.size == 0) {
					_items.remove (key);
				}
				return true;
			}
		}
		return false;
	}

	public bool remove_all (K key) {
		if (_items.contains (key)) {
			int size = _items.get (key).size;
			if (_items.remove (key)) {
				_nitems -= size;
				return true;
			}
		}
		return false;
	}

	public void clear () {
		_items.clear ();
		_nitems = 0;
	}
}
