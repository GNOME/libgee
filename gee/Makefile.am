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
	timsort.vala \
	treemap.vala \
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

gee-1.0.vapi gee.vala.stamp: $(libgee_la_VALASOURCES)
	$(VALAC) -C $(AM_VALAFLAGS) $^
	touch $@

libgee_la_LIBADD = \
	$(GLIB_LIBS) \
	$(COVERAGE_LIBS) \
	$(NULL)

libgee_la_LDFLAGS = -version-info 1:0:0

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	gee-1.0.vapi \
	$(NULL)

girdir = $(datadir)/gir-1.0

dist_gir_DATA = \
	Gee-1.0.gir \
	$(NULL)

EXTRA_DIST += $(libgee_la_VALASOURCES) gee-1.0.vapi Gee-1.0.gir gee.vala.stamp
