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
       testcomparable.vala \
       testdeque.vala \
       testhashmap.vala \
       testhashmultimap.vala \
       testhashmultiset.vala \
       testhashset.vala \
       testlinkedlist.vala \
       testlinkedlistasdeque.vala \
       testlist.vala \
       testmain.vala \
       testmap.vala \
       testmultimap.vala \
       testmultiset.vala \
       testpriorityqueue.vala \
       testqueue.vala \
       testreadonlycollection.vala \
       testreadonlylist.vala \
       testreadonlymap.vala \
       testreadonlyset.vala \
       testset.vala \
       testsortedset.vala \
       testtreemap.vala \
       testtreemultiset.vala \
       testtreeset.vala \
       $(NULL)

tests_DEPENDENCIES = $(top_srcdir)/gee/gee-1.0.vapi

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
		"/usr/include/*" "*.c" "*.h" "*.vapi"

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
