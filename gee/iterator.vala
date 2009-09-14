/* iterator.vala
 *
 * Copyright (C) 2007-2008  Jürg Billeter
 * Copyright (C) 2009  Didier Villevalois, Maciej Piechotka
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
 * 	Maciej Piechotka <uzytkownik2@gmail.com>
 */

/**
 * An iterator over a collection.
 */
public interface Gee.Iterator<G> : GLib.Object {
	/**
	 * Advances to the next element in the iteration.
	 *
	 * @return true if the iterator has a next element
	 */
	public abstract bool next ();

	/**
	 * Checks whether there is a next element in the iteration.
	 *
	 * @return true if the iterator has a next element
	 */
	public abstract bool has_next ();

	/**
	 * Rewinds to the first element in the iteration.
	 *
	 * @return true if the iterator has a first element
	 */
	public abstract bool first ();

	/**
	 * Returns the current element in the iteration.
	 *
	 * @return the current element in the iteration
	 */
	public abstract G get ();
}

