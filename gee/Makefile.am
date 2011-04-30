include $(top_srcdir)/Makefile.decl

lib_LTLIBRARIES = \
	libgee.la
	$(NULL)

libgee_la_SOURCES = \
	abstractcollection.vala \
	abstractlist.vala \
	abstractmap.vala \
	abstractmultimap.vala \
	abstractmultiset.vala \
	abstractqueue.vala \
	abstractset.vala \
	abstractsortedmap.vala \
	abstractsortedset.vala \
	arraylist.vala \
	bidiriterator.vala \
	bidirmapiterator.vala \
	collection.vala \
	comparable.vala \
	deque.vala \
	functions.vala \
	hashable.vala \
	hashmap.vala \
	hashmultimap.vala \
	hashmultiset.vala \
	hashset.vala \
	iterable.vala \
	iterator.vala \
	lazy.vala \
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
	readonlysortedmap.vala \
	readonlysortedset.vala \
	set.vala \
	sortedmap.vala \
	sortedset.vala \
	timsort.vala \
	treemap.vala \
	treemultimap.vala \
	treemultiset.vala \
	treeset.vala \
	$(NULL)

libgee_la_VALAFLAGS = \
	-H gee.h --vapi gee-1.0.vapi \
	-h gee-internals.h \
	--internal-vapi gee-internals-1.0.vapi \
	--library gee-1.0 --gir Gee-1.0.gir \
	$(COVERAGE_VALAFLAGS) \
	$(VALAFLAGS) \
	$(NULL)

libgee_la_CPPFLAGS = \
	$(GLIB_CFLAGS) \
	$(COVERAGE_CFLAGS) \
	$(NULL)

libgee_la_LIBADD = \
	$(GLIB_LIBS) \
	$(COVERAGE_LIBS) \
	$(NULL)

libgee_la_LDFLAGS = \
	-version-info $(LIBGEE_LT_VERSION) \
	-no-undefined \
	$(NULL)

geeincludedir = $(includedir)/gee-1.0

geeinclude_HEADERS = \
	gee.h \
	$(NULL)

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

Gee-1.0.gir gee-internals-1.0.vapi gee-1.0.vapi: libgee.la

CLEANFILES = \
	gee-1.0.vapi \
	gee-internals-1.0.vapi \
	Gee-1.0.typelib \
	Gee-1.0.gir \
	$(NULL)

