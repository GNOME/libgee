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
 * Skeletal implementation of the {@link Collection} interface.
 *
 * Contains common code shared by all collection implementations.
 *
 * @see AbstractList
 * @see AbstractSet
 * @see AbstractMultiSet
 */
public abstract class Gee.AbstractCollection<G> : Object, Iterable<G>, Collection<G> {

	/**
	 * {@inheritDoc}
	 */
	public abstract int size { get; }

	/**
	 * {@inheritDoc}
	 */
	public virtual bool is_empty {
		get { return size == 0; }
	}

	/**
	 * {@inheritDoc}
	 */
	public abstract bool read_only { get; }

	/**
	 * {@inheritDoc}
	 */
	public abstract bool contains (G item);

	/**
	 * {@inheritDoc}
	 */
	public abstract bool add (G item);

	/**
	 * {@inheritDoc}
	 */
	public abstract bool remove (G item);

	/**
	 * {@inheritDoc}
	 */
	public abstract void clear ();

	/**
	 * {@inheritDoc}
	 */
	public virtual G[] to_array () {
		var t = typeof (G);
		if (t == typeof (bool)) {
			return (G[]) to_bool_array((Collection<bool>) this);
		} else if (t == typeof (char)) {
			return (G[]) to_char_array((Collection<char>) this);
		} else if (t == typeof (uchar)) {
			return (G[]) to_uchar_array((Collection<uchar>) this);
		} else if (t == typeof (int)) {
			return (G[]) to_int_array((Collection<int>) this);
		} else if (t == typeof (uint)) {
			return (G[]) to_uint_array((Collection<uint>) this);
		} else if (t == typeof (int64)) {
			return (G[]) to_int64_array((Collection<int64>) this);
		} else if (t == typeof (uint64)) {
			return (G[]) to_uint64_array((Collection<uint64>) this);
		} else if (t == typeof (long)) {
			return (G[]) to_long_array((Collection<long>) this);
		} else if (t == typeof (ulong)) {
			return (G[]) to_ulong_array((Collection<ulong>) this);
		} else if (t == typeof (float)) {
			return (G[]) to_float_array((Collection<float>) this);
		} else if (t == typeof (double)) {
			return (G[]) to_double_array((Collection<double>) this);
		} else {
			G[] array = new G[size];
			int index = 0;
			foreach (G element in this) {
				array[index++] = element;
			}
			return array;
		}
	}

	private static bool[] to_bool_array(Collection<bool> coll) {
		bool[] array = new bool[coll.size];
		int index = 0;
		foreach (bool element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static char[] to_char_array(Collection<char> coll) {
		char[] array = new char[coll.size];
		int index = 0;
		foreach (char element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static uchar[] to_uchar_array(Collection<uchar> coll) {
		uchar[] array = new uchar[coll.size];
		int index = 0;
		foreach (uchar element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static int[] to_int_array(Collection<int> coll) {
		int[] array = new int[coll.size];
		int index = 0;
		foreach (int element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static uint[] to_uint_array(Collection<uint> coll) {
		uint[] array = new uint[coll.size];
		int index = 0;
		foreach (uint element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static int64[] to_int64_array(Collection<int64?> coll) {
		int64[] array = new int64[coll.size];
		int index = 0;
		foreach (int64 element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static uint64[] to_uint64_array(Collection<uint64?> coll) {
		uint64[] array = new uint64[coll.size];
		int index = 0;
		foreach (uint64 element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static long[] to_long_array(Collection<long> coll) {
		long[] array = new long[coll.size];
		int index = 0;
		foreach (long element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static ulong[] to_ulong_array(Collection<ulong> coll) {
		ulong[] array = new ulong[coll.size];
		int index = 0;
		foreach (ulong element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static float[] to_float_array(Collection<float?> coll) {
		float[] array = new float[coll.size];
		int index = 0;
		foreach (float element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static double[] to_double_array(Collection<double?> coll) {
		double[] array = new double[coll.size];
		int index = 0;
		foreach (double element in coll) {
			array[index++] = element;
		}
		return array;
	}

	/**
	 * {@inheritDoc}
	 */
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

	/**
	 * {@inheritDoc}
	 */
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

	/**
	 * {@inheritDoc}
	 */
	public virtual bool remove_all (Collection<G> collection) {
		bool changed = false;
		foreach (G item in collection) {
			changed = changed | remove (item);
		}
		return changed;
	}

	/**
	 * {@inheritDoc}
	 */
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

	/**
	 * {@inheritDoc}
	 */
	public Type element_type {
		get { return typeof (G); }
	}

	/**
	 * {@inheritDoc}
	 */
	public abstract Iterator<G> iterator ();

	private weak Collection<G> _read_only_view;

	/**
	 * {@inheritDoc}
	 */
	public virtual Collection<G> read_only_view {
		owned get {
			Collection<G> instance = _read_only_view;
			if (_read_only_view == null) {
				instance = new ReadOnlyCollection<G> (this);
				_read_only_view = instance;
				instance.add_weak_pointer ((void**) (&_read_only_view));
			}
			return instance;
		}
	}
}
