# os-myx.common

One command — `myx.common` — for everyday system administration on Linux, FreeBSD
and macOS. Each operation picks the right implementation for the machine it runs
on, so the same line works everywhere.

## Install

With `curl`:

	curl -L https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e

With `fetch`, on FreeBSD:

	fetch -o - https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e

Reinstall from upstream later, or remove it:

	myx.common install/myx.common-reinstall
	myx.common remove/myx.common-uninstall --yes

Install shell completion, then press TAB after `myx.common ` to list commands:

	myx.common setup/completion

## Getting started

	myx.common help                 list every command available on this machine
	myx.common help <command>       syntax, options and platform notes for one command
	myx.common which <command>      the script path chosen for this OS
	myx.common cat <command>        the command's own source

Many commands need root. `myx.common help <command>` says whether that one does.

## Common tasks

Set up a machine:

	myx.common setup/machine
	myx.common setup/server
	myx.common setup/client
	myx.common setup/console

Make sure a tool is installed, whatever the platform's package manager is:

	myx.common install/ensure/nativePackage rsync screen
	myx.common install/git
	myx.common install/java

Create an admin user and give it an SSH key:

	myx.common lib/installWheelUser deploy "Deploy user"
	myx.common lib/installAuthorizedKey deploy "ssh-ed25519 AAAA..."

Look at the machine:

	myx.common os/getCpuCount
	myx.common os/getRamBytes
	myx.common os/needsReboot --print
	myx.common os/reclaimSpace

Run something over a list of inputs:

	cat hosts.txt | myx.common lib/iterate -- ssh
	cat hosts.txt | myx.common lib/parallel --workers 8 -- ssh
	echo 'uname -a' | myx.common lib/execShStdin

Send a notification:

	myx.common lib/notifySmart --alert --text "backup failed"

Register `myx.common` as an MCP server for an AI agent host:

	myx.common setup/agentMcp
	myx.common remove/agentMcp

## Commands

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

## Getting help

- `myx.common help` — every command available on this machine.
- `myx.common help <command>` — full syntax, per-platform variants, and whether root is required.
- `myx.common which <command>` — the exact script this machine will run.
- Press TAB after `myx.common ` once completion is installed.

## Related packages

Per-OS install entry points. Each one only bootstraps `os-myx.common`; all the
command logic lives here.

- [os-myx.common-macosx](https://github.com/myx/os-myx.common-macosx) — macOS install script.
- [os-myx.common-ubuntu](https://github.com/myx/os-myx.common-ubuntu) — Ubuntu and Debian install script.
- [os-myx.common-freebsd](https://github.com/myx/os-myx.common-freebsd) — FreeBSD install script.
