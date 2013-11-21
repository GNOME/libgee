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

internal void test<T>(string name, CollectionTest[] cols, Prepare<T> prepare, Run<T> run, size_t size, size_t tries) {
	GLib.Timer timer = new GLib.Timer ();
	for (size_t i = 0; i < tries; i++) {
		for (size_t j = 0; j < cols.length; j++) {
			timer.reset ();
			Gee.Collection<T> col = cols[j].create();
			prepare(col);
			timer.start();
			run(col);
			timer.stop();
			stdout.printf("%s, %s, %ld, %lf\n", name, cols[j].name, (long)size, timer.elapsed());
		}
	}
}

internal void run_uint_tests(size_t size, size_t tries) {
	CollectionTest<uint>[] cols = new CollectionTest<uint>[3];
	cols[0] = CollectionTest<uint>("ArrayList", () => {return new Gee.ArrayList<uint>();});
	cols[1] = CollectionTest<uint>("LinkedList", () => {return new Gee.LinkedList<uint>();});
	//cols[2] = CollectionTest<uint>("UnrolledLinkedList [5/0.8]", () => {return new Gee.UnrolledLinkedList<uint>();});
	//cols[2] = CollectionTest<uint>("UnrolledLinkedList [13/0.8]", () => {return new Gee.UnrolledLinkedList<uint>();});
	cols[2] = CollectionTest<uint>("UnrolledLinkedList [29/0.8]", () => {return new Gee.UnrolledLinkedList<uint>();});
	test<uint>("Sequential uint add", cols, (col) => {}, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, size, tries);
	test<uint>("Prepending uint", cols, (col) => {}, (col) => {
		var list = (Gee.List<uint>)col;
		for (size_t i = 0; i < size; i++) {
			list.insert(0, (uint)i);
		}
	}, size, tries);
	test<uint>("Random insert", cols, (col) => {}, (col) => {
		uint r = 0xdeadbeefU;
		var list = (Gee.List<uint>)col;
		for (size_t i = 0; i < size; i++) {
			list.insert((int)(r % (i + 1)), (uint)i);
		}
	}, size, tries);
	test<uint>("Doubling uint (add)", cols, (col) => {
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
	test<uint>("Doubling uint (insert)", cols, (col) => {
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
	test<uint>("Sequential uint remove", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var list = (Gee.BidirList<uint>)col;
		for (size_t i = size; i-- > 0;) {
			list.remove_at((int)i);
		}
	}, size, tries);
	test<uint>("Sequential uint remove (reversed)", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		var list = (Gee.BidirList<uint>)col;
		for (size_t i = 0; i < size; i++) {
			list.remove_at((int)0);
		}
	}, size, tries);
	test<uint>("Random uint remove", cols, (col) => {
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
	test<uint>("Halfing uint", cols, (col) => {
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
	test<uint>("Foreach uint", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		for (uint i = 0; i < 20; i++) {
			col.foreach ((i) => {return true;});
		}
	}, size, tries);
	test<uint>("Iterator foreach uint", cols, (col) => {
		for (size_t i = 0; i < size; i++) {
			col.add((uint)i);
		}
	}, (col) => {
		for (uint i = 0; i < 20; i++) {
			col.iterator().foreach ((i) => {return true;});
		}
	}, size, tries);
}

int main() {
	uint tries = 100;
	run_uint_tests(32, tries);
	run_uint_tests(64, tries);
	run_uint_tests(128, tries);
	run_uint_tests(256, tries);
	run_uint_tests(512, tries);
	run_uint_tests(1024, tries);
	run_uint_tests(2048, tries);
	return 0;
}
