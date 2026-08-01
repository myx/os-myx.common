# Claude Code CLI ( myx.common install/claude )

Install the Claude Code CLI.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges (except the actual package-manager call on Darwin,
which runs as the original non-root user - Homebrew refuses to run as root).

##  Arguments:

  None.

##  Options:

  --setup-agent-mcp   After installing, also run `myx.common setup/agentMcp`
                      to register this machine's myx.common tooling as an
                      MCP server for Claude Code.

##  OS-Specifics:

  Darwin: installed via Homebrew (`brew install --cask claude-code`),
  run as the original non-root user via `sudo -u $SUDO_USER`.

  Linux: installed via the official signed apt repository
  (signing key + repo file under /etc/apt/keyrings, then `apt install`).

  FreeBSD: installed via the native pkg repository
  (`pkg install claude-code`).

##  Usage notes:

  Use --help to print detailed help for this command.

  If claude is already installed, this command reports its version and
  skips reinstalling, on all supported OS. --setup-agent-mcp still runs
  even if claude was already installed.

##  Examples:

	# Install the Claude Code CLI
	`myx.common install/claude`

	# Install it and register the MCP server in one pass
	`myx.common install/claude --setup-agent-mcp`
