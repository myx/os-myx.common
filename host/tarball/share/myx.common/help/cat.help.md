# Cat ( myx.common cat )

Print myx.common command sources with markdown-aware formatting.

Supported OS: Linux, FreeBSD, Darwin.

Usage notes:

  Use --help to print detailed help for this command.


Notes:

  For given 'myx.common' command, outputs a source code to stdout, cutting the standalone execution part.
  NOTE: use --uname when requesting source code for specific target OS.
  NOTE: use --full option to get full source code.

Examples:

```sh
  myx.common cat os/getCpuCount
```

```sh
  myx.common cat --full --uname Darwin os/getCpuCount os/getRamBytes
```

```sh
  myx.common cat --strip --uname FreeBSD os/getCpuCount
```
