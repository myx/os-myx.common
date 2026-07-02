# CloneSync ( myx.common git/cloneSync )

Synchronize repository with optional push.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  <dst_path>

      Destination path.

  <repo_url>

      Repository URL.

  <branch>

      Branch name.

##  Options:

  --no-write

      Option supported by this command.

  --no-push

      Option supported by this command.

##  Usage notes:

  Use --help to print detailed help for this command.


##  Notes:

  If 'branch' argument is not set, 'master' will be used as default.
  '--no-push' implies '--no-write' and is equivalent to: 'myx.common git/clonePull'.

##  Examples:

	# Clone or synchronize repository content
	`myx.common git/cloneSync /tmp/example-repo https://github.com/example/example.git`

	# Clone or synchronize repository content
	`myx.common git/cloneSync --no-write /tmp/example-repo https://github.com/example/example.git main`

	# Clone or synchronize repository content
	`myx.common git/cloneSync --no-push /tmp/example-repo https://github.com/example/example.git main`
