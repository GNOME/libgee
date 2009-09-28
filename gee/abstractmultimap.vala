/* abstractmultimap.vala
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
 * 	Didier 'Ptitjes Villevalois <ptitjes@free.fr>
 */

/**
 * Skeletal implementation of the {@link MultiMap} interface.
 *
 * @see HashMultiMap
 * @see TreeMultiMap
 */
public abstract class Gee.AbstractMultiMap<K,V> : Object, MultiMap<K,V> {
	public int size {
		get { return _nitems; }
	}

	protected Map<K, Collection<V>> _storage_map;
	private int _nitems = 0;
	private Set<V> _empty_value_set;

	public AbstractMultiMap (Map<K, Collection<V>> storage_map) {
		this._storage_map = storage_map;
		this._empty_value_set = Set.empty<V> ();
	}

	protected abstract Collection<V> create_value_storage ();

	protected abstract MultiSet<K> create_multi_key_set ();

	protected abstract EqualFunc get_value_equal_func ();

	public Set<K> get_keys () {
		return _storage_map.keys;
	}

	public MultiSet<K> get_all_keys () {
		MultiSet<K> result = create_multi_key_set ();
		foreach (var entry in _storage_map.entries) {
			for (int i = 0; i < entry.value.size; i++) {
				result.add (entry.key);
			}
		}
		return result;
	}

	public Collection<V> get_values () {
		var result = new ArrayList<V> (get_value_equal_func ());
		foreach (var entry in _storage_map.entries) {
			foreach (var value in entry.value) {
				result.add (value);
			}
		}
		return result;
	}

	public bool contains (K key) {
		return _storage_map.contains (key);
	}

	public new Collection<V> get (K key) {
		if (_storage_map.contains (key)) {
			return _storage_map.get (key).read_only_view;
		} else {
			return _empty_value_set;
		}
	}

	public new void set (K key, V value) {
		if (_storage_map.contains (key)) {
			if (_storage_map.get (key).add (value)) {
				_nitems++;
			}
		} else {
			var s = create_value_storage ();
			s.add (value);
			_storage_map.set (key, s);
			_nitems++;
		}
	}

	public bool remove (K key, V value) {
		if (_storage_map.contains (key)) {
			var values = _storage_map.get (key);
			if (values.contains (value)) {
				values.remove (value);
				_nitems--;
				if (values.size == 0) {
					_storage_map.remove (key);
				}
				return true;
			}
		}
		return false;
	}

	public bool remove_all (K key) {
		if (_storage_map.contains (key)) {
			int size = _storage_map.get (key).size;
			if (_storage_map.remove (key)) {
				_nitems -= size;
				return true;
			}
		}
		return false;
	}

	public void clear () {
		_storage_map.clear ();
		_nitems = 0;
	}
}
