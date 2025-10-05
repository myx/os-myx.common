
  Arguments:

    <command> [...<command-argument>]

            The command to execute in parallel, providing extra arguments from stdin
            lines. 
			
			Note: Works best with long-running (1 second or longer) tasks. Not that
			efficient to run something tiny.

  Options:

    -v
    --verbose

            Adds a line or text before and after execution, so you see commands that 
            do not output anything.

    -w <number>
    --workers <number> | --workers=<number>

            Maximum number of parallel tasks. Default: 4.

    --workers-x2 | --turbo | --twice-as-hard
    --workers-x3 | --overclock
    --workers-x4 | --beast-mode
            Multiply current worker count limit by 2, 3 or 4. These options pair
            well with the use of ENV_PARALLEL_WORKER_COUNT environment variable.


  Environment:

    ENV_PARALLEL_WORKER_COUNT
            if --workers is not specified, the value of this environment variable 
            is used as default. If unset - '4' workers will be used.

  Examples:

    ls -1d {source.txt,output.txt} 2>/dev/null | myx.common lib/parallel cat

    . "$(myx.common which lib/parallel)"; Parallel -w 16 MyContextFunction --check-item <( cat my-list.txt )

