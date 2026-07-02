# Unbuffer ( myx.common lib/unbuffer )

Run command with unbuffered output.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  <command>

      Command path to inspect (for example: os/getCpuCount).

##  Options:

  None.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Run command with unbuffered output
	`myx.common lib/unbuffer sh -c 'echo start; sleep 1; echo done'`

	# Run command with unbuffered output
	`myx.common lib/unbuffer os/getCpuCount arguments`

	# Run command with unbuffered output
	`myx.common lib/unbuffer os/getCpuCount`
