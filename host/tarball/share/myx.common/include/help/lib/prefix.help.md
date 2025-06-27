
  Arguments:

    <prefix-text>

                Use this fixed string for prefix text.

    --

                Use the last argument of an executable command for prefix text. The
				complete last argument will be used.

    -(1|2|3)

                Use this argument of an executable command for prefix text. Only
				the `basename` (last token after last /, if it is a file path) of
				that argument will be used.

  Options:

	-v
    --verbose

                Adds a line before and after execution, so you see commands that do not
                output anything.

	-e
    --elapsed

                Adds elapsed time '00000.000' to each prefixed line.

	-l <number>
    --prefix-limit <number>

                Limit the length of prefixes (useful when prefix gets from the command arguments
                to a number of characters specified in the following argument).

  Examples:

    myx.common lib/prefix -e -2 mybuild.sh svc11.myserver.example.org

