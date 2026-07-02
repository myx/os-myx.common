# SedLineReader ( myx.common lib/sedLineReader )

Line-buffered sed wrapper.

Supported OS: Linux, FreeBSD, Darwin.

Usage notes:

  Use --help to print detailed help for this command.

Examples:

```sh
  myx.common lib/sedLineReader -e 's/ERROR/ERR/g' < /var/log/system.log
```

```sh
  myx.common lib/sedLineReader -n -e '/WARN/p' < /var/log/system.log
```
