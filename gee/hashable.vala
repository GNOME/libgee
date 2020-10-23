/* hashable.vala
 *
 * Copyright (C) 2010  Maciej Piechotka
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
 * 	Maciej Piechotka <uzytkwonik2@gmail.com>
 */

/**
 * This interface defines a hash function among instances of each class
 * implementing it.
 *
 * @see Comparable
 */
public interface Gee.Hashable<G> : Object {
	/**
	 * Computes hash for an objects. Two hashes of equal objects have to be
	 * equal.
	 *
	 * Note: Hash //must not// change during lifetime of an object.
	 *
	 * @return hash of an object
	 */
	public abstract uint hash ();

	/**
	 * Compares this object with the specified object. This defines the
	 * equivalence relation between them.
	 *
	 * In other words:
	 *
	 *  * It must be reflexive: for all objects `a` it holds that
	 *    `a.equal_to(a)`.
	 *  * It must be symmetric: for all objects `a` and `b` if
	 *    `a.equal_to(b)` then `b.equal_to(a)`.
	 *  * It must be transitive: if `a.equal_to(b)` and `b.equal_to(c)` then
	 *    `a.equal_to(c)`.
	 *
	 * Note: Relationship //must not// change during lifetime of an object.
	 *
	 * @param object Object this objest is compared with
	 * @return true if objects are equal
	 */
	public abstract bool equal_to (G object);
}
