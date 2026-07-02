# SetSysctlConf ( myx.common lib/setSysctlConf )

Set key/value in sysctl.conf.

Supported OS: Linux, FreeBSD.
Requires root privileges.

Usage notes:

  Use --help to print detailed help for this command.

Examples:

```sh
  myx.common lib/setSysctlConf kern.maxfiles 200000
```

```sh
  myx.common lib/setSysctlConf kern.maxfiles --grow 250000
```

```sh
  myx.common lib/setSysctlConf kern.maxfiles --shrink 150000
```
