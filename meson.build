project(
    'libgee',
    'vala',
    'c',
    version: '0.20.8',
    meson_version: '>= 1.4.0',
)
api_version = '0.8'

pkgconfig = import('pkgconfig')

glib_minimal_version = '2.36'
glib_dep = dependency('glib-2.0', version: f'>=@glib_minimal_version@')
gobject_dep = dependency('gobject-2.0', version: f'>=@glib_minimal_version@')
gio_dep = dependency('gio-2.0', version: f'>=@glib_minimal_version@')
m_dep = meson.get_compiler('c').find_library('m', required: false)
posix_dep = meson.get_compiler('vala').find_library('posix')
valadoc = find_program('valadoc', required: get_option('documentation'))

# ABI version. Changes independently of API version.
# See: https://autotools.io/libtool/version.html
# https://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
# The rules are fiddly, and are summarized here.
abi_current = 8 # inc when add/remove/change interfaces
abi_revision = 1 # increment on every release
abi_age = 6 # inc only if changes backward compat
abi_soname_version = abi_current - abi_age
abi_version_info = f'@abi_soname_version@.@abi_age@.@abi_revision@'

add_project_arguments(
    [
        '--hide-internal',
        '--target-glib=' + glib_minimal_version,
    ],
    language: 'vala',
)

if not get_option('internal-asserts')
    add_project_arguments('--define=DISABLE_INTERNAL_ASSERTS', language: 'vala')
endif

if get_option('consistency-check')
    add_project_arguments('--define=CONSISTENCY_CHECKS', language: 'vala')
endif

subdir('utils')
subdir('gee')
subdir('benchmark')
subdir('tests')
if valadoc.found()
    subdir('doc')
endif
