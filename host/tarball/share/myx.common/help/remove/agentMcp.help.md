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

  Removes the `myx.common` entry at `projects["<launch-cwd>"].mcpServers` for the
  directory this command is run from - the same local-scope, per-directory
  entry `myx.common setup/agentMcp` wrote (see that command's help for the
  scope rationale). Run it from the same directory you ran setup/agentMcp
  from; a different directory has (at most) its own separate entry, unaffected.

  Idempotent: if the entry isn't present for this directory, this is a
  no-op (exit 0), not an error. Only the one entry this command owns is
  touched - a transient `.claude.json.bak` is kept only for the duration of
  the write and removed on success; the rest of the file is left
  byte-for-byte alone.

##  Examples:

    # Remove the myx.common MCP server registration
    `myx.common remove/agentMcp`
