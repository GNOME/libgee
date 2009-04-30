include $(top_srcdir)/Makefile.decl

NULL =

AM_CPPFLAGS = \
	$(GLIB_CFLAGS) \
	$(NULL)

BUILT_SOURCES = gee.vala.stamp

lib_LTLIBRARIES = \
	libgee.la
	$(NULL)

libgee_la_VALASOURCES = \
	arraylist.vala \
	collection.vala \
	hashmap.vala \
	hashset.vala \
	iterable.vala \
	iterator.vala \
	list.vala \
	map.vala \
	readonlycollection.vala \
	readonlylist.vala \
	readonlymap.vala \
	readonlyset.vala \
	set.vala \
	$(NULL)

libgee_la_SOURCES = \
	gee.vala.stamp \
	$(libgee_la_VALASOURCES:.vala=.c) \
	$(NULL)

geeincludedir = $(includedir)/gee-1.0

geeinclude_HEADERS = \
	gee.h \
	$(NULL)

gee-1.0.vapi gee.vala.stamp: $(libgee_la_VALASOURCES)
	$(VALAC) -C -H gee.h --library gee-1.0 $^
	touch $@

libgee_la_LIBADD = \
	$(GLIB_LIBS) \
	$(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	gee-1.0.vapi \
	$(NULL)

EXTRA_DIST += $(libgee_la_VALASOURCES) gee-1.0.vapi gee.vala.stamp
