# Reinstall Myx.Common ( myx.common install/myx.common-reinstall )

Download and execute upstream installer for myx.common.

provides a one-command refresh path for local installations without manually
fetching installer scripts.

Requirements:

  root privileges and one of: curl, fetch, wget.

Behavior:

  tries curl, then fetch, then wget; streams installer script to sh -e.

Examples:

  sudo myx.common install/myx.common-reinstall
