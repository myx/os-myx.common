# AgentMcpServer ( myx.common lib/agentMcpServer )

Long-running MCP (Model Context Protocol) stdio server exposing myx.common
commands to a connected AI agent host (e.g. Claude Code). Not for
interactive/manual use - launched as a subprocess by the MCP host itself,
using the exact command/args `myx.common setup/agentMcp` registers.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges: no.

##  Arguments:

  None.

##  Options:

  --run   Start the JSON-RPC 2.0 stdio server loop: reads newline-delimited
          requests from stdin, writes newline-delimited responses to
          stdout, until the caller closes the connection. Required - with
          no arguments (or --help), this prints usage and exits 1, the same
          as every other `myx.common lib/*` command; it never falls into
          the server loop by accident. This is the exact argument
          `myx.common setup/agentMcp` registers for this command's launch.

##  Usage notes:

  Speaks JSON-RPC 2.0 over stdin/stdout, newline-delimited, hand-rolled (no
  jq/python dependency). Exposes two tools to the connected agent:
  `help` (wraps `myx.common help`) and `lib_execShStdin` (execute a
  command/script and return its stdout/stderr/exit status). Also exposes a
  `resources` capability (resources/list, resources/read) - one resource
  per shipped `$MYXROOT/help/**/*.help.md` file, addressed by URI
  `myx-common://help/<category>/<name>`, so a host can read a command's
  full manual without spending a tool call.

  Registered via `myx.common setup/agentMcp`, which writes this command's
  resolved absolute path plus `--run` straight into the MCP host's config
  (`~/.claude.json`, local scope, keyed by launch cwd - see that command's
  own help for the scope rationale). Never run this manually from an
  interactive shell with `--run` - it blocks reading stdin as a server loop
  until the host closes the connection; there's nothing to see by running
  it directly.

  Curating which myx.common commands this server actually exposes to an
  agent (beyond the two tools above) is a separate, not-yet-made decision -
  this command's own existence/registration doesn't imply any particular
  exposure policy.

##  Examples:

    # Register this workspace's myx.common as an MCP server (the normal
    # path - do this, never invoke lib/agentMcpServer directly)
    `myx.common setup/agentMcp`

    # Undo the registration
    `myx.common remove/agentMcp`

    # Raw invocation shape the MCP host itself launches, shown for
    # reference only - blocks on stdin, not meant to be run by hand
    `myx.common lib/agentMcpServer --run`
