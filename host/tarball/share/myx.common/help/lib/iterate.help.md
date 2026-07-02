# Iterate ( myx.common lib/iterate )

Run command for each stdin line sequentially.

Supported OS: Linux, FreeBSD, Darwin.

Arguments:

    <command> [...<command-argument>]

            The command to execute in sequentially, providing extra arguments from stdin
            lines.

            Note: Yes, this is very basic function. It's existence is mostly motivated to
            be used as a drop-in replacement alternative for `lib/parallel` while
            keeping the general structure of the code intact.

Options:

    -v
    --verbose

            Adds a line or text before and after execution, so you see commands that
            do not output anything.

Examples:

    Ls -1d {source.txt,output.txt} 2>/dev/null | myx.common lib/iterate cat

    . "$(myx.common which lib/parallel)"; Iterate -w 16 MyContextFunction --check-item <( cat my-list.txt )
