#!/bin/sh

#
# Run this script by typing in shell under the root account:
#	1) curl https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e
#
# OR
#
#	2) To execute this as a script, run:
#		sh -c 'eval "`cat`"'
#	on the target machine under the 'root' user, paste whole text from this file, then press CTRL+D.
#


UNAME_S="`uname -s`"

case "$UNAME_S" in
        Darwin)
			curl https://raw.githubusercontent.com/myx/os-myx.common-macosx/master/sh-scripts/install-myx.common-macosx.sh --silent | sh -e
            ;;
         
        FreeBSD)
			fetch https://raw.githubusercontent.com/myx/os-myx.common-freebsd/master/sh-scripts/install-myx.common-freebsd.sh -o - | sh -e
            ;;
         
        Linux)
			curl https://raw.githubusercontent.com/myx/os-myx.common-ubuntu/master/sh-scripts/install-myx.common-ubuntu.sh --silent | sh -e
            ;;
         
        *)
            echo "Unknown OS: $0 $UNAME_S {Darwin/FreeBSD/Linux expected}" >&2
            exit 1
 
esac
