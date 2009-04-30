#!/bin/sh

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

ORIGDIR=`pwd`
cd $srcdir

# Automake requires that ChangeLog exists.
touch ChangeLog

autoreconf -v --install || exit 1
cd $ORIGDIR || exit $?

$srcdir/configure "$@"
