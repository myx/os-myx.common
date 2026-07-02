# Which ( myx.common which )

Locate myx.common command script path.

Supported OS: Linux, FreeBSD, Darwin.

Usage notes:

  Use --help to print detailed help for this command.


Notes:

  For given 'myx.common' command, outputs a full path to stdout or dies with error exit code.
  NOTE: use --uname when requesting source code location for specific target OS.

Examples:

```sh
  myx.common which os/getCpuCount
```

```sh
  myx.common which --uname Darwin os/getCpuCount
```

```sh
  myx.common which --uname FreeBSD os/getCpuCount
```
