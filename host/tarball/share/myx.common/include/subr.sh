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
	UserIsRoot || { echo 'Must be run under "root" user!'; exit 1; }
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


SetRcEnable(){
	for ITEM in "$1"; do
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
