#!/bin/sh

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

ORIGDIR=`pwd`
cd $srcdir

# Automake requires that ChangeLog exists.
touch ChangeLog

REQUIRED_M4MACROS=introspection.m4 \
	REQUIRED_AUTOMAKE_VERSION=1.11 \
	gnome-autogen.sh "$@" || exit 1
cd $ORIGDIR || exit $?

