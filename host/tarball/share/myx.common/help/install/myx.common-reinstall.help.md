# Reinstall Myx.Common ( myx.common install/myx.common-reinstall )

Reinstall myx.common from upstream.

Supported OS: Linux, FreeBSD, Darwin.

Download and execute upstream installer for myx.common.

Provides a one-command refresh path for local installations without manually
fetching installer scripts.

##  Arguments:

  None.

##  Options:

  None.

##  Requirements:

  Root privileges and one of: curl, fetch, wget.

Behavior:

  Tries curl, then fetch, then wget; streams installer script to sh -e.

##  Examples:

	# Reinstall myx.common from upstream
	`myx.common install/myx.common-reinstall`
