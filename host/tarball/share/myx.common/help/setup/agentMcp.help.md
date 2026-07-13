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

  Writes a `mcpServers` entry into `~/.claude.json` pointing at this
  install's MCP integration stub. Only that one entry is touched - a
  transient `.claude.json.bak` is kept only for the duration of the write
  and removed on success; the rest of the file is left byte-for-byte alone.

  Idempotent: re-running confirms/updates the one entry it owns without
  duplicating it. Use `myx.common remove/agentMcp` to undo.

  Restart your MCP host after running this for it to pick up the new
  server.

##  Examples:

    # Register myx.common as an MCP server for this machine
    `myx.common setup/agentMcp`
