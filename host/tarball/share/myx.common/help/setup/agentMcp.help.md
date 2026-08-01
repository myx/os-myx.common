# AgentMcp ( myx.common setup/agentMcp )

Register this machine's myx.common as an MCP (Model Context Protocol) server
for an AI agent host (e.g. Claude Code), so the agent can discover and run
myx.common commands directly.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges: no.

##  Arguments:

  None.

##  Options:

  None.

##  Usage notes:

  Writes a `myx` entry into `~/.claude.json` at
  `projects["<launch-cwd>"].mcpServers` - Claude Code's own local-scope
  convention, keyed by the absolute directory this command was run from.
  Each workspace/checkout gets its own private entry instead of sharing one
  global entry that the last workspace to run this command would silently
  overwrite. Only that one entry is touched - a transient `.claude.json.bak`
  is kept only for the duration of the write and removed on success; the
  rest of the file, including any older top-level `mcpServers` entry from
  before this per-workspace scoping, is left byte-for-byte alone.

  Idempotent: re-running from the same directory confirms/updates the one
  entry it owns for that directory, without duplicating it. Running it from
  a different directory registers a separate entry for that directory. Use
  `myx.common remove/agentMcp` (from the same directory) to undo.

  Restart your MCP host after running this for it to pick up the new
  server.

##  Examples:

    # Register myx.common as an MCP server for this machine
    `myx.common setup/agentMcp`
