# ReplaceText ( myx.common lib/replaceText )

Replace text in a file.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  <from-string>

      Argument value used by this command.

  <to-string>

      Argument value used by this command.

  <from-sed-regexp>

      Argument value used by this command.

  <to-sed-replace>

      Argument value used by this command.

##  Options:

  --plain

      Option supported by this command.

    --regex

      Option supported by this command.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Replace text matches in target file
	`myx.common lib/replaceText /tmp/example.txt old new`

	# Replace text matches in target file
	`myx.common lib/replaceText --plain /tmp/example.txt old new`

	# Replace text matches in target file
	`myx.common lib/replaceText --regex /tmp/example.txt old new`
