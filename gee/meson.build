gee_files = files(
    'abstractbidirlist.vala',
    'abstractbidirsortedmap.vala',
    'abstractbidirsortedset.vala',
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
    'assemblyinfo.vala',
    'bidiriterator.vala',
    'bidirlistiterator.vala',
    'bidirlist.vala',
    'bidirmapiterator.vala',
    'bidirsortedmap.vala',
    'bidirsortedset.vala',
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
    'lightmapfuture.vala',
    'linkedlist.vala',
    'listiterator.vala',
    'list.vala',
    'mapiterator.vala',
    'map.vala',
    'multimap.vala',
    'multiset.vala',
    'priorityqueue.vala',
    'promise.vala',
    'queue.vala',
    'readonlybidirlist.vala',
    'readonlybidirsortedmap.vala',
    'readonlybidirsortedset.vala',
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
    'unrolledlinkedlist.vala',
)

gee_name = 'gee-'+api_version
gee_gir = 'Gee-'+api_version+'.gir'
gee_typelib = 'Gee-'+api_version+'.typelib'
gee_deps = [glib_dep, gobject_dep, gio_dep]

gee_lib = library(
    gee_name,
    gee_files,
    soversion: meson.project_version().split('.')[0],
    version: meson.project_version(),
    vala_header: 'gee.h',
    vala_vapi: gee_name+'.vapi',
    vala_gir: gee_gir,
    dependencies: [gee_deps, geeutils_dep],
    install: true,
    install_dir: [true, join_paths(get_option('includedir'), gee_name), true, true],
    vala_args: [
        '--hide-internal',
    ],
)

g_ir_compiler = find_program('g-ir-compiler')
custom_target(
    gee_name + 'typelib',
    command: [g_ir_compiler, '--output', '@OUTPUT@', join_paths(meson.current_build_dir(), gee_gir)],
    output: gee_typelib,
    depends: gee_lib,
    install: true,
    install_dir: join_paths(get_option('libdir'), 'girepository-1.0')
)

gee_dep = declare_dependency(
    link_with: gee_lib,
    dependencies: gee_deps,
    include_directories: include_directories('.')
)

gee_internal_dep = declare_dependency(
    sources: gee_files,
    dependencies: [gee_deps, geeutils_dep],
    include_directories: include_directories('.')
)
