public delegate void RunTest(FileStream output, bool verbose, size_t size, size_t tries);
public delegate Gee.Collection<T> CreateCollection<T>();
public delegate void Prepare<T>(Gee.Collection<T> collection);
public delegate void Run<T>(Gee.Collection<T> collection);

struct CollectionTest<T> {
	CollectionTest(string name, owned CreateCollection<T> create) {
		this.name = name;
		this.create = (owned)create;
	}
	unowned string name;
	CreateCollection<T> create;
}

class RunTestWrap {
	public RunTestWrap(owned RunTest run_test) {
		this.run_test = (owned)run_test;
	}
	public RunTest run_test;
}

internal void test<T>(FileStream output, bool verbose, string name, CollectionTest[] cols, Prepare<T> prepare, Run<T> run, size_t size, size_t tries) {
	GLib.Timer timer = new GLib.Timer ();
	for (size_t i = 0; i < tries; i++) {
		for (size_t j = 0; j < cols.length; j++) {
			timer.reset ();
			Gee.Collection<T> col = cols[j].create();
			prepare(col);
			timer.start();
			run(col);
			timer.stop();
			output.printf("%s, %s, %ld, %lf\n", name, cols[j].name, (long)size, timer.elapsed());
		}
	}
}

internal void run_list_uint_tests(FileStream output, bool verbose, size_t size, size_t tries) {
	CollectionTest<uint>[] cols = new CollectionTest<uint>[3];
	cols[0] = CollectionTest<uint>("ArrayList", () => {return new Gee.ArrayList<uint>();});
	cols[1] = CollectionTest<uint>("LinkedList", () => {return new Gee.LinkedList<uint>();});
	//cols[2] = CollectionTest<uint>("UnrolledLinkedList [5/0.8]", () => {return new Gee.UnrolledLinkedList<uint>();});
	//cols[2] = CollectionTest<uint>("UnrolledLinkedList [13/0.8]", () => {return new Gee.UnrolledLinkedList<uint>();});
	cols[2] = CollectionTest<uint>("UnrolledLinkedList [29/0.8]", () => {return new Gee.UnrolledLinkedList<uint>();});
	test<uint>(output, verbose, "Sequential uint add", cols, (col) => {}, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, size, tries);
	test<uint>(output, verbose, "Prepending uint", cols, (col) => {}, (col) => {
		var list = (Gee.List<uint>)col;
		for (size_t i = 0; i < size; i++) {
			list.insert(0, (uint)i);
		}
	}, size, tries);
	test<uint>(output, verbose, "Random insert", cols, (col) => {}, (col) => {
		uint r = 0xdeadbeefU;
		var list = (Gee.List<uint>)col;
		for (size_t i = 0; i < size; i++) {
			list.insert((int)(r % (i + 1)), (uint)i);
		}
	}, size, tries);
	test<uint>(output, verbose, "Doubling uint (add)", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var list = (Gee.List<uint>)col;
		var iter = list.list_iterator ();
		while (iter.next ()) {
			iter.add (iter.get ());
		}
	}, size, tries);
	test<uint>(output, verbose, "Doubling uint (insert)", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var list = (Gee.BidirList<uint>)col;
		var iter = list.bidir_list_iterator ();
		while (iter.next ()) {
			iter.insert (iter.get ());
		}
	}, size, tries);
	test<uint>(output, verbose, "Sequential uint remove", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var list = (Gee.BidirList<uint>)col;
		for (size_t i = size; i-- > 0;) {
			list.remove_at((int)i);
		}
	}, size, tries);
	test<uint>(output, verbose, "Sequential uint remove (reversed)", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var list = (Gee.BidirList<uint>)col;
		for (size_t i = 0; i < size; i++) {
			list.remove_at((int)0);
		}
	}, size, tries);
	test<uint>(output, verbose, "Random uint remove", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var list = (Gee.BidirList<uint>)col;
		uint r = 0xdeadbeefU;
		for (size_t i = size; i-- > 0;) {
			list.remove_at((int)(r % (i + 1)));
		}
	}, size, tries);
	test<uint>(output, verbose, "Halfing uint", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var iter = col.iterator ();
		while (iter.next ()) {
			iter.remove ();
			iter.next ();
		}
	}, size, tries);
	test<uint>(output, verbose, "Foreach uint", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		for (uint i = 0; i < 20; i++) {
			col.foreach ((i) => {return true;});
		}
	}, size, tries);
	test<uint>(output, verbose, "Iterator foreach uint", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		for (uint i = 0; i < 20; i++) {
			col.iterator().foreach ((i) => {return true;});
		}
	}, size, tries);
}

internal void run_set_uint_tests(FileStream output, bool verbose, size_t size, size_t tries) {
	CollectionTest<uint>[] cols = new CollectionTest<uint>[2];
	cols[0] = CollectionTest<uint>("HashSet", () => {return new Gee.HashSet<uint>();});
	cols[1] = CollectionTest<uint>("TreeSet", () => {return new Gee.TreeSet<uint>();});
	test<uint>(output, verbose, "Sequential uint add", cols, (col) => {}, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, size, tries);
	test<uint>(output, verbose, "Reverse uint add", cols, (col) => {}, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)(size - i));
		}
	}, size, tries);
	test<uint>(output, verbose, "Layered uint add", cols, (col) => {}, (col) => {
		for (size_t i = 2; i < size; i *= 2) {
			for (size_t j = size/i; j < size; j += 2*(size/i)) {
				col.add((uint)j);
			}
		}
	}, size, tries);
	test<uint>(output, verbose, "Sequential uint remove", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.remove((uint)i);
		}
	}, size, tries);
	test<uint>(output, verbose, "Reverse uint remove", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.remove((uint)(size - i));
		}
	}, size, tries);
	test<uint>(output, verbose, "Layered uint remove", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		for (size_t i = size; i >= 2; i /= 2) {
			for (size_t j = size/i; j < size; j += (2*size/i)) {
				col.remove((uint)j);
			}
		}
	}, size, tries);
	test<uint>(output, verbose, "Lookup", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.contains((uint)i);
		}
	}, size, tries);
	test<uint>(output, verbose, "Iterator", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var iter = col.iterator();
		while (iter.next ()) {}
	}, size, tries);
	test<uint>(output, verbose, "Foreach", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		col.foreach ((val) => {return true;});
	}, size, tries);
	test<uint>(output, verbose, "Iterator remove", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var iter = col.iterator();
		while (iter.next ()) {
			iter.remove ();
		}
	}, size, tries);
}

internal uint tries = 100;
internal uint[]? sizes;
[CCode (array_length = false, array_null_terminated = true)]
internal string[]? sizes_str = null;
[CCode (array_length = false, array_null_terminated = true)]
internal string[]? tests = null;
internal string? output = null;
internal bool verbose = false;
internal const GLib.OptionEntry[] options = {
	{"size", 's', 0, OptionArg.STRING_ARRAY, ref sizes_str, "Size for which to test", "SIZES..." },
	{"tries", 'n', 0, OptionArg.INT, ref tries, "Number of measurements", "TRIES"},
	{"test", 't', 0, OptionArg.STRING_ARRAY, ref tests, "Test sets", "TESTSETS"},
	{"output", 'o', 0, OptionArg.FILENAME, ref output, "Output data to file (appends at the end)", "FILE"},
	{"verbose", 'v', 0, OptionArg.NONE, ref verbose, "Verbose"},
	{null}
};

int main(string[] args) {
	var all_tests = new Gee.HashMap<unowned string, RunTestWrap>();
	all_tests["lists"] = new RunTestWrap(run_list_uint_tests);
	all_tests["sets"] = new RunTestWrap(run_set_uint_tests);
	sizes = new uint[]{32, 64, 128, 256, 512, 1024, 2048};
	{
		var tmp = all_tests.keys.to_array ();
		tmp += null;
		tests = (owned)tmp;
	}
	var optctx = new OptionContext ("- Collections benchmark");
	optctx.set_help_enabled (true);
	optctx.add_main_entries (options, null);
	try {
		optctx.parse (ref args);
		if (sizes_str != null) {
			sizes = new uint[0];
			foreach (unowned string size_str in sizes_str) {
				uint64 val;
				if (!uint64.try_parse(size_str, out val)) {
					throw new OptionError.BAD_VALUE ("Cannot parse integer value '%s' for -s", size_str);
				}
				if (val >= int.MAX) {
					throw new OptionError.BAD_VALUE ("Value '%s' for -s is out of range", size_str);
				}
				sizes += (uint)val;
			}
		}
		foreach (unowned string test in tests) {
			if (!all_tests.has_key (test)) {
				throw new OptionError.BAD_VALUE ("Unknown test set '%s'", test);
			}
		}
	} catch (OptionError e) {
		stderr.printf ("error: %s\n", e.message);
		stderr.printf ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
		return 2;
	}
	unowned FileStream output_stream = stdout;
	FileStream? file = null;
	if (output != null) {
		file = FileStream.open(output, "a");
		if (file == null) {
			stderr.printf ("Failed to open output file: %s", strerror(errno));
		}
		output_stream = file;
	}
	foreach (unowned string test in tests) {
		RunTestWrap run_test = all_tests[test];
		foreach (uint size in sizes) {
			run_test.run_test (output_stream, verbose, size, tries);
		}
	}
	return 0;
}
