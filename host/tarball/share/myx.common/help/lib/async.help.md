
  Arguments:

    <prefix-text>

                Use this fixed string for prefix text.

    --

                Use the last argument of an executable command for prefix text.

    -(1|2|3)

                Use this argument of an executable command for prefix text.

  Options:

    --verbose, -v

                Adds a line before and after execution, so you see commands that do not
                output anything.

    --elapsed, -e

                Adds elapsed time '00000.000' to each prefixed line.

    --prefix-limit <number>

                Limit the length of prefixes (useful when prefix gets from the command arguments
                to a number of characters specified in the following argument).

  Examples:

    myx.common lib/async -e -2 mybuild.sh svc11.myserver.example.org ; ... ; wait

