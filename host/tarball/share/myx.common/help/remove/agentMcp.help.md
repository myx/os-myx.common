# AgentMcp ( myx.common remove/agentMcp )

Undo `myx.common setup/agentMcp`: remove the myx.common MCP server entry
from `~/.claude.json`.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges: no.

##  Arguments:

  None.

##  Options:

  None.

##  Usage notes:

  Idempotent: if the entry isn't present, this is a no-op (exit 0), not an
  error. Only the one `mcpServers` entry this repo owns is touched - a
  transient `.claude.json.bak` is kept only for the duration of the write
  and removed on success; the rest of the file is left byte-for-byte alone.

##  Examples:

    # Remove the myx.common MCP server registration
    `myx.common remove/agentMcp`
