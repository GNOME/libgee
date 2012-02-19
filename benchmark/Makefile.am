include $(top_srcdir)/Makefile.decl

noinst_PROGRAMS = benchmarks

benchmarks_SOURCES = \
	benchmark.vala \
	benchmarksorts.vala \
	$(NULL)

benchmarks_VALAFLAGS = \
	--basedir $(top_srcdir) \
	--vapidir $(top_srcdir)/gee \
	--pkg gee-internals-0.8 \
	$(NULL)

benchmarks_CPPFLAGS = \
	-I$(top_srcdir)/gee \
	$(GLIB_CFLAGS) \
	$(NULL)

benchmarks_LDADD = \
	$(GLIB_LIBS) \
	../gee/libgee-0.8.la \
	$(NULL)

benchmarks_LDFLAGS = \
	-lm \
	$(NULL)
