#!/bin/sh

#
# Run this script by typing in shell under the root account:
#	curl https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh -o - | sh -e
#

UNAME_S="`uname -s`"

case "$UNAME_S" in
        Darwin)
			curl https://raw.githubusercontent.com/myx/myx.os-macosx/master/sh-scripts/install-myx.common-macosx.sh --silent | sh -e
            ;;
         
        FreeBSD)
            fetch http://myx.ru/distro/farm-general/myx.common/install-bsd.sh -o - | sh -e
			# fetch https://raw.githubusercontent.com/myx/myx.os-freebsd/master/sh-scripts/install-myx.common-freebsd.sh -o - | sh -e
            ;;
         
        Linux)
			curl https://raw.githubusercontent.com/myx/myx.os-ubuntu/master/sh-scripts/install-myx.common-ubuntu.sh --silent | sh -e
            ;;
         
        *)
            echo $"Unknown OS: $0 $UNAME_S {Darwin/FreeBSD/Linux expected}" >&2
            exit 1
 
esac