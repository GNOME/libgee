/* testmain.vala
 *
 * Copyright (C) 2008  Jürg Billeter
 * Copyright (C) 2009  Didier Villevalois, Julien Peeters
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

void main (string[] args) {
	Test.init (ref args);

	Gee.HazardPointer.set_release_policy(Gee.HazardPointer.ReleasePolicy.MAIN_LOOP);

	TestSuite.get_root ().add_suite (new ArrayListTests ().get_suite ());
	TestSuite.get_root ().add_suite (new ArrayQueueTests ().get_suite ());
	TestSuite.get_root ().add_suite (new ConcurrentListTests ().get_suite ());
	TestSuite.get_root ().add_suite (new ConcurrentSetTests ().get_suite ());
	TestSuite.get_root ().add_suite (new FunctionsTests ().get_suite ());
	TestSuite.get_root ().add_suite (new HashMapTests ().get_suite ());
	TestSuite.get_root ().add_suite (new HashMultiMapTests ().get_suite ());
	TestSuite.get_root ().add_suite (new HashMultiSetTests ().get_suite ());
	TestSuite.get_root ().add_suite (new HashSetTests ().get_suite ());
	TestSuite.get_root ().add_suite (new LinkedListTests ().get_suite ());
	TestSuite.get_root ().add_suite (new LinkedListAsDequeTests ().get_suite ());
	TestSuite.get_root ().add_suite (new PriorityQueueTests ().get_suite ());
	TestSuite.get_root ().add_suite (new ReadOnlyBidirListTests ().get_suite ());
	TestSuite.get_root ().add_suite (new ReadOnlyCollectionTests ().get_suite ());
	TestSuite.get_root ().add_suite (new ReadOnlyListTests ().get_suite ());
	TestSuite.get_root ().add_suite (new ReadOnlyMapTests ().get_suite ());
	TestSuite.get_root ().add_suite (new ReadOnlySetTests ().get_suite ());
	TestSuite.get_root ().add_suite (new TreeMapTests ().get_suite ());
	TestSuite.get_root ().add_suite (new TreeMultiMapTests ().get_suite ());
	TestSuite.get_root ().add_suite (new TreeMultiSetTests ().get_suite ());
	TestSuite.get_root ().add_suite (new TreeSetTests ().get_suite ());
	TestSuite.get_root ().add_suite (new UnrolledLinkedListTests ().get_suite ());
	TestSuite.get_root ().add_suite (new UnrolledLinkedListAsDequeTests ().get_suite ());

	Test.run ();
}
