# Troubleshooting

[Back to the README](../README.md)

## A command is not found, or an old one runs

The dispatcher runs a match only when its file is executable. A candidate without its execute bit is skipped without a message, and the next candidate wins.

`myx.common which <command>` can name a path that the dispatcher refuses to run, because it tests for a plain file only. Set mode 755 on the file and run it to confirm.

## myx.common help exits 1

`myx.common help` exits 1 even when it printed help. This is the convention, not a failure.

## A git command hangs

`git/clonePull` and `git/cloneSync` add a connect timeout and a low-speed limit to every network call. [Configuration](configuration.md) lists the variables that change them. A stalled remote ends the command instead of hanging it.

## A pull stops with a conflict

`git/clonePull` stops with an error when the fast-forward pull fails. That is the default policy. Pass `--on-conflict-stash` or `--on-conflict-discard`, or set `MYX_GIT_CLONE_PULL_ON_CONFLICT`. Both options reset the checkout to `origin/<branch>`.

## remove/agentMcp did not remove my registration

The registration is per directory. Run `remove/agentMcp` from the directory where you ran `setup/agentMcp`. Another directory has its own entry, which is not touched.

When the command runs through a process whose working directory is not the target, it can remove the wrong entry, or none, without a message. Run it from a terminal in the right directory.

`remove/agentMcp` removes only the home-scope entry. A `.vscode/mcp.json` entry that `setup/agentMcp` wrote must be removed by hand.

## The agent host does not see the server

Restart the agent host after `setup/agentMcp`. The headless `copilot -p` also skips local MCP servers unless the folder is trusted in its settings. `setup/agentMcp` adds that trust when `copilot` is installed.

## A tool option has no effect

The MCP `lib_execShStdin` tool declares `comment` and `mergeOutputs`. Neither does anything yet. `mergeOutputs: false` never separates the streams, and `comment` is never logged. This is a known fault and is not fixed.

## A timed-out command leaves a process running

Timeout and cancellation work on the command's own process, not on its process group. A child that the command started, such as a `curl`, can keep running after the command is stopped.

## A Markdown table renders one column short

An empty table cell in `myx.common lib/catMarkdown` output merges with its neighbour. The row appears one column short. The rest of the table is unaffected.
