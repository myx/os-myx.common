# Parallel ( myx.common lib/parallel )

Run command for stdin items in parallel.

Supported OS: Linux, FreeBSD, Darwin.

Arguments:

    <command> [...<command-argument>]

            The command to execute in parallel, providing extra arguments from stdin
            lines.

            Note: Works best with long-running (1 second or longer) tasks. Not that
            efficient to run something tiny.

            The special feature is that this utility in includable into shell scripts
            and allows running local shell context functions is parallel (see example).

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

```sh
  myx.common lib/parallel os/getCpuCount
```

```sh
  myx.common lib/parallel -v -w 8 os/getCpuCount
```

```sh
  myx.common lib/parallel --workers=6 -- os/getRamBytes
```
