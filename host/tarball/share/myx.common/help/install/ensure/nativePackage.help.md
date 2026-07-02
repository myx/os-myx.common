# NativePackage ( myx.common install/ensure/nativePackage )

Ensure native package is installed.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges.

##  Arguments:

  <native_package_name>

      Native package name to install.

##  Options:

  None.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Ensure native package is installed
	`myx.common install/ensure/nativePackage git`

	# Ensure native package is installed
	`myx.common install/ensure/nativePackage git curl`

	# Ensure native package is installed
	`myx.common install/ensure/nativePackage jq unzip`
