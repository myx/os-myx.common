# Configuration

[Back to the README](../README.md)

Scope: settings, profile options and configuration commands.


## Environment variables

- `MYX_GIT_CONNECT_TIMEOUT` — the ssh connect timeout for `git/clonePull` and `git/cloneSync`, in seconds. The default is 15.
- `MYX_GIT_HTTP_LOW_SPEED_LIMIT` — the speed below which an HTTP or HTTPS transfer counts as stalled, in bytes per second. The default is 1000.
- `MYX_GIT_HTTP_LOW_SPEED_TIME` — how long the transfer may stay below that speed, in seconds. The default is 30.
- `MYX_GIT_CLONE_PULL_ON_CONFLICT` — the default conflict policy of `git/clonePull`: `stash`, `discard` or `fail`.
- `MYX_AGENTMCP_TARGET_CWD` — the directory that `setup/agentMcp` registers, in place of the current directory.
- `MYXROOT` — the install root of `myx.common`.

The timeouts are added to any ssh command you already configured. They stop a stalled remote from hanging the command.

Use `MYX_AGENTMCP_TARGET_CWD` when the process that runs the command does not have the target directory as its own working directory. An MCP tool call is an example.
