include $(top_srcdir)/Makefile.decl

NULL =

SUBDIRS = \
	gee \
	tests \
	$(NULL)

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = gee-1.0.pc

dist-hook: gen-ChangeLog

gen_start_date = 2009-04-30
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
	gitlog-to-changelog \
	MAINTAINERS \
	gee-1.0.pc.in \
	$(NULL)

