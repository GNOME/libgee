include $(top_srcdir)/Makefile.decl

NULL =

AM_CPPFLAGS = \
	$(GLIB_CFLAGS) \
	$(COVERAGE_CFLAGS) \
	$(NULL)

BUILT_SOURCES = gee.vala.stamp

lib_LTLIBRARIES = \
	libgee.la
	$(NULL)

libgee_la_VALASOURCES = \
	abstractcollection.vala \
	abstractlist.vala \
	abstractmap.vala \
	abstractmultimap.vala \
	abstractmultiset.vala \
	abstractqueue.vala \
	abstractset.vala \
	arraylist.vala \
	bidiriterator.vala \
	collection.vala \
	comparable.vala \
	deque.vala \
	functions.vala \
	hashmap.vala \
	hashmultimap.vala \
	hashmultiset.vala \
	hashset.vala \
	iterable.vala \
	iterator.vala \
	linkedlist.vala \
	list.vala \
	listiterator.vala \
	map.vala \
	mapiterator.vala \
	multimap.vala \
	multiset.vala \
	priorityqueue.vala \
	queue.vala \
	readonlycollection.vala \
	readonlylist.vala \
	readonlymap.vala \
	readonlyset.vala \
	set.vala \
	sortedset.vala \
	timsort.vala \
	treemap.vala \
	treemultimap.vala \
	treemultiset.vala \
	treeset.vala \
	$(NULL)

libgee_la_SOURCES = \
	gee.vala.stamp \
	$(libgee_la_VALASOURCES:.vala=.c) \
	$(NULL)

geeincludedir = $(includedir)/gee-1.0

geeinclude_HEADERS = \
	gee.h \
	$(NULL)

AM_VALAFLAGS = \
	-H gee.h --vapi gee-1.0.vapi \
	-h gee-internals.h \
	--internal-vapi gee-internals-1.0.vapi \
	--library gee-1.0 --gir Gee-1.0.gir \
	$(COVERAGE_VALAFLAGS) \
	$(VALAFLAGS) \
	$(NULL)

Gee-1.0.gir gee-internals-1.0.vapi gee-1.0.vapi gee.vala.stamp: $(libgee_la_VALASOURCES)
	$(VALAC) -C $(AM_VALAFLAGS) $^
	touch $@

libgee_la_LIBADD = \
	$(GLIB_LIBS) \
	$(COVERAGE_LIBS) \
	$(NULL)

libgee_la_LDFLAGS = -version-info $(LIBGEE_LT_VERSION) -no-undefined

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	gee-1.0.vapi \
	$(NULL)

if HAVE_INTROSPECTION
girdir = @INTROSPECTION_GIRDIR@

gir_DATA = \
	Gee-1.0.gir \
	$(NULL)

typelibdir = @INTROSPECTION_TYPELIBDIR@
typelib_DATA = \
	Gee-1.0.typelib \
	$(NULL)

Gee-1.0.typelib: Gee-1.0.gir
	@INTROSPECTION_COMPILER@ --shared-library=libgee -o $@ $^
endif

EXTRA_DIST += $(libgee_la_VALASOURCES) gee-1.0.vapi Gee-1.0.gir gee.vala.stamp

MAINTAINERCLEANFILES = \
	$(libgee_la_VALASOURCES:.vala=.c) \
	gee.vala.stamp \
	gee-internals-1.0.vapi \
	gee-1.0.vapi \
	Gee-1.0.gir \
	gee.h \
	gee-internals.h \
	$(NULL)

CLEANFILES = \
	Gee-1.0.typelib \
	$(NULL)

