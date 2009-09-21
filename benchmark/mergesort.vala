/* mergesort.vala
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
 * 	Will <tcosprojects@gmail.com>
 */

internal class Gee.MergeSort<G> {

	public static void sort<G> (List<G> list, CompareDataFunc compare) {
		if (list is ArrayList) {
			MergeSort.sort_arraylist<G> ((ArrayList<G>) list, compare);
		} else {
			MergeSort.sort_list<G> (list, compare);
		}
	}

	public static void sort_list<G> (List<G> list, CompareDataFunc compare) {
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

	public static void sort_arraylist<G> (ArrayList<G> list, CompareDataFunc compare) {
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
