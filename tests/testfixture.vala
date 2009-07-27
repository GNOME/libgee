/* testfixture.vala
 *
 * Copyright (C) 2009 Julien Peeters
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
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using GLib;

public abstract class TestFixture: Object {

	private TestSuite suite;
	private TestAdaptor[] adaptors = new TestAdaptor[0];

	public delegate void TestMethod ();

	public TestFixture (string name) {
		this.suite = new TestSuite (name);
	}

	public void add_test (string name, TestMethod test) {
		var adaptor = new TestAdaptor (name, test, this);
		this.adaptors += adaptor;

		this.suite.add (new TestCase (adaptor.name,
		                              0,
		                              adaptor.setup,
		                              adaptor.run,
		                              adaptor.teardown ));
	}

	public virtual void setup () {}
	public virtual void teardown () {}

	public TestSuite get_suite () {
		return this.suite;
	}

	public void add_to_suite (TestSuite suite) {
		suite.add_suite (this.suite);
	}

	private class TestAdaptor {

		public string name { set; get; }
		private TestMethod test;
		private TestFixture fixture;

		public TestAdaptor (string name, TestMethod test, TestFixture fixture) {
			this.name = name;
			this.test = test;
			this.fixture = fixture;
		}

		public void setup (void* fixture) {
			this.fixture.setup ();
		}

		public void run (void* fixture) {
			this.test ();
		}

		public void teardown (void* fixture) {
			this.fixture.teardown ();
		}
	}
}
