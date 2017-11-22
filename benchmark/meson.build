bsources = files([
	'benchmark.vala',
	'benchmarksorts.vala'
])
bsources += valasources

c = meson.get_compiler ('c')
lm = c.find_library ('m', required : false)

benchmarks = executable('benchmarks',
	bsources,
	vala_args : [
		'--pkg=geeutils'
	],
	dependencies : [ gio, include_utils_h_dir_dep, includehdir_dep, lm ],
)

benchmark ('benchmarks', benchmarks)
