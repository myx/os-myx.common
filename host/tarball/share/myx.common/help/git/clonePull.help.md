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

  --on-conflict-stash

      If fast-forward pull fails, stash local changes (including untracked),
      fetch, checkout target branch and hard-reset to origin/<branch>.

  --on-conflict-discard

      If fast-forward pull fails, discard local changes, fetch, checkout target
      branch and hard-reset to origin/<branch>.

  --on-conflict-fail

      Default. If fast-forward pull fails, stop with error.

##  Environment:

    MYX_GIT_CLONE_PULL_ON_CONFLICT

      If no --on-conflict-* option is specified, the value of this
      environment variable is used as default conflict policy.

      Supported values: stash, discard, fail.

      If unset, fail is used.

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

  # Clone or synchronize and auto-resolve local conflict by stashing changes
  `myx.common git/clonePull --on-conflict-stash /tmp/example-repo https://github.com/example/example.git main`
