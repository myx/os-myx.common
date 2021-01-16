#!/bin/sh

if [ -z "$MMDAPP" ] ; then
	set -e
	export MMDAPP="$( cd $(dirname "$0")/../../../../../.. ; pwd )"
	echo "$0: Working in: $MMDAPP"  >&2
	[ -d "$MMDAPP/source" ] || ( echo "ERROR: expecting 'source' directory." >&2 && exit 1 )
fi

if test `id -u` != 0 ; then
	set -e
	echo "Needs to be root, sudo or CTRL+C: "
	sudo "$0" "$@"
	exit 0
fi 

ACTION="$MMDAPP/source/myx/myx.common/os-myx.common/host/tarball/share/myx.common/bin/install/myx.common-reinstall"
[ -f "$ACTION" ] || ( echo "ERROR: expecting 'action' script." >&2 && exit 1 )

. "$ACTION"

MyxCommonReinstall