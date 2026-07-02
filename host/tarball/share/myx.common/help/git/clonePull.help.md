# ClonePull ( myx.common git/clonePull )

Clone or fast-forward pull a repository.

Supported OS: Linux, FreeBSD, Darwin.

Usage notes:

  Use --help to print detailed help for this command.


Notes:

  If 'branch' argument is not set, 'master' will be used.
  Should be equivalent to: 'myx.common git/cloneSync --no-push'.

Examples:

```sh
myx.common git/clonePull /tmp/example-repo https://github.com/example/example.git
```

```sh
myx.common git/clonePull --no-write /tmp/example-repo https://github.com/example/example.git main
```
