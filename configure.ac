AC_INIT([libgee], [0.15.90], [https://bugzilla.gnome.org/enter_bug.cgi?product=libgee], [libgee])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([1.11 check-news dist-xz no-dist-gzip tar-ustar])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
AC_PROG_LIBTOOL

LIBGEE_LT_VERSION="6:0:4"
AC_SUBST(LIBGEE_LT_VERSION)

GLIB_REQUIRED=2.36

VALA_ADD_CHECKFILE([gee/libgee_0_8_la_vala.stamp])
VALA_ADD_CHECKFILE([tests/tests_vala.stamp])
VALA_ADD_VALAFLAGS(--target-glib=$GLIB_REQUIRED)
VALA_ADD_VALAFLAGS(--hide-internal)

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
AS_IF([test x$enable_benchmark = xyes],
      [VALA_ADD_CHECKFILE([benchmark/benchmarks_vala.stamp])])

PKG_CHECK_MODULES(GLIB, glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >= $GLIB_REQUIRED gio-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

AC_ARG_ENABLE(internal-asserts, [AS_HELP_STRING([--disable-internal-asserts], [Disables the internal asserts]))],
              enable_internal_asserts=$enableval, enable_internal_asserts=yes)
AS_IF([test "x$enable_internal_asserts" = xno], [VALA_ADD_VALAFLAGS(-D DISABLE_INTERNAL_ASSERTS)])

AC_ARG_ENABLE(consistency-check, [AS_HELP_STRING([--enable-consistency-check], [Enables (very) expensive consistency checks. It might affect the asymptotic performance.])],
              enable_consistency_check=$enableval, enable_internal_asserts=no)
AS_IF([test "x$enable_consistency_check" != xno], [VALA_ADD_VALAFLAGS(-D CONSISTENCY_CHECKS)])

GOBJECT_INTROSPECTION_CHECK([0.9.0])

#Checks if valac is at least > 0.24.0
AM_PROG_VALAC([0.24.0.1],,[AC_MSG_ERROR([valac version is outdated])])

AC_OUTPUT([Makefile
           gee-0.8.pc
           benchmark/Makefile
           doc/Makefile
           gee/Makefile
           tests/Makefile])
