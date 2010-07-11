#!/bin/sh

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

ORIGDIR=`pwd`
cd $srcdir

# Automake requires that ChangeLog exists.
touch ChangeLog

gnome-autogen.sh || exit 1
cd $ORIGDIR || exit $?

if test -z "$NOCONFIGURE"; then
  $srcdir/configure "$@"
fi
