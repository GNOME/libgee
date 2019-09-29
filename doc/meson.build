valadoc = find_program('valadoc')
custom_target(
    'documentation',
    command: [
        valadoc,
        '--directory='+meson.current_build_dir(),
        '--basedir='+meson.source_root(),
        '--wiki='+meson.current_source_dir(),
        '--vapidir='+join_paths(meson.source_root(), 'utils'),
        '--package-name='+gee_name,
        '--package-version='+meson.project_version(),
        '--pkg=geeutils',
        '--pkg=glib-2.0',
        '--pkg=gio-2.0',
        '--pkg=gobject-2.0',
        '--use-svg-images',
        '--importdir='+join_paths(glib_dep.get_pkgconfig_variable('prefix'), get_option('datadir'), 'gtk-doc', 'html'),
        '--force',
        '@INPUT@'
    ],
    output: 'index.html',
    input: gee_files,
)
