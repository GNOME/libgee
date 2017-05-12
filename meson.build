project('libgee', [ 'vala', 'c'])

gio = dependency('gio-2.0')

VALADEPS = 'gio-2.0'
PCDEPS = 'gio-2.0'

API_VERSION = '0.8'
PROJECT_VERSION = '0.20.0'

conf = configuration_data()
conf.set('prefix', get_option('prefix'))
conf.set('exec_prefix', get_option('prefix'))
conf.set('libdir', join_paths (get_option ('prefix'),get_option ('libdir')))
conf.set('includedir', get_option ('includedir'))
conf.set('VALADEPS', VALADEPS)
conf.set('PCDEPS', PCDEPS)
conf.set('VERSION', PROJECT_VERSION)
conf.set('API_VERSION', API_VERSION)

configure_file(input : 'gee-0.8.pc.in',
	output : 'gee-@0@.pc'.format(API_VERSION),
	configuration : conf,
	install : true,
	install_dir : join_paths(get_option('libdir'), 'pkgconfig'))

vapidir = join_paths (get_option('datadir'),'vala','vapi')

configure_file(input : 'gee.deps.in',
	output : 'gee-@0@.deps'.format(API_VERSION),
	configuration : conf,
	install : true,
	install_dir : vapidir)



subdir('utils')
subdir('gee')
#subdir('doc')
#subdir('tests')
