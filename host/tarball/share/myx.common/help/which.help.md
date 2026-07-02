# Which ( myx.common which )

Locate myx.common command script path.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  <command>

      Command path to inspect (for example: os/getCpuCount).

##  Options:

  --uname {Darwin|FreeBSD|Linux}

      Select target operating system variant.

##  Usage notes:

  Use --help to print detailed help for this command.


##  Notes:

  For given 'myx.common' command, outputs a full path to stdout or dies with error exit code.
  NOTE: use --uname when requesting source code location for specific target OS.

##  Examples:

	# Print absolute path of selected myx.common command
	`myx.common which os/getCpuCount`

	# Target a specific operating system
	`myx.common which --uname Darwin os/getCpuCount`

	# Target a specific operating system
	`myx.common which --uname FreeBSD os/getCpuCount`
