
  Arguments:

	<command> [...<command-argument>]

                The command to execute in parallel, providing extra arguments from stdin
				lines.

  Options:

	-v
    --verbose

                Adds a line before and after execution, so you see commands that do not
                output anything.

	-l <number>
    --limit <number>

                Maximum number of parallel tasks. Default: 4.

  Examples:

    ls -1d {source.txt,output.txt} 2>/dev/null | myx.common lib/parallel cat

    . "$(myx.common which lib/parallel)"; Parallel --limit 16 MyContextFunction --check-item <( cat my-list.txt )

