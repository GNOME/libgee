utils_dir = meson.project_source_root() / 'utils'

valadoc_dir = gee_name
custom_target(
    'documentation',
    command: [
        valadoc,
        '--directory=' + meson.current_build_dir(),
        '--basedir=' + meson.project_source_root(),
        '--wiki=' + meson.current_source_dir(),
        f'--vapidir=@utils_dir@',
        f'--package-name=@gee_name@',
        '--package-version=' + meson.project_version(),
        '--pkg=geeutils',
        '--pkg=glib-2.0',
        '--pkg=gio-2.0',
        '--pkg=gobject-2.0',
        '--use-svg-images',
        '--force',
        '-o', meson.current_build_dir() / valadoc_dir,
        '@INPUT@',
    ],
    output: valadoc_dir,
    input: gee_files,
    install: true,
    install_dir: get_option('datadir') / 'doc',
)
