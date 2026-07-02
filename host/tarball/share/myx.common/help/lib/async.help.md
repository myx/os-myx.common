# Async ( myx.common lib/async )

Run a command asynchronously and prefix each output line for easier concurrent logs.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

    <prefix-text>

                Use this fixed string for prefix text.

    --

                Use the last argument of an executable command for prefix text.

    -(1|2|3)

                Use this argument of an executable command for prefix text.

	<command> [...<command-argument>]

                The command to execute asyncronously with it's output prefixed.

##  Options:

    --verbose, -v

                Adds a line before and after execution, so you see commands that do not
                output anything.

    --elapsed, -e

                Adds elapsed time '00000.000' to each prefixed line.

    --prefix-limit <number>

                Limit the length of prefixes (useful when prefix gets from the command arguments
                to a number of characters specified in the following argument).

##  Examples:

	# Prefix output with elapsed time
	`myx.common lib/async --elapsed -2 mybuild.sh svc11.myserver.example.org`

	# Limit prefix width
	`myx.common lib/async --prefix-limit 16 -- echo os/getCpuCount`

	# Run a command asynchronously and prefix each output line for easier concurrent logs
	`myx.common lib/async build-1 os/getCpuCount`
