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
#	   wget -O - https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e
#	   fetch -o - https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e   
#
# OR
#
#	3) `(which curl > /dev/null && echo 'curl -L') || (which fetch > /dev/null && echo 'fetch -o -') || (which wget > /dev/null && echo 'wget -O -') || (echo echo "ERROR: Can't Fetch" >&2 && false)` https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e
# 



FetchStdout(){
	local URL="$1"
	[ ! -z "$URL" ] || (echo "FetchStdout: The URL is required!" ; exit 1)
	set -e

	if [ ! -z "`which curl || true`" ]  ; then curl --silent -L "$URL"  ; return 0 ; fi
	if [ ! -z "`which fetch || true`" ] ; then fetch -o - "$URL"        ; return 0 ; fi
	if [ ! -z "`which wget || true`" ]  ; then wget --quiet -O - "$URL" ; return 0 ; fi

	echo "ERROR: curl, fetch or wget were not found, do not know how to download!"
	exit 1
}

if test `id -u` = 0 ; then 
	echo "installer is in 'root' mode, will install/change os packages/settings..."
	
	case "`uname -s`" in
	        Darwin)
	       		echo "Using: macosx"
	        	FETCH="https://github.com/myx/os-myx.common-macosx/archive/master.tar.gz"
	        	UPACK(){ tar -xzf - --strip-components 3 -C "$1" '**/host/tarball/*' ; }
	        	CHOWN="root:wheel"
				;;
	        FreeBSD)
	       		echo "Using: freebsd"
	        	FETCH="https://github.com/myx/os-myx.common-freebsd/archive/master.tar.gz"
	        	UPACK(){ tar -xzf - --strip-components 3 -C "$1" '**/host/tarball/*' ; }
	        	CHOWN="root:wheel"
				;;
	        Linux)
	        	if [ -z "$FETCH" -a ! -z "`which apt || true`" ] ; then
	        		echo "Using: linux + apt"
		        	FETCH="https://github.com/myx/os-myx.common-ubuntu/archive/master.tar.gz"
		        	UPACK(){ tar -xzf - --strip-components=3 -C "$1" --wildcards '**/host/tarball/*' ; }
		        	CHOWN="root:adm"
		        fi
	            if [ -z "$FETCH" ] ; then
	            	echo "Unknown Linux: $0 '`uname -a`' {'apt' is expected}" >&2
	            	exit 1
	            fi
				;;
	        *)
	            echo "Unknown OS: $0 '`uname -s`' {Darwin/FreeBSD/Linux expected}" >&2
	            echo "  Can't choose OS for you. If you wish to forcefully " >&2
	            echo "  install particular version, try:" >&2
				echo "  - macosx:  curl --silent -L https://raw.githubusercontent.com/myx/os-myx.common-macosx/master/sh-scripts/install-myx.common-macosx.sh | sh -e" >&2
				echo "  - ubuntu:  wget -O - https://raw.githubusercontent.com/myx/os-myx.common-ubuntu/master/sh-scripts/install-myx.common-ubuntu.sh | sh -e" >&2
				echo "  - freebsd: fetch -o - https://raw.githubusercontent.com/myx/os-myx.common-freebsd/master/sh-scripts/install-myx.common-freebsd.sh | sh -e" >&2
	            exit 1
	esac

	
   	RSYNC(){ tar -cpf - -C "$1" `ls "$1"` | tar -xvpf - -C "/usr/local/" ; }
   	
   	T_DIR="`mktemp -d`"
	FetchStdout https://github.com/myx/os-myx.common/archive/master.tar.gz | UPACK "$T_DIR"
	FetchStdout "$FETCH" | UPACK "$T_DIR"
	RSYNC "$T_DIR"
	rm -rf "$T_DIR"
	
	
	chown $CHOWN "/usr/local/bin/myx.common"
	chmod 755 "/usr/local/bin/myx.common"
	
	chown -R $CHOWN "/usr/local/share/myx.common/bin"
	chmod -R 755 "/usr/local/share/myx.common/bin"
	
	# exec "/usr/local/share/myx.common/bin/reinstall"
	
	#
	# completion for root in bash:
	# 		myx.common setup/completion
	#
else
	echo "installer is in 'user' mode..."

	test -x "/usr/local/bin/myx.common" || (echo "System-wide 'myx.common' is already installed, skipping (in 'user' mode)."; exit 0)
	test ! -z "`which myx.common`" || (echo "'myx.common' is required, can't proceed in 'user' mode!"; exit 1)
fi
