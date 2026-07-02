# Help ( myx.common help )

Show command-level help for myx.common utilities.

this command is the primary discoverability entrypoint for all subcommands and
platform-specific variants.

Notes:

  for a given myx.common command, this prints command help or usage data.
  use --bare (with no <command>) for unformatted command name listing.
  use --uname to request help for a specific target OS variant.

Arguments:

  <command>

      Optional command path (for example: os/getCpuCount or lib/parallel).

Options:

  --bare

      Print command list without extended formatting.

  --uname {Darwin|FreeBSD|Linux}

      Resolve command/help variant for a specific platform.

Examples:

  myx.common help
  myx.common help os/needsReboot
  myx.common help --uname Linux os/getUtilityPackage
