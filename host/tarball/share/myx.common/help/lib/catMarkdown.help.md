
# CatMarkdown ( myx.common lib/catMarkdown )

A stylized Markdown viewer that renders ANSI-colored output by default 
for vivid headings, lists, and code blocks in your terminal. Add `--strip-all` 
to drop all ANSI formatting and produce plain text.

##  Arguments:

	<markdown-file>

		The markdown-formatted input file, stdin pipe used when no input
		file specified.

##  Options:

	--strip-all

		Removes all ANSI formatting. Output becomes plain text.

##  Examples:

	# Print markdown source on the screen
	`myx.common lib/catMarkdown ~/my-stuff/README.md`

	# Print stripped text to the screen
	myx.common lib/catMarkdown --strip-all ~/my-stuff/README.md

	# Generate non-md version of something
	| tee "README.md" | myx.common lib/catMarkdown --strip-all > "README.txt"

	# On file that supposed to exist
	myx.common lib/catMarkdown "${MYXROOT:-/usr/local/share/myx.common}/help/lib/catMarkdown.help.md"
	myx.common lib/catMarkdown "${MYXROOT:-/usr/local/share/myx.common}/help/lib/catMarkdown.help.md" | cat

