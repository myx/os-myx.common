# ClonePull ( myx.common git/clonePull )

Clone or fast-forward pull a repository.

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

##  Usage notes:

  Use --help to print detailed help for this command.


##  Notes:

  If 'branch' argument is not set, 'master' will be used.
  Should be equivalent to: 'myx.common git/cloneSync --no-push'.

##  Examples:

	# Clone or synchronize repository content
	`myx.common git/clonePull /tmp/example-repo https://github.com/example/example.git`

	# Clone or synchronize repository content
	`myx.common git/clonePull --no-write /tmp/example-repo https://github.com/example/example.git main`
