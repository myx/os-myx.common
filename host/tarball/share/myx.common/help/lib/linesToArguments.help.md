# LinesToArguments ( myx.common lib/linesToArguments )

Convert input lines to shell arguments.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  <command>

      Command path to inspect (for example: os/getCpuCount).

##  Options:

  --act

      Use command output as input source.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Convert stdin lines to escaped argument list
	`printf 'alpha beta\ngamma delta\n' | myx.common lib/linesToArguments`

	# Convert input lines to shell arguments
	`printf 'api-01\napi-02\n' | myx.common lib/linesToArguments -e 's/^/--target=/'`

	# Convert stdin lines into escaped shell arguments
	`myx.common lib/linesToArguments --act os/getCpuCount`
