# Formats

[Back to the README](../README.md)

## Command names

A command is addressed as `<category>/<name>`, for example `os/getCpuCount`. The categories are `git`, `install`, `lib`, `os`, `remove`, `reset`, `setup`, `tune`, `user` and `vm`. `help`, `which` and `cat` have no category.

## How a command is chosen

`myx.common <category>/<name>` looks for the command in this order and runs the first match:

1. An implementation for this operating system.
2. The cross-platform implementation.
3. A legacy-name redirect, kept after a command was renamed.

A match runs only when its file is executable. A file without its execute bit is skipped without a message, and the next candidate wins.

`myx.common which <command>` shows the file chosen. It tests for a plain file, so it can name a path that the dispatcher would refuse to run. `which --uname <OS>` shows the choice for another operating system.

## Help files

Every command has two help files at the matching path:

- a short syntax file, which the command prints for `--help`.
- the full manual, in Markdown.

One pair serves every operating system. `myx.common help <command>` prints it.

## The MCP server

`lib/agentMcpServer` speaks JSON-RPC 2.0 over stdin and stdout. Each message is one line.

- It offers two tools. `help` wraps `myx.common help`. `lib_execShStdin` runs a command and returns its stdout, stderr and exit status.
- It offers one resource per manual, at `myx-common://help/<category>/<name>`. A host reads a manual without spending a tool call.
- Only stdout carries messages. Diagnostics go to stderr.
- `lib_execShStdin` accepts a `timeout`. When the command had to be killed, the result carries exit status 124.
- The `help` tool does not treat the exit status 1 of `myx.common help` as an error.
