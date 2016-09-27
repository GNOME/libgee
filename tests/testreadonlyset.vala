/* testreadonlyset.vala
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
 * 	Tomaž Vajngerl <quikee@gmail.com>
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

using Gee;

public class ReadOnlySetTests : ReadOnlyCollectionTests {

	public ReadOnlySetTests () {
		base.with_name ("ReadOnlySet");
	}

	public override void set_up () {
		test_collection = new HashSet<string> ();
		ro_collection = get_ro_view (test_collection);
	}

	public override void tear_down () {
		test_collection = null;
		ro_collection = null;
	}

	protected override Collection<string> get_ro_view (Collection<string> collection) {
		return ((Gee.Set<string>) collection).read_only_view;
	}
}
