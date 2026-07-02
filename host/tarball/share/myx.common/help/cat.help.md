# Cat ( myx.common cat )

Print myx.common command sources with markdown-aware formatting.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  <command>

      Command path to inspect (for example: os/getCpuCount).

##  Options:

  --full

      Include complete output/source.

  --strip

      Print stripped/minimal output form.

  --uname {Darwin|FreeBSD|Linux}

      Select target operating system variant.

##  Usage notes:

  Use --help to print detailed help for this command.


##  Notes:

  For given 'myx.common' command, outputs a source code to stdout, cutting the standalone execution part.
  NOTE: use --uname when requesting source code for specific target OS.
  NOTE: use --full option to get full source code.

##  Examples:

	# Print source for selected myx.common command
	`myx.common cat os/getCpuCount`

	# Target a specific operating system
	`myx.common cat --full --uname Darwin os/getCpuCount os/getRamBytes`

	# Target a specific operating system
	`myx.common cat --strip --uname FreeBSD os/getCpuCount`
