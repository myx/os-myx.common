# LinesToArguments ( myx.common lib/linesToArguments )

Convert input lines to shell arguments.

Supported OS: Linux, FreeBSD, Darwin.

Usage notes:

  Use --help to print detailed help for this command.

Examples:

```sh
printf 'alpha beta\ngamma delta\n' | myx.common lib/linesToArguments
```

```sh
printf 'api-01\napi-02\n' | myx.common lib/linesToArguments -e 's/^/--target=/'
```

```sh
myx.common lib/linesToArguments --act os/getCpuCount
```
