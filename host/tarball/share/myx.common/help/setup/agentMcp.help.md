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

  Runs up to two myx MCP server registrations per invocation, both keyed
  by the launch cwd - or by the `MYX_AGENTMCP_TARGET_CWD` environment
  variable when set, for a caller whose own process cwd isn't the
  workspace being registered (e.g. dispatch through an MCP tool such as
  `mcp__myx_common__lib_execShStdin`, whose server process has its own
  fixed cwd unrelated to any particular workspace). Ordinary
  interactive/terminal invocation needs nothing extra - pwd already is
  the intended workspace there:

  1. If a real myx.distro-* workspace is detected there (marker file
     `.local/myx/myx.distro-.local/sh-lib/LocalContext.include`),
     additionally writes/upserts the myx MCP server into
     `<launch-cwd>/.vscode/mcp.json`'s `servers` key - VS Code/Copilot-
     Chat's own workspace-scoped MCP config. Non-destructive: only the
     `myx.common` key is set/overwritten, and any other entry launching a
     command from inside the myx.common tree is dropped as a duplicate of
     that same server; every other entry and the rest of the file is left
     alone. This tier runs on top of, not instead of, the
     home-scope registration below - Claude Code itself does not read
     `.vscode/mcp.json`, so replacing rather than adding to the home entry
     would silently stop Claude Code's own MCP discovery for the
     workspace. A failure in this tier is reported as a warning but does
     not block the home-scope registration below.

  2. Always: writes the myx MCP server into `~/.claude.json` at
     `projects["<launch-cwd>"].mcpServers` - Claude Code's own local-scope
     convention, keyed by the absolute directory this command was run
     from. Each workspace/checkout gets its own private entry instead of
     sharing one global entry that the last workspace to run this command
     would silently overwrite. Only that one entry is touched - a
     transient `.claude.json.bak` is kept only for the duration of the
     write and removed on success; the rest of the file, including any
     older top-level `mcpServers` entry from before this per-workspace
     scoping, is left byte-for-byte alone.

  Idempotent: re-running from the same directory confirms/updates the one
  entry each tier owns for that directory/scope, without duplicating
  either. Running it from a different directory registers separate
  entries for that directory.

  `myx.common remove/agentMcp` (from the same directory) currently undoes
  only the home `~/.claude.json` entry above - it does not remove a
  workspace-local `.vscode/mcp.json` entry, which today must be cleaned up
  by hand if no longer wanted.

  Restart your MCP host after running this for it to pick up the new
  server.

##  Examples:

    # Register myx.common as an MCP server for this machine
    `myx.common setup/agentMcp`
