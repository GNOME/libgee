/* abstractqueue.vala
 *
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
 * 	Didier 'Ptitjes Villevalois <ptitjes@free.fr>
 */

/**
 * Skeletal implementation of the {@link Queue} interface.
 *
 * Contains common code shared by all queue implementations.
 *
 * @see PriorityQueue
 */
public abstract class Gee.AbstractQueue<G> : Gee.AbstractCollection<G>, Queue<G> {
	/**
	 * {@inheritDoc}
	 */
	public abstract int capacity { get; }

	/**
	 * {@inheritDoc}
	 */
	public abstract int remaining_capacity { get; }

	/**
	 * {@inheritDoc}
	 */
	public abstract bool is_full { get; }

	/**
	 * {@inheritDoc}
	 */
	public abstract G? peek ();

	/**
	 * {@inheritDoc}
	 */
	public abstract G? poll ();

	// Future-proofing
	internal new virtual void reserved0() {}
	internal new virtual void reserved1() {}
	internal new virtual void reserved2() {}
	internal new virtual void reserved3() {}
	internal new virtual void reserved4() {}
	internal new virtual void reserved5() {}
	internal new virtual void reserved6() {}
	internal new virtual void reserved7() {}
	internal new virtual void reserved8() {}
	internal new virtual void reserved9() {}
}
