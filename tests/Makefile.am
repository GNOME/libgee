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
       testcase.vala \
       testcollection.vala \
       testdeque.vala \
       testhashmultimap.vala \
       testhashmultiset.vala \
       testlinkedlist.vala \
       testlinkedlistasdeque.vala \
       testlist.vala \
       testmain.vala \
       testmultimap.vala \
       testmultiset.vala \
       testqueue.vala \
       testreadonlycollection.vala \
       testreadonlylist.vala \
       $(NULL)

tests_SOURCES = tests.vala.stamp $(tests_VALASOURCES:.vala=.c)
tests.vala.stamp: $(tests_VALASOURCES)
	$(VALAC) -C --basedir $(top_srcdir) --vapidir $(top_srcdir)/gee --pkg gee-1.0 $^
	touch $@
tests_LDADD = $(progs_ldadd)
EXTRA_DIST += $(tests_VALASOURCES)

coverage-reset:
	lcov --base-directory=@top_srcdir@ --directory @top_srcdir@/gee --zerocounters

coverage-report:
	lcov --directory @top_srcdir@/gee \
		--capture \
		--output-file @top_builddir@/lcov.info

	lcov --directory @top_srcdir@/gee \
		--output-file @top_builddir@/lcov.info \
		--remove @top_builddir@/lcov.info \
		/usr/include/\*

	$(mkdir_p) @top_builddir@/tests/coverage
	git_commit=`GIT_DIR=@top_srcdir@/.git git log -1 --pretty=format:%h 2>/dev/null`;\
	genhtml --title "@PACKAGE_STRING@ $$git_commit" \
		--output-directory @top_builddir@/tests/coverage @top_builddir@/lcov.info
	@echo
	@echo 'lcov report can be found in:'
	@echo 'file://@abs_top_builddir@/tests/coverage/index.html'
	@echo

clean-local:
	-rm -rf coverage

.PHONY: coverage-report

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

