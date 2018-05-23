#!/bin/sh

if [ -z "$APP" ] ; then
	set -e
	APP="$( cd $(dirname "$0")/../../../../../.. ; pwd )"
	echo "$0: Working in: $APP"  >&2
	[ -d "$APP/source" ] || ( echo "expecting 'source' directory." >&2 && exit 1 )
fi

if test `id -u` != 0 ; then
	set -e
	echo "Needs to be root, sudo or CTRL+C: "
	sudo "$0" "$@"
	exit 0
fi 

ACTION="$APP/source/myx/myx.common/os-myx.common/host/tarball/share/myx.common/bin/install/myx.common-reinstall"
[ -f "$ACTION" ] || ( echo "expecting 'action' script." >&2 && exit 1 )

. "$ACTION"

MyxCommonReinstall