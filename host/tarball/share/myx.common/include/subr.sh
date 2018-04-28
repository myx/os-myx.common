#
# Not executable as a separate unit.
#



#
# Check user
#
UserIsRoot(){
	return $(test `id -u` = 0);
}



#
# Require 'root' user
#
UserRequireRoot(){
	UserIsRoot || { echo '$1: Must be run under "root" user!'; exit 1; }
}



#
#	file from to
#
InternReplaceLine(){
	local FL="$1" FR="$2" TO="$3"
	
	grep -q "$FR" $FL && \
		cp -pf "$FL" "$FL.bak" && \
		chmod 664 "$FL.bak" && \
		grep -v "$FR" "$FL.bak" > "$FL" && \
		rm "$FL.bak"
		
	grep -q -x -F "$TO" "$FL" || \
		echo "$TO" >> "$FL"
		
	return 0;
}



InstallUserGroupMembership(){
	UserRequireRoot "InstallUserGroupMembership"

	local NAME="$1" GROUP="$2"

	[ -z "$NAME" ] && echo "InstallUserGroupMembership: username is required!" && exit 1
	[ -z "$GROUP" ] && echo "InstallUserGroupMembership: groupname is taken from username ($NAME)!" && GROUP="$NAME"
	
	pwd_mkdb /etc/master.passwd

	pw groupshow "$GROUP" || pw groupadd -n "$GROUP"
	
	pw groupmod "$GROUP" -m "$NAME"

	pwd_mkdb /etc/master.passwd
}



InstallUser(){
	UserRequireRoot "InstallUser"

	local NAME="$1" TITLE="$2" 
	local UGID="$3" HOME="${4:-/home/$NAME/}"
	
	[ -z "$NAME" ] && echo "InstallUser: username is required!" && exit 1
	[ -z "$TITLE" ] && echo "InstallUser: usertitle is taken from name ($NAME)!" && TITLE="$NAME"

	pwd_mkdb /etc/master.passwd

	if ! pw groupshow "$NAME" >/dev/null 2>&1; then \
		echo "Creating group '$NAME'."
		pw groupadd -n "$NAME" $(if ! [ -z "$UGID" ] ; then echo "-g $UGID" ; fi)
		pwd_mkdb /etc/master.passwd
	 else \
	 	echo "Using existing group '$NAME'."
	fi

	mkdir -p "$HOME"
	# install -d -g 177 -o 177 "$HOME"

	if pw usershow "$NAME" > /dev/null 2>&1; then
		echo "Using existing user '$NAME'."
		pw usermod "$NAME" -g "$NAME" -c "$TITLE" -d "$HOME" -s /bin/sh
	else 
		echo "Creating user '$NAME'."
		pw useradd "$NAME" -g "$NAME" $(if ! [ -z "$UGID" ] ; then echo "-u $UGID" ; fi) -c "$TITLE" -d "$HOME" -s /bin/sh
	fi
	
	pw groupmod "$NAME" -m "$NAME"
	pwd_mkdb /etc/master.passwd
	
	chown $NAME:$NAME "$HOME/"
	chmod 700 "$HOME/"

	mkdir -p "$HOME/.ssh"
	chown $NAME:$NAME "$HOME/.ssh"
	chmod 700 "$HOME/.ssh"
}



InstallWheelUser(){
	UserRequireRoot "InstallWheelUser"

	local NAME="$1" TITLE="$2"

	[ -z "$NAME" ] && echo "InstallWheelUser: username is required!" && exit 1
	[ -z "$TITLE" ] && echo "InstallWheelUser: usertitle is taken from name ($NAME)!" && TITLE="$NAME"
	
	InstallUser "$NAME" "$TITLE"
	InstallUserGroupMembership "$NAME" "wheel"
}




SetRcEnable(){
	for ITEM in "$1"; do
		echo "$0: SetRcEnable: $ITEM"
		sysrc "${ITEM}_enable=YES"
	done
	return 0;
}


GetInstallPath(){
	for CHECK in 'macmyxpro'; do
		hostname | grep -q $CHECK && { echo 'http://172.16.190.1:8080/!/skin/skin-check-things/$files/distro/farm-general'; return 0; }
	done
	echo 'http://myx.ru/distro/farm-general'
	return 0;
}


AddScriptInclude(){
	local TGT_SCRIPT="$1"
	local OWN_SCRIPT="$2"
	local OWN_SOURCE="$3"
	local CMD_SOURCE="${4:-"."}"

	echo "$OWN_SOURCE" > "$OWN_SCRIPT"
	[ -f "$TGT_SCRIPT" ] || touch "$TGT_SCRIPT"
	[ -f "$TGT_SCRIPT" ] && [ "$CMD_SOURCE" != "source" ] && InternReplaceLine "$TGT_SCRIPT" "source $OWN_SCRIPT" ""
	[ -f "$TGT_SCRIPT" ] && [ "$CMD_SOURCE" != "." ] && InternReplaceLine "$TGT_SCRIPT" ". $OWN_SCRIPT" ""
	[ -f "$TGT_SCRIPT" ] && InternReplaceLine "$TGT_SCRIPT" "# $CMD_SOURCE $OWN_SCRIPT" "$CMD_SOURCE $OWN_SCRIPT"
}


MYX_COMMON_DIR="$(echo ${PKG_PREFIX-/usr/local}/share/myx.common | /usr/bin/sed -e 's|//|/|g')"
MYX_COMMON_BIN="$MYX_COMMON_DIR/bin"
