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
 * 	Will <tcosprojects@gmail.com>
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
			CompareDataFunc compare = Functions.get_compare_func_for (typeof (G));
			Gee.MergeSort.sort<G> ((Gee.List<G>) collection, compare);
		}
	}

	public void benchmark_sorts () {
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

internal class Gee.MergeSort<G> {

	public static void sort<G> (List<G> list, CompareDataFunc<G> compare) {
		if (list is ArrayList) {
			MergeSort.sort_arraylist<G> ((ArrayList<G>) list, compare);
		} else {
			MergeSort.sort_list<G> (list, compare);
		}
	}

	public static void sort_list<G> (List<G> list, CompareDataFunc<G> compare) {
		MergeSort<G> helper = new MergeSort<G> ();

		helper.list_collection = list;
		helper.array = list.to_array ();
		helper.list = helper.array;
		helper.index = 0;
		helper.size = list.size;
		helper.compare = compare;

		helper.do_sort ();

		// TODO Use a list iterator and use iter.set(item)
		list.clear ();
		foreach (G item in helper.array) {
			list.add (item);
		}
	}

	public static void sort_arraylist<G> (ArrayList<G> list, CompareDataFunc<G> compare) {
		MergeSort<G> helper = new MergeSort<G> ();

		helper.list_collection = list;
		helper.list = list._items;
		helper.index = 0;
		helper.size = list._size;
		helper.compare = compare;

		helper.do_sort ();
	}

	private List<G> list_collection;
	private G[] array;
	private unowned G[] list;
	private int index;
	private int size;
	private CompareDataFunc compare;

	private void do_sort () {
		if (this.size <= 1) {
			return;
		}

		var work_area = new G[this.size];

		merge_sort_aux (index, this.size, work_area);
	}

	private void merge_sort_aux (int left, int right, G[] work_area) {
		if (right == left + 1) {
			return;
		} else {
			int size = right - left;
			int middle = size / 2;
			int lbegin = left;
			int rbegin = left + middle;

			merge_sort_aux (left, left + middle, work_area);
			merge_sort_aux (left + middle, right, work_area);

			for (int i = 0; i < size; i++) {
				if (lbegin < left + middle && (rbegin == right ||
					compare (list[lbegin], list[rbegin]) <= 0)) {

					work_area[i] = list[lbegin];
					lbegin++;
				} else {
					work_area[i] = list[rbegin];
					rbegin++;
				}
			}

			for (int i = left; i < right; i++) {
				list[i] = work_area[i - left];
			}
		}
	}
}

