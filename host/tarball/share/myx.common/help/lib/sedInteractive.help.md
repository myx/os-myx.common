# SedInteractive ( myx.common lib/sedInteractive )

Sed wrapper for interactive/stream mode.

Supported OS: Linux, FreeBSD, Darwin.

Usage notes:

  Use --help to print detailed help for this command.

Examples:

```sh
myx.common lib/sedInteractive -e 's/[[:space:]]\+$//' < /tmp/input.txt
```

```sh
myx.common lib/sedInteractive -n -e '/ERROR/p' < /tmp/app.log
```
