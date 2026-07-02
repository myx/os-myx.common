# SetLoaderConf ( myx.common lib/setLoaderConf )

Set key/value in loader.conf.

Supported OS: FreeBSD.
Requires root privileges.

Usage notes:

  Use --help to print detailed help for this command.

Examples:

```sh
  myx.common lib/setLoaderConf kern.maxfiles 200000
```

```sh
  myx.common lib/setLoaderConf kern.maxfiles --grow 250000
```

```sh
  myx.common lib/setLoaderConf kern.maxfiles --shrink 150000
```
