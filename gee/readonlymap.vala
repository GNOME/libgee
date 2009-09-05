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
 * Read-only view for {@link Gee.Map} collections.
 *
 * This class decorates any class which implements the {@link Gee.Map} interface
 * by making it read only. Any method which normally modify data will throw an
 * error.
 *
 * @see Gee.Map
 */
public class Gee.ReadOnlyMap<K,V> : Object, Map<K,V> {

	/**
	 * @inheritDoc
	 */
	public int size {
		get { return _map.size; }
	}

	/**
	 * @inheritDoc
	 */
	public bool is_empty {
		get { return _map.is_empty; }
	}

	/**
	 * The decorated map.
	 */
	public Map<K,V> map {
		construct { _map = value; }
	}

	private Map<K,V> _map;

	/**
	 * Constructs a read-only map that mirrors the content of the specified map.
	 *
	 * @param map the map to decorate (may be null).
	 */
	public ReadOnlyMap (Map<K,V>? map = null) {
		this.map = map;
	}

	/**
	 * @inheritDoc
	 */
	public Set<K> get_keys () {
		if (_map == null) {
			return new ReadOnlySet<K> ();
		}

		return _map.get_keys ();
	}

	/**
	 * @inheritDoc
	 */
	public Collection<V> get_values () {
		if (_map == null) {
			return new ReadOnlyCollection<V> ();
		}

		return _map.get_values ();
	}

	/**
	 * @inheritDoc
	 */
	public bool contains (K key) {
		if (_map == null) {
			return false;
		}

		return _map.contains (key);
	}

	/**
	 * @inheritDoc
	 */
	public new V? get (K key) {
		if (_map == null) {
			return null;
		}

		return _map.get (key);
	}

	/**
	 * Unimplemented method (read only map).
	 */
	public new void set (K key, V value) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only map).
	 */
	public bool remove (K key, out V? value = null) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only map).
	 */
	public void clear () {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only map).
	 */
	public void set_all (Map<K,V> map) {
		assert_not_reached ();
	}

	/**
	 * Unimplemented method (read only map).
	 */
	public bool remove_all (Map<K,V> map) {
		assert_not_reached ();
	}

	/**
	 * @inheritDoc
	 */
	public bool contains_all (Map<K,V> map) {
		if (_map == null) {
			return false;
		}

		return _map.contains_all (map);
	}
}

