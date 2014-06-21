/* bidirlistiterator.vala
 *
 * Copyright (C) 2011  Maciej Piechotka
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
[GenericAccessors]
public interface Gee.BidirListIterator<G> : Gee.BidirIterator<G>, Gee.ListIterator<G> {
	/**
	 * Inserts the specified item before the current item in the iteration. The
	 * iterator points to the same element as before.
	 *
	 * Please note that if iterator points in-between elements the element
	 * is added between neighbouring elements and the iterator point between
	 * added element and the next one.
	 */
	public abstract void insert (G item);
}

