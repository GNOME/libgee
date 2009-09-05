include $(top_srcdir)/Makefile.decl

NULL =

AM_CPPFLAGS = \
	-I$(top_srcdir)/gee \
	$(GLIB_CFLAGS) \
	$(NULL)

noinst_PROGRAMS = $(TEST_PROGS)

progs_ldadd = $(GLIB_LIBS) ../gee/libgee.la

BUILT_SOURCES = tests.vala.stamp

TEST_PROGS += tests
tests_VALASOURCES = \
       testarraylist.vala \
       testcollection.vala \
       testlist.vala \
       testcase.vala \
       testmain.vala \
       $(NULL)

tests_SOURCES = tests.vala.stamp $(tests_VALASOURCES:.vala=.c)
tests.vala.stamp: $(tests_VALASOURCES)
	$(VALAC) -C --basedir $(top_srcdir) --vapidir $(top_srcdir)/gee --pkg gee-1.0 $^
	touch $@
tests_LDADD = $(progs_ldadd)
EXTRA_DIST += $(tests_VALASOURCES)

TEST_PROGS += testhashmap
testhashmap_VALASOURCES = testhashmap.vala
testhashmap_SOURCES = testhashmap.c
$(testhashmap_SOURCES): $(testhashmap_VALASOURCES)
	$(VALAC) -C --basedir $(top_srcdir) --vapidir $(top_srcdir)/gee --pkg gee-1.0 $^
	touch $@
testhashmap_LDADD = $(progs_ldadd)
EXTRA_DIST += $(testhashmap_VALASOURCES)

TEST_PROGS += testhashset
testhashset_VALASOURCES = testhashset.vala
testhashset_SOURCES = testhashset.c
$(testhashset_SOURCES): $(testhashset_VALASOURCES)
	$(VALAC) -C --basedir $(top_srcdir) --vapidir $(top_srcdir)/gee --pkg gee-1.0 $^
	touch $@
testhashset_LDADD = $(progs_ldadd)
EXTRA_DIST += $(testhashset_VALASOURCES)

TEST_PROGS += testlinkedlist
testlinkedlist_VALASOURCES = testlinkedlist.vala
testlinkedlist_SOURCES = testlinkedlist.c
$(testlinkedlist_SOURCES): $(testlinkedlist_VALASOURCES)
	$(VALAC) -C --basedir $(top_srcdir) --vapidir $(top_srcdir)/gee --pkg gee-1.0 $^
	touch $@
testlinkedlist_LDADD = $(progs_ldadd)
EXTRA_DIST += $(testlinkedlist_VALASOURCES)

TEST_PROGS += testtreeset
testtreeset_VALASOURCES = testtreeset.vala
testtreeset_SOURCES = testtreeset.c testtreeset.h
$(testtreeset_SOURCES): $(testtreeset_VALASOURCES)
	$(VALAC) -C --basedir $(top_srcdir) --vapidir $(top_srcdir)/gee --pkg gee-1.0 $^
	touch $@
testtreeset_LDADD = $(progs_ldadd)
EXTRA_DIST += $(testtreeset_VALASOURCES)

TEST_PROGS += testtreemap
testtreemap_VALASOURCES = testtreemap.vala
testtreemap_SOURCES = testtreemap.c testtreemap.h
$(testtreemap_SOURCES): $(testtreemap_VALASOURCES)
	$(VALAC) -C --basedir $(top_srcdir) --vapidir $(top_srcdir)/gee --pkg gee-1.0 $^
	touch $@
testtreemap_LDADD = $(progs_ldadd)
EXTRA_DIST += $(testtreemap_VALASOURCES)

