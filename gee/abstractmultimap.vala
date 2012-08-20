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
	
	public bool read_only {
		get { return false; }
	}

	protected Map<K, Collection<V>> _storage_map;
	private int _nitems = 0;
	private Set<V> _empty_value_set;

	public AbstractMultiMap (Map<K, Collection<V>> storage_map) {
		this._storage_map = storage_map;
		this._empty_value_set = Set.empty<V> ();
	}

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
		return _storage_map.has_key (key);
	}

	public new Collection<V> get (K key) {
		if (_storage_map.has_key (key)) {
			return _storage_map.get (key).read_only_view;
		} else {
			return _empty_value_set;
		}
	}

	public new void set (K key, V value) {
		if (_storage_map.has_key (key)) {
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
		if (_storage_map.has_key (key)) {
			var values = _storage_map.get (key);
			if (values.contains (value)) {
				values.remove (value);
				_nitems--;
				if (values.size == 0) {
					_storage_map.unset (key);
				}
				return true;
			}
		}
		return false;
	}

	public bool remove_all (K key) {
		if (_storage_map.has_key (key)) {
			int size = _storage_map.get (key).size;
			if (_storage_map.unset (key)) {
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

	public Gee.MapIterator<K, V> map_iterator () {
		return new MapIterator<K, V> (_storage_map.map_iterator ());
	}

	protected abstract Collection<V> create_value_storage ();

	protected abstract MultiSet<K> create_multi_key_set ();

	protected abstract EqualDataFunc<V> get_value_equal_func ();

	public Type key_type { get { return typeof(K); } }

	public Type value_type { get { return typeof(V); } }

	private class MappingIterator<K, V> : Object {
		protected Gee.MapIterator<K, Collection<V>> outer;
		protected Iterator<V>? inner = null;

		public MappingIterator (Gee.MapIterator<K, Collection<V>>? outer) {
			this.outer = outer;
		}

		public bool next () {
			if (inner.next ()) {
				return true;
			} else if (outer.next ()) {
				inner = outer.get_value ().iterator ();
				assert (inner.next ());
				return true;
			} else {
				return false;
			}
		}

		public bool has_next () {
			return inner.has_next () || outer.has_next ();
		}

		public void remove () {
			assert_not_reached ();
		}

		public virtual bool read_only {
			get {
				return true;
			}
		}

		public void unset () {
			inner.remove ();
			if (outer.get_value ().is_empty) {
				outer.unset ();
			}
		}

		public bool valid {
			get {
				return inner != null && inner.valid;
			}
		}
	}

	private class MapIterator<K, V> : MappingIterator<K, V>, Gee.MapIterator<K, V> {
		public MapIterator (Gee.MapIterator<K, Collection<V>>? outer) {
			base (outer);
		}

		public K get_key () {
			assert (valid);
			return outer.get_key ();
		}

		public V get_value () {
			assert (valid);
			return inner.get ();
		}

		public void set_value (V value) {
			assert_not_reached ();
		}

		public bool mutable { get { return false; } }
	}

	// Future-proofing
	internal virtual void reserved0() {}
	internal virtual void reserved1() {}
	internal virtual void reserved2() {}
	internal virtual void reserved3() {}
	internal virtual void reserved4() {}
	internal virtual void reserved5() {}
	internal virtual void reserved6() {}
	internal virtual void reserved7() {}
	internal virtual void reserved8() {}
	internal virtual void reserved9() {}
}
