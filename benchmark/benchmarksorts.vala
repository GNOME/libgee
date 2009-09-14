/* benchmarksorts.vala
 *
 * Copyright (C) 2008  Jürg Billeter
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

using Gee;

namespace Gee.Benchmark {

	public class TimSort<G> : Object, Algorithm<G> {

		public string name { get { return "TimSort"; } }

		public void process_collection (Collection<G> collection) {
			((Gee.List<G>) collection).sort ();
		}
	}

	public class MergeSort<G> : Object, Algorithm<G> {

		public string name { get { return "MergeSort"; } }

		public void process_collection (Collection<G> collection) {
			CompareFunc compare = Functions.get_compare_func_for (typeof (G));
			Gee.MergeSort.sort<G> ((Gee.List<G>) collection, compare);
		}
	}

	void main (string[] args) {
		var algorithms = new ArrayList<Algorithm<int32>> ();
		algorithms.add (new TimSort<int32> ());
		algorithms.add (new MergeSort<int32> ());

		var generators = new ArrayList<Generator<int32>> ();
		generators.add (new RandomInt32 ());
		generators.add (new FixedVarianceInt32 ());
		generators.add (new MountsInt32 ());
		generators.add (new ReverseSortedInt32 ());
		generators.add (new SortedInt32 ());

		Benchmark<int32> benchmark =
			new Benchmark<int32> (new ArrayListFactory<int32> (),
		                          algorithms,
		                          generators,
		                          new int[] { 10,
		                                      100,
		                                      1000,
		                                      10000,
		                                      100000,
		                                      1000000
		                                    },
		                          1000);
		benchmark.run ();
	}
}
