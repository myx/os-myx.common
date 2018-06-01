#
# Not executable as a separate unit.
#
# This script is universal for FreeBSD, Darwin, Ubuntu.



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
	test ! -z "$FL" || ( echo "ReplaceLine: FL is required!" >&2 ; exit 1 )
	
	grep -q "$FR" $FL && \
		cp -pf "$FL" "$FL.bak" && \
		chmod 664 "$FL.bak" && \
		grep -v "$FR" "$FL.bak" > "$FL" && \
		rm "$FL.bak"
		
	grep -q -x -F "$TO" "$FL" || \
		echo "$TO" >> "$FL"
		
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

