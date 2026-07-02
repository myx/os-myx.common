# CloneSync ( myx.common git/cloneSync )

Synchronize repository with optional push.

Supported OS: Linux, FreeBSD, Darwin.

Usage notes:

  Use --help to print detailed help for this command.


Notes:

  If 'branch' argument is not set, 'master' will be used as default.
  '--no-push' implies '--no-write' and is equivalent to: 'myx.common git/clonePull'.

Examples:

```sh
myx.common git/cloneSync /tmp/example-repo https://github.com/example/example.git
```

```sh
myx.common git/cloneSync --no-write /tmp/example-repo https://github.com/example/example.git main
```

```sh
myx.common git/cloneSync --no-push /tmp/example-repo https://github.com/example/example.git main
```
