/* benchmark.vala
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
	OptionEntry run_benchmark_option(string long_name, char short_name, string description, ref bool do_run) {
		return OptionEntry() {
			long_name = long_name,
			short_name = short_name,
			flags = 0,
			arg = OptionArg.NONE,
			arg_data = &do_run,
			description = description,
			arg_description = null
		};
	}

	int main (string[] args) {
		bool run_sort = false;
		OptionEntry[] entries = {
			run_benchmark_option("run-sort", 's', "Run sorting benchmark", ref run_sort)
		};
		var context = new OptionContext ("Run various benchmarks");
		context.add_main_entries (entries, "gee-benchmark");
		try {
			context.parse (ref args);
		} catch (OptionError e) {
			stdout.printf ("option parsing failed: %s\n", e.message);
			return 2;
		}
		if(run_sort) {
			benchmark_sorts ();
		}
		return 0;
	}

	public interface Factory<G> : Object {

		public abstract Collection<G> create ();

		public abstract Collection<G> copy (Collection<G> collection);
	}

	public interface Generator<G> : Object {

		public abstract string name { get; }

		public abstract void generate_collection (int size, Collection<G> collection);
	}

	public interface Algorithm<G> : Object {

		public abstract string name { get; }

		public abstract void process_collection (Collection<G> collection);
	}

	public class RandomInt32 : Object, Generator<int32> {

		public string name { get { return "FullRandom"; } }

		public void generate_collection (int size, Collection<int32> collection) {
            for (int i = 0; i < size; i++) {
                    collection.add (GLib.Random.int_range (0, size - 1));
            }
		}
	}

	public class FixedVarianceInt32 : Object, Generator<int32> {

		public string name { get { return "FixedVariance"; } }

		public void generate_collection (int size, Collection<int32> collection) {
			int variance = (int) Math.sqrt (size);
			for (int i = 0; i < size; i++) {
				collection.add (i + GLib.Random.int_range (0, variance) - variance / 2);
			}
		}
	}

	public class MountsInt32 : Object, Generator<int32> {

		public string name { get { return "Mounts"; } }

		public void generate_collection (int size, Collection<int32> collection) {
			int index = 0;
			int last = 0;
			int variance = (int) Math.sqrt (size);
			while (index < size) {
				int width = GLib.Random.int_range (0, variance);
				int height = GLib.Random.int_range (- variance / 2, variance / 2);
				for (int i = 0; i < width; i++) {
					collection.add (last + height / width);
				}
				index += width;
				last += height;
			}
		}
	}

	public class ReverseSortedInt32 : Object, Generator<int32> {

		public string name { get { return "ReverseSorted"; } }

		public void generate_collection (int size, Collection<int32> collection) {
			for (int i = 0; i < size; i++) {
				collection.add (size - i - 1);
			}
		}
	}

	public class SortedInt32 : Object, Generator<int32> {

		public string name { get { return "Sorted"; } }

		public void generate_collection (int size, Collection<int32> collection) {
			for (int i = 0; i < size; i++) {
				collection.add (i);
			}
		}
	}

	public class ArrayListFactory<G> : Object, Factory<G> {

		public Collection<G> create () {
			return new ArrayList<G> ();
		}

		public Collection<G> copy (Collection<G> collection) {
			ArrayList<G> copy = new ArrayList<G> ();
			foreach (G item in collection) {
				copy.add (item);
			}
			return copy;
		}
	}

	public class Benchmark<G> : Object {

		public Benchmark (Factory<G> factory,
		                  Gee.List<Algorithm<G>> algorithms,
		                  Gee.List<Generator<G>> generators,
		                  int[] sizes,
		                  int iteration_count) {
			this.factory = factory;
			this.algorithms = algorithms;
			this.sizes = sizes;
			this.generators = generators;
			this.iteration_count = iteration_count;
		}

		private Factory<G> factory;
		private int[] sizes;
		private Gee.List<Generator<G>> generators;
		private Gee.List<Algorithm<G>> algorithms;
		private int iteration_count;
		private double[,,] results_sum;
		private double[,,] results_squared_sum;

		public void run () {
			results_sum = new double[sizes.length,
			                         generators.size,
			                         algorithms.size];
			results_squared_sum = new double[sizes.length,
			                                 generators.size,
			                                 algorithms.size];

			for (int i = 0; i < sizes.length; i++) {
				for (int j = 0; j < generators.size; j++) {
					for (int k = 0; k < algorithms.size; k++) {
						results_sum[i,j,k] = 0;
						results_squared_sum[i,j,k] = 0;
					}
				}
			}

			Timer timer = new Timer ();

			for (int iteration = 1; iteration <= iteration_count; iteration++) {
				for (int i = 0; i < sizes.length; i++) {
					int size = sizes[i];
					for (int j = 0; j < generators.size; j++) {
						Collection<G> collection = factory.create ();
						generators[j].generate_collection (size, collection);

						for (int k = 0; k < algorithms.size; k++) {
							Collection<G> copy = factory.copy (collection);

							timer.reset ();
							timer.start ();
							algorithms[k].process_collection (copy);
							timer.stop ();

							double elapsed = timer.elapsed ();
							results_sum[i,j,k] += elapsed;
							results_squared_sum[i,j,k] += Math.pow (elapsed, 2);
						}
					}
				}

				if (iteration % 10 == 0) {
					stdout.printf ("|");
				} else {
					stdout.printf ("*");
				}
				stdout.flush ();
				if (iteration % 100 == 0) {
					stdout.printf ("\n\n");
					display_results (iteration);
				}
			}
		}

		public void display_results (int iteration) {
			stdout.printf ("After %d iterations: (average [sample standard deviation] in seconds)\n\n", iteration);

			for (int i = 0; i < sizes.length; i++) {
				stdout.printf ("%d elements:\n", sizes[i]);

				stdout.printf ("%20s\t", "");
				for (int k = 0; k < algorithms.size; k++) {
					stdout.printf ("%-20s\t", algorithms[k].name);
				}
				stdout.printf ("\n");

				for (int j = 0; j < generators.size; j++) {
					stdout.printf ("%20s\t", generators[j].name);
					for (int k = 0; k < algorithms.size; k++) {
						double average = results_sum[i,j,k] / iteration;
						double squared_deviation =
							(results_squared_sum[i,j,k]
							 - ((double) iteration) * Math.pow (average, 2))
							 / (iteration - 1);
						double deviation = Math.sqrt (squared_deviation);
						stdout.printf ("%8f [%8f] \t", average, deviation);
					}
					stdout.printf ("\n");
				}
				stdout.printf ("\n");
			}
			stdout.printf ("\n\n");
		}
	}
}
