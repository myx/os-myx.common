# SedLineReader ( myx.common lib/sedLineReader )

Line-buffered sed wrapper.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  None.

##  Options:

  None.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Filter stream using line-buffered sed
	`myx.common lib/sedLineReader -e 's/ERROR/ERR/g' < /var/log/system.log`

	# Filter stream using line-buffered sed
	`myx.common lib/sedLineReader -n -e '/WARN/p' < /var/log/system.log`
