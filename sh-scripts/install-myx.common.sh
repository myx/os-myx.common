#!/bin/sh

#
# Run this script by typing in shell under the root account:
#	1) To execute this as a script, run:
#		sh -c 'eval "`cat`"'
#	on the target machine under the 'root' user, paste whole text from this file, then press CTRL+D.
#
# OR
#
#	2) curl -L https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e
#
#


#
# Check user
#
test `id -u` != 0 && echo 'ERROR: Must be root!' && exit 1


UNAME_S="`uname -s`"

case "$UNAME_S" in
        Darwin)
        	FETCH="curl --silent -L"
			;;
         
        FreeBSD)
        	FETCH="fetch -o -"
			;;
         
        Linux)
        	FETCH="curl --silent -L"
            ;;
         
        *)
            echo "Unknown OS: $0 $UNAME_S {Darwin/FreeBSD/Linux expected}" >&2
            echo "  Can't choose OS for you. If you wish to forcefully " >&2
            echo "  install particular version, try:" >&2
			echo "  - macosx: curl --silent -L https://raw.githubusercontent.com/myx/os-myx.common-macosx/master/sh-scripts/install-myx.common-macosx.sh | sh -e" >&2
			echo "  - ubuntu: curl --silent -L https://raw.githubusercontent.com/myx/os-myx.common-ubuntu/master/sh-scripts/install-myx.common-ubuntu.sh | sh -e" >&2
			echo "  - freebsd: fetch -o - https://raw.githubusercontent.com/myx/os-myx.common-freebsd/master/sh-scripts/install-myx.common-freebsd.sh | sh -e" >&2
            exit 1
 
esac


$FETCH https://github.com/myx/os-myx.common/archive/master.zip | \
		tar -xzvf - --cd "/usr/local/" --include "*/host/tarball/*" --strip-components 3

$FETCH https://github.com/myx/os-myx.common-macosx/archive/master.zip | \
		tar -xzvf - --cd "/usr/local/" --include "*/host/tarball/*" --strip-components 3


chown root:wheel "/usr/local/bin/myx.common"
chmod 755 "/usr/local/bin/myx.common"

chown -R root:wheel "/usr/local/share/myx.common/bin"
chmod -R 750 "/usr/local/share/myx.common/bin"

# exec "/usr/local/share/myx.common/bin/reinstall"

#
# completion for root in bash:
# 		myx.common setup/console
#
