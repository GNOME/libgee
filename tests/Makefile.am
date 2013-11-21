include $(top_srcdir)/Makefile.decl

noinst_PROGRAMS = $(TEST_PROGS)

TEST_PROGS += tests

tests_VALASOURCES = \
       testarraylist.vala \
       testarrayqueue.vala \
       testbidirlist.vala \
       testbidirsortedset.vala \
       testbidirsortedmap.vala \
       testcase.vala \
       testcollection.vala \
       testconcurrentlist.vala \
       testconcurrentset.vala \
       testdata.vala \
       testdeque.vala \
       testfunctions.vala \
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
       testreadonlybidirlist.vala \
       testreadonlycollection.vala \
       testreadonlylist.vala \
       testreadonlymap.vala \
       testreadonlyset.vala \
       testset.vala \
       testsortedset.vala \
       testsortedmap.vala \
       testtreemap.vala \
       testtreemultimap.vala \
       testtreemultiset.vala \
       testtreeset.vala \
       testunrolledlinkedlist.vala \
       testunrolledlinkedlistasdeque.vala \
       $(NULL)

tests_SOURCES = \
	$(tests_VALASOURCES:.vala=.c) \
	$(NULL)

tests_DEPENDENCIES = \
	$(top_srcdir)/gee/gee-0.8.vapi \
	tests_vala.stamp \
	$(NULL)

tests_CFLAGS = \
	-w \
	$(NULL)

tests_CPPFLAGS = \
	-I$(top_srcdir)/gee \
	$(GLIB_CFLAGS) \
	$(NULL)

tests_LDADD = \
	$(GLIB_LIBS) ../gee/libgee-0.8.la \
	$(NULL)

tests_VALAFLAGS = \
	--basedir $(top_srcdir) \
	--vapidir $(top_srcdir)/gee \
	--pkg gee-0.8 --pkg posix \
	$(VALAFLAGS) \
	$(NULL)

tests_vala.stamp: $(tests_VALASOURCES)
	$(AM_V_VALAC)$(VALAC) $(VALAFLAGS) $(tests_VALAFLAGS) -C $(tests_VALASOURCES)
	@touch tests_vala.stamp

$(tests_VALASOURCES:.vala=.c): tests_vala.stamp

MOSTLYCLEANFILES = \
	$(tests_VALASOURCES:.vala=.c) \
	tests_vala.stamp \
	$(NULL)

EXTRA_DIST += \
	$(tests_VALASOURCES) \
	tests_vala.stamp \
	$(NULL)

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
