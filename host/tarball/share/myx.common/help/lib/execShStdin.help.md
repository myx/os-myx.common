# ExecShStdin ( myx.common lib/execShStdin )

Execute shell script from stdin.

Supported OS: Linux, FreeBSD, Darwin.

Usage notes:

  Use --help to print detailed help for this command.

Examples:

```sh
  printf 'echo hello-from-stdin\n' | myx.common lib/execShStdin
```

```sh
  printf 'echo "shell=$0"\n' | myx.common lib/execShStdin --bash
```
