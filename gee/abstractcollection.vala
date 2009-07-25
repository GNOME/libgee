/* abstractcollection.vala
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
 * 	Didier 'Ptitjes' Villevalois <ptitjes@free.fr>
 */

/**
 * Serves as the base class for implementing collection classes.
 */
public abstract class Gee.AbstractCollection<G> : Object, Iterable<G>, Collection<G> {

	//
	// Inherited from Collection<G>
	//

	public abstract int size { get; }

	public virtual bool is_empty {
		get { return size == 0; }
	}

	public abstract bool contains (G item);

	public abstract bool add (G item);

	public abstract bool remove (G item);

	public abstract void clear ();

	public virtual G[] to_array() {
		G[] array = new G[size];
		int index = 0;
		foreach (G element in this) {
			array[index++] = element;
		}
		return array;
	}

	public virtual bool add_all (Collection<G> collection) {
		if (collection.is_empty) {
			return false;
		}

		bool changed = false;
		foreach (G item in collection) {
			changed = changed | add (item);
		}
		return changed;
	}

	public virtual bool contains_all (Collection<G> collection) {
		if (collection.size > size) {
			return false;
		}

		foreach (G item in collection) {
			if (!contains (item)) {
				return false;
			}
		}
		return true;
	}

	public virtual bool remove_all (Collection<G> collection) {
		bool changed = false;
		foreach (G item in collection) {
			changed = changed | remove (item);
		}
		return changed;
	}

	public virtual bool retain_all (Collection<G> collection) {
		bool changed = false;
		G[] items = to_array ();
		int size_of_items = size;
		for (int index = 0; index < size_of_items; index++) {
			if (!collection.contains (items[index])) {
				changed = changed | remove (items[index]);
			} 
		}
		return changed;
	}

	//
	// Inherited from Iterable<G>
	//

	public Type element_type {
		get { return typeof (G); }
	}

	public abstract Iterator<G> iterator ();
}
