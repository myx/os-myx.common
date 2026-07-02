# SedInteractive ( myx.common lib/sedInteractive )

Sed wrapper for interactive/stream mode.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  None.

##  Options:

  None.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Filter stream using unbuffered sed
	`myx.common lib/sedInteractive -e 's/[[:space:]]\+$//' < /tmp/input.txt`

	# Filter stream using unbuffered sed
	`myx.common lib/sedInteractive -n -e '/ERROR/p' < /tmp/app.log`
