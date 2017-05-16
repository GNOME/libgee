bsources = files([
	'benchmark.vala',
	'benchmarksorts.vala'
])

c = meson.get_compiler ('c')
lm = c.find_library ('m', required : false)


touch = find_program ('touch')
fakevapi = custom_target ('fake_internal_vapi',
	output : 'fake.vapi',
	command : [
		touch,
		'@OUTPUT@'
	],
	depends : gee)
fakevapi_dep = declare_dependency (sources : fakevapi)

gee_objects = gee.extract_all_objects ()

benchmarks = executable('benchmarks',
	bsources,
	vala_args : [
		join_paths (meson.build_root (), 'gee', 'gee-internals-0.8.vapi')
	],
	objects : gee_objects,
	dependencies : [ gio, include_utils_h_dir_dep, includehdir_dep, lm, fakevapi_dep ],
)

benchmark ('benchmarks', benchmarks)
