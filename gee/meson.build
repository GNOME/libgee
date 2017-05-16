
# TODO: port to use API_VERSION in namespace declaration
#nsinfo = configure_file(input : 'namespace-info.vala.in',
#	output : 'namespace-info.vala',
#	configuration : conf)
#namespaceinfo_dep = declare_dependency (sources : nsinfo)

# TODO: Add translation support
#confh = configuration_data ()
#confh.set_quoted('PACKAGE_LOCALE_DIR', join_paths(get_option('prefix'), get_option('datadir'), 'locale'))
#confh.set_quoted('GETTEXT_PACKAGE', 'GXml')
#configure_file(output : 'config.h',
#	configuration : confh)

valasources = files ([
	'assemblyinfo.vala',
	'abstractbidirlist.vala',
	'abstractbidirsortedset.vala',
	'abstractbidirsortedmap.vala',
	'abstractcollection.vala',
	'abstractlist.vala',
	'abstractmap.vala',
	'abstractmultimap.vala',
	'abstractmultiset.vala',
	'abstractqueue.vala',
	'abstractset.vala',
	'abstractsortedmap.vala',
	'abstractsortedset.vala',
	'arraylist.vala',
	'arrayqueue.vala',
	'bidiriterator.vala',
	'bidirlist.vala',
	'bidirlistiterator.vala',
	'bidirmapiterator.vala',
	'bidirsortedset.vala',
	'bidirsortedmap.vala',
	'collection.vala',
	'comparable.vala',
	'concurrentlist.vala',
	'concurrentset.vala',
	'deque.vala',
	'functions.vala',
	'future.vala',
	'hashable.vala',
	'hashmap.vala',
	'hashmultimap.vala',
	'hashmultiset.vala',
	'hashset.vala',
	'hazardpointer.vala',
	'iterable.vala',
	'iterator.vala',
	'lazy.vala',
	'linkedlist.vala',
	'lightmapfuture.vala',
	'list.vala',
	'listiterator.vala',
	'map.vala',
	'mapiterator.vala',
	'multimap.vala',
	'multiset.vala',
	'priorityqueue.vala',
	'promise.vala',
	'queue.vala',
	'readonlybidirlist.vala',
	'readonlybidirsortedset.vala',
	'readonlybidirsortedmap.vala',
	'readonlycollection.vala',
	'readonlylist.vala',
	'readonlymap.vala',
	'readonlymultimap.vala',
	'readonlymultiset.vala',
	'readonlyset.vala',
	'readonlysortedmap.vala',
	'readonlysortedset.vala',
	'set.vala',
	'sortedmap.vala',
	'sortedset.vala',
	'streamiterator.vala',
	'task.vala',
	'teeiterator.vala',
	'timsort.vala',
	'traversable.vala',
	'treemap.vala',
	'treemultimap.vala',
	'treemultiset.vala',
	'treeset.vala',
	'unfolditerator.vala',
	'unrolledlinkedlist.vala'
])

sources = files ([])

includehdir = include_directories ('.')
includehdir_dep = declare_dependency (include_directories : includehdir)

gee = library('gee-@0@'.format(API_VERSION),
	valasources + sources,
	version : PROJECT_VERSION,
	vala_header : 'gee.h',
	vala_vapi : 'gee-@0@.vapi'.format(API_VERSION),
	vala_gir : 'Gee-@0@.gir'.format(API_VERSION),
	vala_args : [ '--pkg', 'geeutils'],
	vala_internal_header : 'gee-internals.h',
	vala_internal_vapi : 'gee-internals-0.8.vapi',
	dependencies : [ gio, include_utils_h_dir_dep ],
	install : true,
	install_dir : [
		get_option('libdir'),
		join_paths (get_option('includedir'),'gee-@0@'.format (API_VERSION)),
		true,
		true,
		false,
		false
	])

g_ir_compiler = find_program('g-ir-compiler')
custom_target('typelib',
	command: [
		g_ir_compiler,
		'--shared-library', 'libgee-@0@.so'.format (API_VERSION),
		'--output', '@OUTPUT@',
		join_paths(meson.current_build_dir(), 'Gee-@0@.gir'.format(API_VERSION))
	],
	output: 'Gee-@0@.typelib'.format(API_VERSION),
	depends: gee,
	install: true,
	install_dir: join_paths(get_option('libdir'), 'girepository-1.0'))
