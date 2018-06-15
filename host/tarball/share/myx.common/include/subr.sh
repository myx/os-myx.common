#
# Not executable as a separate unit.
#
# This script contains generic OS-dependent functons.
# It MUST be overridden by OS-specific implementations.
#

. "/usr/local/share/myx.common/include/subr-universal.sh"

#
# Following methods are presented as an example of functions than must be implemented
#

UmanWheelGroupName(){
	# wheel
	echo "ERROR: UmanWheelGroupName must be re-implemented" >&2
	exit 1
}

UmanBaseHomeDirectory(){
	# /home
	echo "ERROR: UmanBaseHomeDirectory must be re-implemented" >&2
	exit 1
}

UmanRootHomeDirectory(){
	# /root
	echo "ERROR: UmanRootHomeDirectory must be re-implemented" >&2
	exit 1
}

