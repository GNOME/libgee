benchmark_exec = executable(
    'benchmarks',
    'benchmark.vala',
    'benchmarksorts.vala',
    dependencies : [gee_internal_dep, m_dep],
    build_by_default: false,
)

benchmark(
    'gee',
    benchmark_exec,
    args: [
        '--run-sort',
    ],
)
