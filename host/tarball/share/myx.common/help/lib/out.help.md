# Out ( myx.common lib/out )

Colored/formatted terminal output helper. Dispatches to one of the
`out.*` shell functions defined in `include/out.sh` by name.

Supported OS: Linux, FreeBSD, Darwin.

##  Who this is for, and when:

For anyone writing a shell script - myx.common-based or standalone - that
wants consistent colored status/error/info output without hand-rolling
ANSI escape codes each time. Nothing else in myx.common calls
`include/out.sh` internally, so this isn't plumbing any other command
depends on; it exists purely as a helper for *your* scripts to call.
Reach for it when a script needs a quick `[ ok ]`/`[ failed ]`-style status
line, an "Error:"/"Info:" prefixed message, or output that should collapse
to a compact single-character marker in non-verbose contexts (see
`$SIMPLEOUTPUT`/`$OPTIONS` below). Skip it for a one-off `echo` where none
of that formatting matters.

##  Legend (status colors):

`status`'s color argument has no enforced meaning - it just picks an ANSI
color - but the conventional usage across this tool family is:

    green     success / ok / finished without issue
    red       failure / error
    yellow    warning / in-progress / needs attention

##  Environment:

    OPTIONS

            If this space-separated list contains the word `verbose`,
            `status` and `message` always print their full/colored form
            regardless of `SIMPLEOUTPUT`.

    SIMPLEOUTPUT

            When set (and `verbose` isn't in `OPTIONS`), `status` prints a
            single compact character per color (`;` red, `:` green, `|`
            yellow) instead of a full `[ colored message ]` line, and
            `message` prints its short third argument instead of the full
            first argument.

    SCRIPTNAME

            Used by `syntax` to prefix its output; prints empty if unset.

##  Subcommands:

    status <red|green|yellow> <message>

            Prints `[ message ]` in the given color (full form), or a
            compact single-character marker (see SIMPLEOUTPUT above). See
            Legend above for the conventional meaning of each color.

    error <message>

            Prints "Error: <message>" in bold red.

    info <message>

            Prints "Info: <message>" in bold.

    example <message>

            Prints "Example: <message>" in bold.

    syntax <message>

            Prints a "Syntax:" line, prefixed with $SCRIPTNAME if set,
            followed by <message>.

    valuechange <setting> <target> <new-value> [<old-value>]

            Prints "Changing value of '<setting>' setting for '<target>'
            from '<old-value>' to '<new-value>'..." (no trailing newline).
            Omits the "from '<old-value>'" clause if <old-value> is empty.

    message <text> [waitstatus] [<short-text>]

            Prints <text> (or <short-text> instead, if SIMPLEOUTPUT is set
            and 'verbose' isn't in OPTIONS). If the second argument is
            literally the word `waitstatus`, the line is printed without a
            trailing newline (for a later "done"/"failed" to follow on the
            same line).

    nextrelease

            Prints "Error: feature not available, maybe next release!" and
            exits 1.

##  Example - a small deploy script using it end to end:

	#!/bin/sh
	SCRIPTNAME="deploy.sh"

	myx.common lib/out info "Starting deploy to $1"

	if ! rsync -a ./build/ "$1:/srv/app/"; then
		myx.common lib/out status red "rsync failed"
		exit 1
	fi
	myx.common lib/out status green "rsync ok"

	myx.common lib/out valuechange "release" "$1" "$(date +%s)" "$OLD_RELEASE"

##  Compatibility:

`myx.common lib/out.status <color> <message>` (the old, pre-2026-07-14 name
for what is now `myx.common lib/out status <color> <message>`) still works
- it's kept as a legacy redirect under `include/obsolete/`, so it won't
show up in `myx.common help`'s listing or completion, but existing callers
of the old name keep working unchanged.
