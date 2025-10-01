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
#	3) `(which curl > /dev/null && echo 'curl -L') || (which fetch > /dev/null && echo 'fetch -o -') || (which wget > /dev/null && echo 'wget -O -') || (echo echo "⛔ ERROR: Can't Fetch" >&2 && false)` https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e
# 



FetchStdout() {
    : "${1:?"⛔ ERROR: FetchStdout: The URL is required!"}"
    set -e
    command -v curl  >/dev/null 2>&1 && { curl --silent -L "$1"; return 0; }
    command -v fetch >/dev/null 2>&1 && { fetch -o - "$1"; return 0; }
    command -v wget  >/dev/null 2>&1 && { wget --quiet -O - "$1"; return 0; }
    echo "⛔ ERROR: curl, fetch, or wget were not found, do not know how to download!" >&2
    exit 1
}

if [ "$( id -u )" = 0 ]; then 
	echo "installer is in 'root' mode, will install/change os packages/settings..."
	
	case "$( uname -s )" in
	        Darwin)
	       		echo "Using: macosx"
	        	UPACK(){ tar -xzf - --strip-components 3 -C "$1" '**/host/tarball/*' ; }
	        	CHOWN="root:wheel"
				;;
	        FreeBSD)
	       		echo "Using: freebsd"
				pkg bootstrap -y ; [ -n "$( pkg info | grep ca_root )" ] || pkg install -y ca_root_nss
	        	UPACK(){ tar -xzf - --strip-components 3 -C "$1" '**/host/tarball/*' ; }
	        	CHOWN="root:wheel"
				;;
	        Linux)
	        	if [ -z "$FETCH" ] && command -v apt >/dev/null 2>&1; then
	        		echo "Using: linux + apt"
		        	UPACK(){ tar -xzf - --strip-components=3 -C "$1" --wildcards '**/host/tarball/*' ; }
		        	CHOWN="root:adm"
		        elif [ -z "$FETCH" ] ; then
	            	echo "⛔ ERROR: Unknown Linux: $0 '$( uname -a )' {'apt' is expected}" >&2
	            	exit 1
	            fi
				;;
	        *)
	            echo "⛔ ERROR: Unknown OS: $0 '$( uname -s )' {Darwin/FreeBSD/Linux expected}" >&2
	            echo "  Can't choose OS for you. If you wish to forcefully " >&2
	            echo "  install particular version, try:" >&2
				echo "  - macosx:  curl --silent -L https://raw.githubusercontent.com/myx/os-myx.common-macosx/master/sh-scripts/install-myx.common-macosx.sh | sh -e" >&2
				echo "  - ubuntu:  wget -O - https://raw.githubusercontent.com/myx/os-myx.common-ubuntu/master/sh-scripts/install-myx.common-ubuntu.sh | sh -e" >&2
				echo "  - freebsd: fetch -o - https://raw.githubusercontent.com/myx/os-myx.common-freebsd/master/sh-scripts/install-myx.common-freebsd.sh | sh -e" >&2
	            exit 1
	esac

	
   	T_DIR="$( mktemp -t "myx.common-installer-XXXXXXXX" -d )"
	FetchStdout https://github.com/myx/os-myx.common/archive/master.tar.gz | UPACK "$T_DIR"
	
    if command -v rsync >/dev/null 2>&1 && [ -d "/usr/local/share/myx.common/" ] ; then
    	echo "Using: rsync"
    	rsync -rltOi --no-motd "$T_DIR/bin/myx.common" "/usr/local/bin/myx.common" 2>&1 \
		| (grep -v --line-buffered -E '>f\.\.t\.+ ' >&2 || :)
    	rsync -rltOi --no-motd --delete "$T_DIR/share/myx.common/" "/usr/local/share/myx.common/" 2>&1 \
		| (grep -v --line-buffered -E '>f\.\.t\.+ ' >&2 || :)
    else
    	echo "Using: tar-tar"
	   	tar -cpf - -C "$T_DIR" $( ls "$T_DIR" ) | tar -xvpf - -C "/usr/local/"
    fi
	
	rm -rf "$T_DIR"
	
	
	chown $CHOWN "/usr/local/bin/myx.common"
	chmod 755 "/usr/local/bin/myx.common"
	
	chown -R $CHOWN "/usr/local/share/myx.common/bin"
	chmod -R 755 "/usr/local/share/myx.common/bin"

	chown -R $CHOWN "/usr/local/share/myx.common/include/obsolete/user/bin"
	chmod -R 755 "/usr/local/share/myx.common/include/obsolete/user/bin"
	
	# exec "/usr/local/share/myx.common/bin/install/myx.common-reinstall.Common"

	if [ -n "$OS_PACKAGES" ] ; then
		set -e
		echo "OS_PACKAGES set, will check/install packages..." >&2 
		/usr/local/bin/myx.common lib/installEnsurePackage $( echo "$OS_PACKAGES" | tr '\n' ' ' )
		echo "OS_PACKAGES done." >&2 
	fi

   	echo "Done."
	
	#
	# completion for root in bash:
	# 		myx.common setup/completion
	#
else
	echo "installer is in 'user' mode..."

	test -x "/usr/local/bin/myx.common" || (echo "System-wide 'myx.common' is already installed, skipping (in 'user' mode)." >&2 ; exit 0)
	command -v myx.common >/dev/null 2>&1 || (echo "⛔ ERROR: 'myx.common' is required, can't proceed in 'user' mode!"  >&2 ; exit 1)
fi
