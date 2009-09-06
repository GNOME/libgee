/* readonlymap.vala
 *
 * Copyright (C) 2007-2008  Jürg Billeter
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
 * 	Jürg Billeter <j@bitron.ch>
 */

using GLib;

/**
 * Represents a read-only collection of key/value pairs.
 */
public class Gee.ReadOnlyMap<K,V> : Object, Map<K,V> {
	public int size {
		get { return _map.size; }
	}

	public bool is_empty {
		get { return _map.is_empty; }
	}

	private Map<K,V> _map;

	public ReadOnlyMap (Map<K,V>? map = null) {
		this._map = map;
	}

	public Set<K> get_keys () {
		if (_map == null) {
			return new ReadOnlySet<K> ();
		}

		return _map.get_keys ();
	}

	public Collection<V> get_values () {
		if (_map == null) {
			return new ReadOnlyCollection<V> ();
		}

		return _map.get_values ();
	}

	public bool contains (K key) {
		if (_map == null) {
			return false;
		}

		return _map.contains (key);
	}

	public new V? get (K key) {
		if (_map == null) {
			return null;
		}

		return _map.get (key);
	}

	public new void set (K key, V value) {
		assert_not_reached ();
	}

	public bool remove (K key, out V? value = null) {
		assert_not_reached ();
	}

	public void clear () {
		assert_not_reached ();
	}

	public void set_all (Map<K,V> map) {
		assert_not_reached ();
	}

	public bool remove_all (Map<K,V> map) {
		assert_not_reached ();
	}

	public bool contains_all (Map<K,V> map) {
		if (_map == null) {
			return false;
		}

		return _map.contains_all (map);
	}
}

