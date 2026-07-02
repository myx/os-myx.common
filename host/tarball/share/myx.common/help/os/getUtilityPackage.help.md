# GetUtilityPackage ( myx.common os/getUtilityPackage )

Map utility name to package name.

Supported OS: Linux, FreeBSD, Darwin.

Resolve package name(s) for utility commands on the current platform.

Install helpers use this mapping to keep package-manager operations
platform-neutral.

##  Arguments:

  <utility-name>

      Utility command name to resolve into native package name.

##  Options:

  --no-default

      Suppress default fallback mapping when utility is unknown.

  --list-basic-packages

      Print baseline package set for bootstrap usage.

  --list-basic-utilities

      Print baseline utility names used by package mapping.

##  Examples:

	# Map utility name to package name
	`myx.common os/getUtilityPackage rsync`

	# Map utility name to package name
	`myx.common os/getUtilityPackage --no-default foo`

	# Map utility name to package name
	`myx.common os/getUtilityPackage --list-basic-packages`
