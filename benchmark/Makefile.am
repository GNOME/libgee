include $(top_srcdir)/Makefile.decl

NULL =

AM_CPPFLAGS = \
	-I$(top_srcdir)/gee \
	$(GLIB_CFLAGS) \
	$(NULL)

AM_LDFLAGS = \
	-lm
	$(NULL)

noinst_PROGRAMS = benchmarks

progs_ldadd = $(GLIB_LIBS) ../gee/libgee.la

BUILT_SOURCES = benchmarks.vala.stamp

benchmarks_VALASOURCES = \
	benchmark.vala \
	benchmarksorts.vala \
	mergesort.vala \
	$(NULL)

benchmarks_SOURCES = benchmarks.vala.stamp $(benchmarks_VALASOURCES:.vala=.c)
benchmarks.vala.stamp: $(benchmarks_VALASOURCES)
	$(VALAC) -C --basedir $(top_srcdir) --vapidir $(top_srcdir)/gee --pkg gee-internals-1.0 $^
	touch $@
benchmarks_LDADD = $(progs_ldadd)
EXTRA_DIST += $(benchmarks_VALASOURCES)

MAINTAINERCLEANFILES = \
	$(benchmarks_VALASOURCES:.vala=.c) \
	benchmarks.vala.stamp \
	$(NULL)

