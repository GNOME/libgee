AC_INIT([libgee], [0.5.1], [ptitjes@free.fr], [libgee])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
AC_PROG_LIBTOOL

LIBGEE_LT_VERSION="2:0:0"
AC_SUBST(LIBGEE_LT_VERSION)

AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)

AC_SUBST(VALAFLAGS)
AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

AC_ARG_ENABLE(doc, AS_HELP_STRING([--enable-doc], [Enable documentation generation]), enable_doc=$enableval, enable_doc=no)
AM_CONDITIONAL(ENABLE_DOC, test x$enable_doc = xyes)

AS_IF([test "x$enable_doc" != xno],
	[AC_PATH_PROG(VALADOC, valadoc, :)
	 AC_SUBST(VALADOC)
	 AS_IF([test "$VALADOC" = :],
		[AC_MSG_ERROR([valadoc not found])])])

AC_ARG_ENABLE(coverage,
	AS_HELP_STRING([--enable-coverage],
	[compile with coverage profiling and debug (gcc only)]),
	enable_coverage=$enableval,enable_coverage=no)
AM_CONDITIONAL(ENABLE_COVERAGE, test x$enable_coverage != xno)

AS_IF([test "x$enable_coverage" != xno],
	[COVERAGE_CFLAGS="-fprofile-arcs -ftest-coverage"
	 COVERAGE_VALAFLAGS="-g"
	 COVERAGE_LIBS="-lgcov"
	 AC_SUBST(COVERAGE_CFLAGS)
	 AC_SUBST(COVERAGE_VALAFLAGS)
	 AC_SUBST(COVERAGE_LIBS)
	 
	 AC_PATH_PROG(LCOV, lcov, :)
	 AC_SUBST(LCOV)
	 AS_IF([test "$LCOV" = :],
		[AC_MSG_ERROR([lcov is necessary for testing code coverage (http://ltp.sourceforge.net/coverage/lcov.php)])])])

AC_ARG_ENABLE(benchmark, AS_HELP_STRING([--enable-benchmark], [Enable benchmark]), enable_benchmark=$enableval, enable_benchmark=no)
AM_CONDITIONAL(ENABLE_BENCHMARK, test x$enable_benchmark = xyes)

GLIB_REQUIRED=2.12.0

PKG_CHECK_MODULES(GLIB, glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

AC_CONFIG_FILES([Makefile
           gee-1.0.pc
           benchmark/Makefile
           doc/Makefile
           gee/Makefile
           tests/Makefile])
AC_OUTPUT
