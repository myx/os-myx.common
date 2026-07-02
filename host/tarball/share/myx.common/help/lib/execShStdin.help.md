# ExecShStdin ( myx.common lib/execShStdin )

Execute shell script from stdin.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  None.

##  Options:

  --bash

      Execute via bash shell.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Execute shell statements from stdin
	`printf 'echo hello-from-stdin\n' | myx.common lib/execShStdin`

	# Execute stdin script with bash
	`printf 'echo "shell=$0"\n' | myx.common lib/execShStdin --bash`
