/* abstractmap.vala
 *
 * Copyright (C) 2007  Jürg Billeter
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
 * 	Tomaž Vajngerl <quikee@gmail.com>
 */
 
 /**
 * Serves as the base class for implementing map classes.
 */
public abstract class Gee.AbstractMap<K,V> : Object, Map<K,V> {

	/**
	 * @inheritDoc
	 */
	public abstract int size { get; }

	/**
	 * @inheritDoc
	 */
	public virtual bool is_empty {
		get { return size == 0; }
	}

	/**
	 * @inheritDoc
	 */
	public abstract Set<K> get_keys ();

	/**
	 * @inheritDoc
	 */
	public abstract Collection<V> get_values ();

	/**
	 * @inheritDoc
	 */
	public abstract bool contains (K key);

	/**
	 * @inheritDoc
	 */
	public abstract new V? get (K key);

	/**
	 * @inheritDoc
	 */
	public abstract new void set (K key, V value);

	/**
	 * @inheritDoc
	 */
	public abstract bool remove (K key, out V? value = null);

	/**
	 * @inheritDoc
	 */
	public abstract void clear ();

	/**
	 * @inheritDoc
	 */
	public virtual void set_all (Map<K,V> map) {
		foreach (K key in map.get_keys ()) {
			set (key, map.get (key));
		}
	}

	/**
	 * @inheritDoc
	 */
	public virtual bool remove_all (Map<K,V> map) {
		bool changed = false;
		foreach (K key in map.get_keys ()) {
			changed = changed | remove (key);
		}
		return changed;
	}

	/**
	 * @inheritDoc
	 */
	public virtual bool contains_all (Map<K,V> map) {
		foreach (K key in map.get_keys ()) {
			if (!contains (key)) {
				return false;
			}
		}
		return true;
	}
}
