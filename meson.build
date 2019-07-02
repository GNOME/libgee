project('libgee', 'c', 'vala', version: '0.20.1')
api_version = '0.8'

glib_minimal_version = '2.36'
glib_dep = dependency('glib-2.0', version: '>='+glib_minimal_version)
gobject_dep = dependency('gobject-2.0', version: '>='+glib_minimal_version)
gio_dep = dependency('gio-2.0', version: '>='+glib_minimal_version)
m_dep = meson.get_compiler('c').find_library('m', required : false)
posix_dep = meson.get_compiler('vala').find_library('posix')

add_project_arguments([
        '--hide-internal',
        '--target-glib='+glib_minimal_version,
    ],
    language: 'vala'
)

if get_option('internal-asserts')
    add_project_arguments('--define=DISABLE_INTERNAL_ASSERTS', language: 'vala')
endif

if get_option('consistency-check')
    add_project_arguments('--define=CONSISTENCY_CHECKS', language: 'vala')
endif

conf = configuration_data()
conf.set('prefix', get_option('prefix'))
conf.set('exec_prefix', get_option('prefix'))
conf.set('libdir', '${exec_prefix}/'+get_option ('libdir'))
conf.set('includedir', '${exec_prefix}/'+get_option('includedir'))
conf.set('datadir', '${exec_prefix}/'+get_option('datadir'))
conf.set('datarootdir', '${exec_prefix}/'+get_option('datadir'))
conf.set('VERSION', meson.project_version())

configure_file(input : 'gee-0.8.pc.in',
	output : 'gee-0.8.pc',
	configuration : conf,
	install : true,
	install_dir : join_paths(get_option('libdir'), 'pkgconfig'))

subdir('utils')
subdir('gee')
subdir('benchmark')
subdir('tests')
if get_option('documentation')
    subdir('doc')
endif
