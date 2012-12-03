/* concurrentset.vala
 *
 * Copyright (C) 2012  Maciej Piechotka
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
 * 	Maciej Piechotka <uzytkownik2@gmail.com>
 */

/**
 * A skip-linked list. This implementation is based on
 * [[http://www.cse.yorku.ca/~ruppert/Mikhail.pdf|Mikhail Fomitchev Master Thesis]].
 *
 * Many threads are allowed to operate on the same structure as well as modification
 * of structure during iteration is allowed. However the change may not be immidiatly
 * visible to other threads.
 */
public class Gee.ConcurrentSet<G> : AbstractSet<G> {
	public ConcurrentSet (owned CompareDataFunc<G>? compare_func = null) {
		if (compare_func == null) {
			compare_func = Functions.get_compare_func_for (typeof (G));
		}
		_cmp = compare_func;
	}

	~ConcurrentSet () {
		HazardPointer.Context ctx = new HazardPointer.Context ();
		_head = null;
	}

	public override int size { get { return GLib.AtomicInt.get (ref _size); } }

	public override bool read_only { get { return false; } }

	public override Gee.Iterator<G> iterator () {
		return new Iterator<G> (this, _head);
	}

	public override bool contains (G key) {
		HazardPointer.Context ctx = new HazardPointer.Context ();
		Tower<G> prev = _head;
		return Tower.search<G> (_cmp, key, ref prev, null);
	}

	public override bool add (G key) {
		HazardPointer.Context ctx = new HazardPointer.Context ();
		Rand *rnd = rand.get ();
		if (rnd == null) {
			rand.set (rnd = new Rand ());
		}
		uint32 rand_int = rnd->int_range (0, int32.MAX);
		uint8 height = 1 + (uint8)GLib.Bit.nth_lsf (~rand_int, -1);
		Tower<G> prev = _head;
		if (Tower.search<G> (_cmp, key, ref prev, null, height - 1)) {
			return false;
		}
		Tower<G>? result = Tower.insert<G> (_cmp, ref prev, key, height - 1);
		if (result != null) {
			GLib.AtomicInt.inc (ref _size);
		}
		return result != null;
	}

	public override bool remove (G item) {
		HazardPointer.Context ctx = new HazardPointer.Context ();
		bool result = Tower.remove_key<G> (_cmp, _head, item);
		if (result) {
			GLib.AtomicInt.dec_and_test (ref _size);
		}
		return result;
	}

	public override void clear () {
		HazardPointer.Context ctx = new HazardPointer.Context ();
		Tower<G>? first;
		while ((first = _head.get_next (0)) != null) {
			remove (first._data);
		}
	}

#if DEBUG
	public void dump () {
		for (int i = _MAX_HEIGHT - 1; i >= 0; i--) {
			bool printed = false;
			Tower<G>? curr = _head;
			State state;
			while ((curr = curr.get_succ (out state, (uint8)i)) != null) {
				if (!printed) {
					stderr.printf("Level %d\n", i);
					printed = true;
				}
				stderr.printf("    Node %p%s - %s\n", curr, state == State.NONE ? "" : state == State.MARKED ? " (MARKED)" : " (FLAGGED)", (string)curr._data);
			}
		}
	}
#endif

	private int _size = 0;
	private Tower<G> _head = new Tower<G>.head ();
	private CompareDataFunc<G>? _cmp;
	private static const int _MAX_HEIGHT = 31;
	private static Private rand = new Private((ptr) => {
		Rand *rnd = (Rand *)ptr;
		delete rnd;
	});

	private class Iterator<G> : Object, Traversable<G>, Gee.Iterator<G> {
		public Iterator (ConcurrentSet cset, Tower<G> head) {
			_curr = head;
			_set = cset;
			assert (_curr != null);
		}

		public Iterator.pointing (ConcurrentSet cset, Tower<G>[] prev, Tower<G> curr) {
			for (int i = 0; i < _MAX_HEIGHT; i++) {
				_prev[i] = prev[i];
			}
			_curr = curr;
			_set = cset;
			assert (_curr != null);
		}

		public new bool foreach (ForallFunc<G> f) {
			assert (_curr != null);
			HazardPointer.Context ctx = new HazardPointer.Context ();
			if (_prev[0] != null && !_removed) {
				if (!f (_curr._data)) {
					assert (_curr != null);
					return false;
				}
			}
			Tower<G> new_prev = _prev[0];
			Tower<G>? new_curr = _curr;
			while (Tower.proceed<G> (_set._cmp, ref new_prev, ref new_curr, 0)) {
				assert (_curr != null);
				if (!_removed) {
					//FIXME: Help mark/delete on the way
					_prev[0] = new_prev;
					int prev_height = GLib.AtomicInt.get(ref _prev[0]._height);
					for (int i = 1; i < prev_height; i++) {
						_prev[i] = _prev[0];
					}
				}
				_curr = new_curr;
				_removed = false;
				if (!f (_curr._data)) {
					assert (_curr != null);
					return false;
				}
			}
			assert (_curr != null);
			return true;
		}

		public bool next () {
			HazardPointer.Context ctx = new HazardPointer.Context ();
			Tower<G> new_prev = _prev[0];
			Tower<G>? new_curr = _curr;
			bool success = Tower.proceed<G> (_set._cmp, ref new_prev, ref new_curr, 0);
			if (success) {
				if (!_removed) {
					//FIXME: Help mark/delete on the way
					_prev[0] = (owned)new_prev;
					int prev_height = GLib.AtomicInt.get(ref _prev[0]._height);
					for (int i = 1; i < prev_height; i++) {
						_prev[i] = _prev[0];
					}
				}
				_curr = (owned)new_curr;
				_removed = false;
			}
			assert (_curr != null);
			return success;
		}

		public bool has_next () {
			HazardPointer.Context ctx = new HazardPointer.Context ();
			Tower<G> prev = _prev[0];
			Tower<G>? curr = _curr;
			return Tower.proceed<G> (_set._cmp, ref prev, ref curr, 0);
		}

		public new G get () {
			assert (valid);
			return _curr._data;
		}

		public void remove () {
			HazardPointer.Context ctx = new HazardPointer.Context ();
			assert (valid);
			if (Tower.remove<G> (_set._cmp, _prev, _curr)) {
				AtomicInt.dec_and_test (ref _set._size);
			}
			_removed = true;
		}

		public bool valid { get { return _prev[0] != null && !_removed; } }

		public bool read_only { get { return true; } }

		private bool _removed = false;
		private ConcurrentSet<G> _set;
		private Tower<G>? _prev[31 /*_MAX_HEIGHT*/];
		private Tower<G> _curr;
	}

	private class Tower<G> {
		public inline Tower (G data, uint8 height) {
			_nodes = new TowerNode<G>[height];
			_data = data;
			_height = 0;
			AtomicPointer.set (&_nodes[0]._backlink, null); // FIXME: This should be memory barrier
		}

		public inline Tower.head () {
			_nodes = new TowerNode<G>[_MAX_HEIGHT];
			_height = _MAX_HEIGHT;
		}

		inline ~Tower () {
			for (uint i = 0; i < _height; i++) {
				HazardPointer<Tower<G>>.set_pointer (&_nodes[i]._succ, null);
				HazardPointer<Tower<G>>.set_pointer (&_nodes[i]._backlink, null);
			}
			_nodes = null;
		}

		public static inline bool search<G> (CompareDataFunc<G>? cmp, G key, ref Tower<G> prev, out Tower<G>? next, uint8 to_level = 0, uint8 from_level = (uint8)_MAX_HEIGHT - 1) {
			assert (from_level >= to_level);
			bool res = false;
			next = null;
			for (int i = from_level; i >= to_level; i--) {
				res = search_helper<G> (cmp, key, ref prev, out next, (uint8)i);
			}
			return res;
		}

		private static inline bool search_helper<G> (CompareDataFunc<G>? cmp, G key, ref Tower<G>? prev, out Tower<G>? next, uint8 level) {
			next = prev.get_next (level);
			while (next != null && cmp(key, next._data) < 0 && proceed<G> (cmp, ref prev, ref next, level, true));
			return next != null && cmp(key, next._data) == 0;
		}

		public static inline Tower<G>? insert<G> (CompareDataFunc<G>? cmp, ref Tower<G> prev, G key, uint8 chosen_level) {
			return insert_helper<G> (cmp, ref prev, key, chosen_level, chosen_level);
		}

		private static inline Tower<G>? insert_helper<G> (CompareDataFunc<G>? cmp, ref Tower<G> prev, G key, uint8 chosen_level, uint8 level) {
			Tower<G>? new_tower;
			Tower<G>? next;
			if (search_helper (cmp, key, ref prev, out next, level)) {
				return null;
			}
			if (level > 0) {
				Tower<G> prev_down = prev;
				new_tower = insert_helper<G> (cmp, ref prev_down, key, chosen_level, level - 1);
			} else {
				new_tower = new Tower<G> (key, chosen_level + 1);
			}
			if (new_tower == null) {
				return null;
			}
			while (true) {
				State prev_state;
				Tower<G>? prev_next = prev.get_succ (out prev_state, level);
				if (prev_state == State.FLAGGED) {
					prev_next.help_flagged (prev, level);
				} else {
					new_tower.set_succ (next, State.NONE, level);
					bool result = prev.compare_and_exchange (next, State.NONE, new_tower, State.NONE, level);
					if (result)
						break;
					prev_next = prev.get_succ (out prev_state, level);
					if (prev_state == State.FLAGGED) {
						prev_next.help_flagged (prev, level);
					}
					backtrace<G> (ref prev, level);
				}
				if (search_helper (cmp, key, ref prev, null, level)) {
					return null;
				}
			}
			GLib.AtomicInt.inc (ref new_tower._height);
			if (new_tower.get_state (0) == State.MARKED) {
				remove_level (cmp, ref prev, new_tower, level);
				return null;
			}
			return new_tower;
		}

		public static inline bool remove_key<G> (CompareDataFunc<G>? cmp, Tower<G> arg_prev, G key, uint8 from_level = (uint8)_MAX_HEIGHT - 1) {
			Tower<G> prev[31 /*_MAX_HEIGHT*/];
			prev[from_level] = arg_prev;
			for (int i = from_level; i >= 1; i--) {
				Tower<G> next;
				search_helper<G> (cmp, key, ref prev[i], out next, (uint8)i);
				prev[i - 1] = prev[i];
			}
			Tower<G>? curr;
			if (search_helper<G> (cmp, key, ref prev[0], out curr, 0)) {
				return remove<G> (cmp, prev, curr);
			} else {
				return false;
			}
		}

		public static inline bool remove<G> (CompareDataFunc<G>? cmp, Tower<G>[] prev, Tower<G> curr) {
			assert (prev.length >= AtomicInt.get (ref curr._height));
			bool removed = remove_level (cmp, ref prev[0], curr, 0);
			for (int i = 1; i < prev.length; i++) {
				remove_level (cmp, ref prev[i], curr, (uint8)i);
			}
			return removed;
		}

		private static inline bool remove_level (CompareDataFunc<G>? cmp, ref Tower<G> prev, Tower<G> curr, uint8 level) {
			bool status;
			bool flagged = curr.try_flag (cmp, ref prev, out status, level);
			if (status) {
				curr.help_flagged (prev, level);
			}
			return flagged;
		}

		public static inline bool proceed<G> (CompareDataFunc<G>? cmp, ref Tower<G>? arg_prev, ref Tower<G> arg_curr, uint8 level, bool force = false) {
			Tower<G> curr = arg_curr;
			Tower<G>? next = curr.get_next (level);
			if (next != null) {
				while (next.get_state (0) == State.MARKED) {
					bool status;
					next.try_flag (cmp, ref curr, out status, level);
					if (status) {
						next.help_flagged (curr, level);
					}
					next = curr.get_next (level);
				}
			}
			bool success = next != null;
			if (success || force) {
				arg_prev = (owned)curr;
				arg_curr = (owned)next;
			}
			return success;
		}

		public inline void help_marked (Tower<G> prev_tower, uint8 level) {
			prev_tower.compare_and_exchange (this, State.FLAGGED, get_next (level), State.NONE, level);
		}

		public inline void help_flagged (Tower<G> prev, uint8 level) {
			set_backlink (prev, level);
			if (get_state (level) != State.MARKED)
				try_mark (level);
			help_marked (prev, level);
		}

		public inline void try_mark (uint8 level) {
			do {
				Tower<G>? next_tower = get_next (level);
				bool result = compare_and_exchange (next_tower, State.NONE, next_tower, State.MARKED, level);
				if (!result) {
					State state;
					next_tower = get_succ (out state, level);
					if (state == State.FLAGGED)
						help_flagged (next_tower, level);
				}
			} while (get_state (level) !=  State.MARKED);
		}

		public inline bool try_flag (CompareDataFunc<G>? cmp, ref Tower<G> prev_tower, out bool status, uint8 level) {
			while (true) {
				if (prev_tower.compare_succ (this, State.FLAGGED, level)) {
					status = true;
					return false;
				}
				bool result = prev_tower.compare_and_exchange (this, State.NONE, this, State.FLAGGED, level);
				if (result) {
					status = true;
					return true;
				}
				State result_state;
				Tower<G>? result_tower = prev_tower.get_succ (out result_state, level);
				if (result_tower == this && result_state == State.FLAGGED) {
					status = true;
					return false;
				}
				backtrace<G> (ref prev_tower, level);
				if (!search_helper (cmp, _data, ref prev_tower, null, level)) {
					status = false;
					return false;
				}
			}
		}

		public static inline void backtrace<G> (ref Tower<G>? curr, uint8 level) {
			while (curr.get_state (level) == State.MARKED)
				curr = curr.get_backlink (level);
		}

		public inline bool compare_and_exchange (Tower<G>? old_tower, State old_state, Tower<G>? new_tower, State new_state, uint8 level) {
			return HazardPointer.compare_and_exchange_pointer<Tower<G>?> (&_nodes[level]._succ, old_tower, new_tower, 3, (size_t)old_state, (size_t)new_state);
		}

		public inline bool compare_succ (Tower<G>? next, State state, uint8 level) {
			size_t cur = (size_t)AtomicPointer.get (&_nodes[level]._succ);
			return cur == ((size_t)next | (size_t)state);
		}

		public inline Tower<G>? get_next (uint8 level) {
			return get_succ (null, level);
		}

		public inline State get_state (uint8 level) {
			return (State)((size_t)AtomicPointer.get (&_nodes[level]._succ) & 3);
		}

		public inline Tower<G>? get_succ (out State state, uint8 level) {
			size_t rstate;
			Tower<G>? succ = HazardPointer.get_pointer<Tower<G>> (&_nodes[level]._succ, 3, out rstate);
			state = (State)rstate;
			return (owned)succ;
		}

		public inline void set_succ (Tower<G>? next, State state, uint8 level) {
			HazardPointer.set_pointer<Tower<G>> (&_nodes[level]._succ, next, 3, (size_t)state);
		}

		public inline Tower<G>? get_backlink (uint8 level) {
			return HazardPointer.get_pointer<Tower<G>> (&_nodes[level]._backlink);
		}

		public inline void set_backlink (Tower<G>? backlink, uint8 level) {
			HazardPointer.compare_and_exchange_pointer<Tower<G>?> (&_nodes[level]._backlink, null, backlink);
		}

		[NoArrayLength]
		public TowerNode<G>[] _nodes;
		public G _data;
		public int _height;
	}

	private struct TowerNode<G> {
		public Tower<G> *_succ;
		public Tower<G> *_backlink;
	}

	private enum State {
		NONE = 0,
		MARKED = 1,
		FLAGGED = 2
	}
}

