# Commands

[Back to the README](../README.md)

Platform tags mark commands that exist on one OS only. Everything else runs on
Linux, FreeBSD and macOS.

- Discovery:
	- `help` — show help for everything, or for one command.
	- `which` — locate a command's script path.
	- `cat` — print a command's source, markdown-aware.
- `git/` — repositories:
	- `git/clonePull` — clone, or fast-forward pull.
	- `git/cloneSync` — synchronise a repository, optionally pushing.
- `install/` — software:
	- `install/ensure/nativePackage` — install native packages if missing.
	- `install/ensure/utilBashRsyncScreenSudo` — ensure bash, rsync, screen and sudo.
	- `install/ensure/utilGoGitNano` — ensure Go, Git and nano.
	- `install/ensure/utilNodeYarnGit` — ensure Node, Yarn and Git.
	- `install/ensure/utilDhcpIpfwPublicDns` — ensure DHCP, IPFW and public-DNS tooling. [FreeBSD]
	- `install/git` — install Git.
	- `install/java` — install the Java runtime and tools.
	- `install/claude` — install the Claude Code CLI.
	- `install/updates` — install system updates.
	- `install/myx.common-reinstall` — reinstall myx.common from upstream.
	- `install/brew` — install Homebrew and baseline tools. [Darwin]
	- `install/farmanager` — install Far Manager. [Darwin]
	- `install/freebsd` — run the FreeBSD host bootstrap install. [Linux]
	- `install/monit` — install Monit. [FreeBSD]
	- `install/acmcms` — install acmcms components. [FreeBSD]
	- `install/ae3` — install ae3 components. [FreeBSD]
- `lib/` — building blocks for scripts:
	- Running things:
		- `lib/execShStdin` — execute a shell script read from stdin.
		- `lib/iterate` — run a command once per stdin line, sequentially.
		- `lib/parallel` — run a command per stdin item, in parallel.
		- `lib/prefix` — prefix a command's output lines.
		- `lib/unbuffer` — run a command with unbuffered output.
		- `lib/remoteContext` — build or execute a remote shell context script.
	- Users and keys:
		- `lib/installUser` — create or update a local user account. [Linux, FreeBSD]
		- `lib/installWheelUser` — create an admin-capable user account.
		- `lib/installUserGroupMembership` — ensure group membership. [Linux, FreeBSD]
		- `lib/installUserPasswordHash` — set a user's password hash. [Linux, FreeBSD]
		- `lib/installAuthorizedKey` — install an SSH key for a user.
		- `lib/installRootAuthorizedKey` — install an SSH key for root.
	- Files and text:
		- `lib/replaceLine` — replace a matching line in a file.
		- `lib/replaceText` — replace text in a file.
		- `lib/sedInteractive` — sed wrapper for interactive or stream mode.
		- `lib/sedLineReader` — line-buffered sed wrapper.
		- `lib/linesToArguments` — turn input lines into shell arguments.
		- `lib/catMarkdown` — render markdown as plain terminal text.
		- `lib/setSysctlConf` — set a key in `sysctl.conf`. [Linux, FreeBSD]
		- `lib/setLoaderConf` — set a key in `loader.conf`. [FreeBSD]
	- Output and notifications:
		- `lib/out` — coloured status, error and info output.
		- `lib/notifySlack` — send a Slack notification.
		- `lib/notifySmart` — send a notification through whichever channel is available.
	- Misc:
		- `lib/fetchStdout` — fetch a URL to stdout, with optional caching.
		- `lib/installEnsurePackage` — install a package if it is missing.
		- `lib/setupShellCompletion` — register shell completion for a utility.
		- `lib/agentMcpServer` — the MCP stdio server. Launched by the agent host that `setup/agentMcp` registers, not run by hand.
- `os/` — machine facts and maintenance:
	- Facts:
		- `os/getCpuCount` — CPU core count.
		- `os/getRamBytes` — total RAM in bytes.
		- `os/getRootHome` — root's home path.
		- `os/getUserHome` — a user's home path.
		- `os/getWheelGroupName` — primary admin group name.
		- `os/getWheelGroupNames` — admin group names.
		- `os/getUtilityPackage` — map a utility name to its package name.
		- `os/getCommonScreenRc` — default system `screenrc` path.
	- Maintenance:
		- `os/needsReboot` — check whether a reboot is required. [Linux, FreeBSD]
		- `os/reclaimSpace` — clean caches and logs to reclaim disk. [Linux, FreeBSD]
		- `os/growSlashFs` — grow the root filesystem. [Linux]
		- `os/growSlashFsUfs` — grow the UFS root filesystem. [FreeBSD]
		- `os/installPostfixMTA` — install and enable Postfix. [FreeBSD]
- `setup/` — apply a configuration:
	- `setup/machine` — base machine setup.
	- `setup/server` — server-side host setup.
	- `setup/client` — client-side workstation setup.
	- `setup/console` — console environment setup.
	- `setup/screen` — install the screen configuration.
	- `setup/completion` — install shell completion hooks.
	- `setup/agentMcp` — register myx.common as an MCP server for AI agent hosts.
	- `setup/bhyve` — configure a bhyve virtualisation host. [FreeBSD]
	- `setup/ipfw-open` — open selected firewall services. [FreeBSD]
- `tune/` — performance and hardening:
	- `tune/networkProtect` — conservative network hardening. [Linux, FreeBSD]
	- `tune/networkSpeed` — performance-oriented network tuning. [Linux, FreeBSD]
	- `tune/zfsQuarterCache` — set the ZFS ARC to a quarter of RAM. [FreeBSD]
- `remove/` and `reset/` — undo:
	- `remove/myx.common-uninstall` — uninstall myx.common.
	- `remove/completion` — remove shell completion hooks.
	- `remove/screen` — remove screen setup artifacts.
	- `remove/agentMcp` — remove the MCP server registration.
	- `reset/dnsCache` — flush the DNS resolver cache. [Darwin]
	- `reset/ipfw` — reset firewall rules. [FreeBSD]
- `user/` and `vm/`:
	- `user/requireRoot` — assert the script is running as root.
	- `vm/create` — create or update a VM configuration. [Linux, FreeBSD]
	- `vm/list` — list configured VMs. [Linux, FreeBSD]


## Discovery options

- `myx.common help [<command>]` — list the commands, or print help for one.
	- `--bare` — print the command names only, with no extra formatting. Use it with no `<command>`.
	- `--uname {Darwin|FreeBSD|Linux}` — print the help of another platform's variant.
- `myx.common which [--uname {Darwin|FreeBSD|Linux}] <command>` — print the full path of the script for a command, or fail with an error exit code. Use `--uname` to locate the source for another OS.

`myx.common help` exits 1 even when it printed help successfully.

## git/clonePull and git/cloneSync

Both take `<dst_path> <repo_url> [<branch>]`. The branch defaults to `master`.

- `git/clonePull` makes sure the remote state is present locally. It clones a missing target. It fast-forward pulls an existing checkout. It never pushes.
- `git/cloneSync` makes sure local changes are never lost. It clones a missing target. It pulls an existing checkout, then pushes its local commits.
- Neither clones over an existing folder, and neither ever deletes a `.git`.

Options:

- `--no-write` — accepted by both commands.
- `--no-push` — `git/cloneSync` only. It implies `--no-write` and makes the command equal to `git/clonePull`.
- `--on-conflict-stash` — `git/clonePull` only. When the fast-forward pull fails, stash local changes including untracked files, fetch, check out the branch, and hard-reset to `origin/<branch>`.
- `--on-conflict-discard` — `git/clonePull` only. The same, but discard the local changes instead of stashing them.
- `--on-conflict-fail` — the default. Stop with an error when the fast-forward pull fails.

`MYX_GIT_CLONE_PULL_ON_CONFLICT` sets the conflict policy when no `--on-conflict-*` option is given. Its values are `stash`, `discard` and `fail`.

## lib/execShStdin

`myx.common lib/execShStdin [--bash]` runs the shell script it reads from stdin. `--bash` runs it with bash.

## MCP server commands

- `myx.common setup/agentMcp` — register `myx.common` as an MCP server for an AI agent host. It needs no root.
- `myx.common remove/agentMcp` — remove that registration for the current directory.
- `myx.common lib/agentMcpServer --run` — the server loop itself. The agent host starts it. Do not run it by hand, because it blocks on stdin until the host closes the connection.


## Manuals

Each command has a manual with its full syntax, options and examples.

### Discovery

- [cat](../host/tarball/share/myx.common/help/cat.help.md)
- [help](../host/tarball/share/myx.common/help/help.help.md)
- [which](../host/tarball/share/myx.common/help/which.help.md)

### git/

- [git/clonePull](../host/tarball/share/myx.common/help/git/clonePull.help.md)
- [git/cloneSync](../host/tarball/share/myx.common/help/git/cloneSync.help.md)

### install/

- [install/claude](../host/tarball/share/myx.common/help/install/claude.help.md)
- [install/ensure/nativePackage](../host/tarball/share/myx.common/help/install/ensure/nativePackage.help.md)
- [install/freebsd](../host/tarball/share/myx.common/help/install/freebsd.help.md)
- [install/java](../host/tarball/share/myx.common/help/install/java.help.md)
- [install/myx.common-reinstall](../host/tarball/share/myx.common/help/install/myx.common-reinstall.help.md)
- [install/updates](../host/tarball/share/myx.common/help/install/updates.help.md)

### lib/

- [lib/agentMcpServer](../host/tarball/share/myx.common/help/lib/agentMcpServer.help.md)
- [lib/async](../host/tarball/share/myx.common/help/lib/async.help.md)
- [lib/catMarkdown](../host/tarball/share/myx.common/help/lib/catMarkdown.help.md)
- [lib/execShStdin](../host/tarball/share/myx.common/help/lib/execShStdin.help.md)
- [lib/fetchStdout](../host/tarball/share/myx.common/help/lib/fetchStdout.help.md)
- [lib/installAuthorizedKey](../host/tarball/share/myx.common/help/lib/installAuthorizedKey.help.md)
- [lib/installEnsurePackage](../host/tarball/share/myx.common/help/lib/installEnsurePackage.help.md)
- [lib/installRootAuthorizedKey](../host/tarball/share/myx.common/help/lib/installRootAuthorizedKey.help.md)
- [lib/installUser](../host/tarball/share/myx.common/help/lib/installUser.help.md)
- [lib/installUserGroupMembership](../host/tarball/share/myx.common/help/lib/installUserGroupMembership.help.md)
- [lib/installUserPasswordHash](../host/tarball/share/myx.common/help/lib/installUserPasswordHash.help.md)
- [lib/installWheelUser](../host/tarball/share/myx.common/help/lib/installWheelUser.help.md)
- [lib/iterate](../host/tarball/share/myx.common/help/lib/iterate.help.md)
- [lib/linesToArguments](../host/tarball/share/myx.common/help/lib/linesToArguments.help.md)
- [lib/notifySlack](../host/tarball/share/myx.common/help/lib/notifySlack.help.md)
- [lib/notifySmart](../host/tarball/share/myx.common/help/lib/notifySmart.help.md)
- [lib/out](../host/tarball/share/myx.common/help/lib/out.help.md)
- [lib/parallel](../host/tarball/share/myx.common/help/lib/parallel.help.md)
- [lib/prefix](../host/tarball/share/myx.common/help/lib/prefix.help.md)
- [lib/remoteContext](../host/tarball/share/myx.common/help/lib/remoteContext.help.md)
- [lib/replaceLine](../host/tarball/share/myx.common/help/lib/replaceLine.help.md)
- [lib/replaceText](../host/tarball/share/myx.common/help/lib/replaceText.help.md)
- [lib/sedInteractive](../host/tarball/share/myx.common/help/lib/sedInteractive.help.md)
- [lib/sedLineReader](../host/tarball/share/myx.common/help/lib/sedLineReader.help.md)
- [lib/setLoaderConf](../host/tarball/share/myx.common/help/lib/setLoaderConf.help.md)
- [lib/setSysctlConf](../host/tarball/share/myx.common/help/lib/setSysctlConf.help.md)
- [lib/setupShellCompletion](../host/tarball/share/myx.common/help/lib/setupShellCompletion.help.md)
- [lib/unbuffer](../host/tarball/share/myx.common/help/lib/unbuffer.help.md)

### os/

- [os/getCommonScreenRc](../host/tarball/share/myx.common/help/os/getCommonScreenRc.help.md)
- [os/getCpuCount](../host/tarball/share/myx.common/help/os/getCpuCount.help.md)
- [os/getRamBytes](../host/tarball/share/myx.common/help/os/getRamBytes.help.md)
- [os/getRootHome](../host/tarball/share/myx.common/help/os/getRootHome.help.md)
- [os/getUserHome](../host/tarball/share/myx.common/help/os/getUserHome.help.md)
- [os/getUtilityPackage](../host/tarball/share/myx.common/help/os/getUtilityPackage.help.md)
- [os/getWheelGroupName](../host/tarball/share/myx.common/help/os/getWheelGroupName.help.md)
- [os/getWheelGroupNames](../host/tarball/share/myx.common/help/os/getWheelGroupNames.help.md)
- [os/growSlashFs](../host/tarball/share/myx.common/help/os/growSlashFs.help.md)
- [os/growSlashFsUfs](../host/tarball/share/myx.common/help/os/growSlashFsUfs.help.md)
- [os/installPostfixMTA](../host/tarball/share/myx.common/help/os/installPostfixMTA.help.md)
- [os/needsReboot](../host/tarball/share/myx.common/help/os/needsReboot.help.md)
- [os/reclaimSpace](../host/tarball/share/myx.common/help/os/reclaimSpace.help.md)

### remove/

- [remove/agentMcp](../host/tarball/share/myx.common/help/remove/agentMcp.help.md)
- [remove/completion](../host/tarball/share/myx.common/help/remove/completion.help.md)
- [remove/myx.common-uninstall](../host/tarball/share/myx.common/help/remove/myx.common-uninstall.help.md)
- [remove/screen](../host/tarball/share/myx.common/help/remove/screen.help.md)

### reset/

- [reset/dnsCache](../host/tarball/share/myx.common/help/reset/dnsCache.help.md)
- [reset/ipfw](../host/tarball/share/myx.common/help/reset/ipfw.help.md)

### setup/

- [setup/agentMcp](../host/tarball/share/myx.common/help/setup/agentMcp.help.md)
- [setup/bhyve](../host/tarball/share/myx.common/help/setup/bhyve.help.md)
- [setup/client](../host/tarball/share/myx.common/help/setup/client.help.md)
- [setup/completion](../host/tarball/share/myx.common/help/setup/completion.help.md)
- [setup/console](../host/tarball/share/myx.common/help/setup/console.help.md)
- [setup/ipfw-open](../host/tarball/share/myx.common/help/setup/ipfw-open.help.md)
- [setup/machine](../host/tarball/share/myx.common/help/setup/machine.help.md)
- [setup/screen](../host/tarball/share/myx.common/help/setup/screen.help.md)
- [setup/server](../host/tarball/share/myx.common/help/setup/server.help.md)

### tune/

- [tune/networkProtect](../host/tarball/share/myx.common/help/tune/networkProtect.help.md)
- [tune/networkSpeed](../host/tarball/share/myx.common/help/tune/networkSpeed.help.md)
- [tune/zfsQuarterCache](../host/tarball/share/myx.common/help/tune/zfsQuarterCache.help.md)

### user/

- [user/requireRoot](../host/tarball/share/myx.common/help/user/requireRoot.help.md)

### vm/

- [vm/create](../host/tarball/share/myx.common/help/vm/create.help.md)
- [vm/list](../host/tarball/share/myx.common/help/vm/list.help.md)
