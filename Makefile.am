include $(top_srcdir)/Makefile.decl
ACLOCAL_AMFLAGS = --install -I m4
AM_DISTCHECK_CONFIGURE_FLAGS = --enable-introspection=no --enable-vala

if ENABLE_DOC
DOC_SUBDIR = \
	doc \
	$(NULL)
endif

if ENABLE_BENCHMARK
BENCHMARK_SUBDIR = \
	benchmark \
	$(NULL)
endif

SUBDIRS = \
	gee \
	tests \
	$(DOC_SUBDIR) \
	$(BENCHMARK_SUBDIR) \
	$(NULL)

if ENABLE_COVERAGE
coverage:
	$(MAKE) -C tests coverage-reset
	$(MAKE) -C tests test
	$(MAKE) -C tests coverage-report
else
coverage:
	@echo "The project has not been configured for coverage, check that you have gcov, lcov."
	@echo "Of course, do not use --disable-coverage"
	@exit 1
endif
.PHONY: coverage

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = gee-0.8.pc

dist-hook: gen-ChangeLog

gen_start_date = 2009-10-23
.PHONY: gen-ChangeLog
gen-ChangeLog:
	if test -d .git; then						\
	  $(top_srcdir)/gitlog-to-changelog				\
	    --since=$(gen_start_date) > $(distdir)/cl-t;		\
	  rm -f $(distdir)/ChangeLog;					\
	  mv $(distdir)/cl-t $(distdir)/ChangeLog;			\
	fi

EXTRA_DIST += \
	ChangeLog.pre-0-1-5 \
	ChangeLog.pre-0-5-0 \
	gitlog-to-changelog \
	MAINTAINERS \
	gee-0.8.pc.in \
	utils/geeutils.vapi \
	$(NULL)

