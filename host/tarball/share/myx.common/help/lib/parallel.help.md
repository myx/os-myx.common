# Parallel ( myx.common lib/parallel )

Run command for stdin items in parallel.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

    <command> [...<command-argument>]

            The command to execute in parallel, providing extra arguments from stdin
            lines.

            Note: Works best with long-running (1 second or longer) tasks. Not that
            efficient to run something tiny.

            The special feature is that this utility in includable into shell scripts
            and allows running local shell context functions is parallel (see example).

##  Options:

    -v
    --verbose

            Adds a line or text before and after execution, so you see commands that
            do not output anything.

    -q
    --quiet

            Almost silent: no line before or after a job. A failed job still gets
            its error line. This is the default.

    -S
    --silent

            Absolutely quiet: not even the error line of a failed job. Use it when
            the job reports its own failure, such as one wrapped in lib/prefix. The
            run still exits with status 123 once every job has finished, if any
            job failed.

    -w <number>
    --workers <number> | --workers=<number>

            Maximum number of parallel tasks. Default: 4.

    --workers-x2 | --turbo | --twice-as-hard
    --workers-x3 | --overclock
    --workers-x4 | --beast-mode
            Multiply current worker count limit by 2, 3 or 4. These options pair
            well with the use of ENV_PARALLEL_WORKER_COUNT environment variable.

##  Environment:

    ENV_PARALLEL_WORKER_COUNT
            if --workers is not specified, the value of this environment variable
            is used as default. If unset - '4' workers will be used.

##  Examples:

	# Run command for stdin items in parallel
	`myx.common lib/parallel os/getCpuCount`

	# Run with verbose output
	`myx.common lib/parallel -v -w 8 os/getCpuCount`

	# Control parallel worker count
	`myx.common lib/parallel --workers=6 -- os/getRamBytes`

	# xargs equivalent: each job reports its own failure, the run exits non-zero (123) after all jobs if any failed
	#   same as: xargs -P 8 -I% sh -c 'myx.common lib/prefix -o -3 myx.common git/clonePull %'
	`printf '%s\n' "ndm/cloud.all ssh://host/cloud.all.git" | myx.common lib/parallel -S -w 8 myx.common lib/prefix -o -3 myx.common git/clonePull`
