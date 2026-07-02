# Help ( myx.common help )

Display command-level help for myx.common utilities.

Supported OS: Linux, FreeBSD, Darwin.

This command is the primary discoverability entrypoint for all subcommands and
platform-specific variants.

Notes:

  For a given myx.common command, this prints command help or usage data.
  Use --bare (with no <command>) for unformatted command name listing.
  Use --uname to request help for a specific target OS variant.

Arguments:

  <command>

      Optional command path (for example: os/getCpuCount or lib/parallel).

Options:

  --bare

      Print command list without extended formatting.

  --uname {Darwin|FreeBSD|Linux}

      Resolve command/help variant for a specific platform.

Examples:

```sh
myx.common help
```

```sh
myx.common help os/needsReboot
```

```sh
myx.common help --uname Linux os/getUtilityPackage
```
