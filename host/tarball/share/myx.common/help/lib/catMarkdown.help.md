# CatMarkdown ( myx.common lib/catMarkdown )

Render markdown as plain terminal text.

Supported OS: Linux, FreeBSD, Darwin.

A stylized Markdown viewer that renders ANSI-colored output by default
for vivid headings, lists, and code blocks in your terminal. Add `--strip-all`
to drop all ANSI formatting and produce plain text.

##  Arguments:

	<markdown-file>

		The markdown-formatted input file, stdin pipe used when no input
		file specified.

	-

		Explicit spelling of "read the stdin pipe". Same as passing no
		input file at all.

##  Options:

	--strip-all

		Removes all ANSI formatting. Output becomes plain text.

	--spans

		For a program that draws the text itself: each line is printed as its text,
		a TAB and its spans, `<byte offset>+<bytes>+<look>` separated by commas; the
		looks are h1 h2 h3 strong em code quote rule meta item head link. Front matter
		shows as facts (meta), a table in columns, a link as its text (link).

	--width <cells>

		With --spans: lines are broken at words to that many cells, a broken line going
		on under its text; a table wider than that has its cells broken in narrower
		columns, its rows set apart by a line.

	--no-wrap

		With --spans: no line is broken, and a table keeps its width.

	--ascii

		With --spans: the marks of headings, items, rules and tables in ASCII.

##  Examples:

	# Render markdown from stdin or default input
	`myx.common lib/catMarkdown`

	# Same, with stdin named explicitly
	`myx.common lib/catMarkdown --strip-all -`

	# Render output as plain text
	`myx.common lib/catMarkdown --strip-all /tmp/example.txt`

	# Force apply and overwrite existing state
	`myx.common lib/catMarkdown --strip-all --force-tty --basic-sed /tmp/example.txt`

	# Print markdown source on the screen
	`myx.common lib/catMarkdown ~/my-stuff/README.md`

	# Print stripped text to the screen
	`myx.common lib/catMarkdown --strip-all ~/my-stuff/README.md`

	# Generate non-md version of something
	`Cat "README.md" | myx.common lib/catMarkdown --strip-all > "README.txt"`

	# Mirror markdown and export plain-text copy
	`| tee "README.md" | myx.common lib/catMarkdown --strip-all > "README.txt"`

	# On file that supposed to exist
	`myx.common lib/catMarkdown "${MYXROOT:-/usr/local/share/myx.common}/help/lib/catMarkdown.help.md"`

	# Verify same output through an additional pipe
	`myx.common lib/catMarkdown "${MYXROOT:-/usr/local/share/myx.common}/help/lib/catMarkdown.help.md" | cat`
