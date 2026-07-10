# os-myx.common

Install:

`curl -L https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e`

or

`fetch https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh -o - | sh -e`

(Depends on whether you have `curl`)

## Commands

- `myx.common cat` — print myx.common command sources with markdown-aware formatting [Linux, FreeBSD, Darwin]
- `myx.common help` — show myx.common help [Linux, FreeBSD, Darwin]
- `myx.common which` — locate myx.common command script path [Linux, FreeBSD, Darwin]
- `myx.common git/clonePull` — clone or fast-forward pull a repository [Linux, FreeBSD, Darwin]
- `myx.common git/cloneSync` — synchronize repository with optional push [Linux, FreeBSD, Darwin]
- `myx.common install/acmcms` — install acmcms components [FreeBSD]
- `myx.common install/ae3` — install ae3 components [FreeBSD]
- `myx.common install/brew` — install Homebrew and baseline tools [Darwin]
- `myx.common install/ensure/nativePackage` — ensure native package is installed [Linux, FreeBSD, Darwin]
- `myx.common install/ensure/utilBashRsyncScreenSudo` — ensure bash rsync screen sudo are installed [Linux, FreeBSD, Darwin]
- `myx.common install/ensure/utilDhcpIpfwPublicDns` — ensure DHCP/IPFW/Public-DNS tooling [FreeBSD]
- `myx.common install/ensure/utilGoGitNano` — ensure Go Git Nano are installed [Linux, FreeBSD, Darwin]
- `myx.common install/ensure/utilNodeYarnGit` — ensure Node Yarn Git are installed [Linux, FreeBSD, Darwin]
- `myx.common install/farmanager` — install Far Manager on macOS [Darwin]
- `myx.common install/freebsd` — run FreeBSD host bootstrap install [Linux]
- `myx.common install/git` — install Git [Linux, FreeBSD, Darwin]
- `myx.common install/java` — install Java runtime/tools [Linux, FreeBSD, Darwin]
- `myx.common install/monit` — install Monit [FreeBSD]
- `myx.common install/myx.common-reinstall` — reinstall myx.common from upstream [Linux, FreeBSD, Darwin]
- `myx.common install/updates` — install system updates [Linux, FreeBSD, Darwin]
- `myx.common lib/catMarkdown` — render markdown as plain terminal text [Linux, FreeBSD, Darwin]
- `myx.common lib/execShStdin` — execute shell script from stdin [Linux, FreeBSD, Darwin]
- `myx.common lib/fetchStdout` — fetch URL content to stdout with optional cache [Linux, FreeBSD, Darwin]
- `myx.common lib/installAuthorizedKey` — install SSH key for a user [Linux, FreeBSD, Darwin]
- `myx.common lib/installEnsurePackage` — install package if missing [Linux, FreeBSD, Darwin]
- `myx.common lib/installRootAuthorizedKey` — install SSH key for root user [Linux, FreeBSD, Darwin]
- `myx.common lib/installUser` — create or update local user account [Linux, FreeBSD]
- `myx.common lib/installUserGroupMembership` — ensure user membership in groups [Linux, FreeBSD]
- `myx.common lib/installUserPasswordHash` — set user password hash [Linux, FreeBSD]
- `myx.common lib/installWheelUser` — create admin-capable user account [Linux, FreeBSD, Darwin]
- `myx.common lib/iterate` — run command for each stdin line sequentially [Linux, FreeBSD, Darwin]
- `myx.common lib/linesToArguments` — convert input lines to shell arguments [Linux, FreeBSD, Darwin]
- `myx.common lib/notifySlack` — send notification to Slack [Linux, FreeBSD, Darwin]
- `myx.common lib/notifySmart` — send notification through available channel [Linux, FreeBSD, Darwin]
- `myx.common lib/out` — prefixed status output helper [Linux, FreeBSD, Darwin]
- `myx.common lib/out.status` — status-line output helper [Linux, FreeBSD, Darwin]
- `myx.common lib/parallel` — run command for stdin items in parallel [Linux, FreeBSD, Darwin]
- `myx.common lib/prefix` — prefix command output lines [Linux, FreeBSD, Darwin]
- `myx.common lib/remoteContext` — build/execute remote shell context script [Linux, FreeBSD, Darwin]
- `myx.common lib/replaceLine` — replace matching line in a file [Linux, FreeBSD, Darwin]
- `myx.common lib/replaceText` — replace text in a file [Linux, FreeBSD, Darwin]
- `myx.common lib/sedInteractive` — sed wrapper for interactive/stream mode [Linux, FreeBSD, Darwin]
- `myx.common lib/sedLineReader` — line-buffered sed wrapper [Linux, FreeBSD, Darwin]
- `myx.common lib/setLoaderConf` — set key/value in loader.conf [FreeBSD]
- `myx.common lib/setSysctlConf` — set key/value in sysctl.conf [Linux, FreeBSD]
- `myx.common lib/setupShellCompletion` — register shell completion command [Linux, FreeBSD, Darwin]
- `myx.common lib/unbuffer` — run command with unbuffered output [Linux, FreeBSD, Darwin]
- `myx.common os/getCommonScreenRc` — print default system screenrc path [Linux, FreeBSD, Darwin]
- `myx.common os/getCpuCount` — print CPU core count [Linux, FreeBSD, Darwin]
- `myx.common os/getRamBytes` — print total RAM bytes [Linux, FreeBSD, Darwin]
- `myx.common os/getRootHome` — print root home path [Linux, FreeBSD, Darwin]
- `myx.common os/getUserHome` — print user home path [Linux, FreeBSD, Darwin]
- `myx.common os/getUtilityPackage` — map utility name to package name [Linux, FreeBSD, Darwin]
- `myx.common os/getWheelGroupName` — print primary admin group name [Linux, FreeBSD, Darwin]
- `myx.common os/getWheelGroupNames` — print admin group names list [Linux, FreeBSD, Darwin]
- `myx.common os/growSlashFs` — grow Linux root filesystem [Linux]
- `myx.common os/growSlashFs.1` — grow Linux root filesystem (variant 1) [Linux]
- `myx.common os/growSlashFs.2` — grow Linux root filesystem (variant 2) [Linux]
- `myx.common os/growSlashFsUfs` — grow FreeBSD UFS root filesystem [FreeBSD]
- `myx.common os/installPostfixMTA` — install and enable Postfix MTA [FreeBSD]
- `myx.common os/needsReboot` — check whether reboot is required [Linux, FreeBSD]
- `myx.common os/reclaimSpace` — clean caches/logs to reclaim disk space [Linux, FreeBSD]
- `myx.common remove/completion` — remove shell completion hooks [Linux, FreeBSD, Darwin]
- `myx.common remove/myx.common-uninstall` — uninstall myx.common files [Linux, FreeBSD, Darwin]
- `myx.common remove/screen` — remove screen setup artifacts [Linux, FreeBSD, Darwin]
- `myx.common reset/dnsCache` — flush DNS resolver cache [Darwin]
- `myx.common reset/ipfw` — reset firewall rules [FreeBSD]
- `myx.common setup/bhyve` — configure bhyve virtualization host [FreeBSD]
- `myx.common setup/client` — apply client-side workstation setup [Linux, FreeBSD, Darwin]
- `myx.common setup/completion` — install shell completion hooks [Linux, FreeBSD, Darwin]
- `myx.common setup/console` — apply console environment setup [Linux, FreeBSD, Darwin]
- `myx.common setup/ipfw-open` — open selected firewall services [FreeBSD]
- `myx.common setup/machine` — apply base machine setup [Linux, FreeBSD, Darwin]
- `myx.common setup/screen` — install screen configuration [Linux, FreeBSD, Darwin]
- `myx.common setup/server` — apply server-side host setup [Linux, FreeBSD, Darwin]
- `myx.common tune/networkProtect` — apply conservative network hardening [Linux, FreeBSD]
- `myx.common tune/networkSpeed` — apply performance-oriented network tuning [Linux, FreeBSD]
- `myx.common tune/zfsQuarterCache` — set ZFS ARC to quarter of RAM [FreeBSD]
- `myx.common user/requireRoot` — assert script is running as root [Linux, FreeBSD, Darwin]
- `myx.common vm/create` — create or update VM configuration [FreeBSD]
- `myx.common vm/list` — list configured VMs [Linux, FreeBSD]

## Command details

### `myx.common cat`
- Platforms: Linux, FreeBSD, Darwin
- Summary: print myx.common command sources with markdown-aware formatting.
- Root (Common): not required
- Syntax (Common): myx.common cat [--full|--strip] [--uname {Darwin|FreeBSD|Linux}] <command> [<command>...]

### `myx.common help`
- Platforms: Linux, FreeBSD, Darwin
- Summary: show myx.common help.
- Root (Common): not required
- Syntax (Common): myx.common help
- Syntax (Common): myx.common help <command>
- Syntax (Common): myx.common help [--bare] [--uname {Darwin|FreeBSD|Linux}]
- Syntax (Common): myx.common help [--uname {Darwin|FreeBSD|Linux}] [<command>]

### `myx.common which`
- Platforms: Linux, FreeBSD, Darwin
- Summary: locate myx.common command script path.
- Root (Common): not required
- Syntax (Common): myx.common which [--uname {Darwin|FreeBSD|Linux}] <command>

### `myx.common git/clonePull`
- Platforms: Linux, FreeBSD, Darwin
- Summary: clone or fast-forward pull a repository.
- Root (Common): not required
- Syntax (Common): myx.common git/clonePull [--no-write] dst_path repo_url [branch]

### `myx.common git/cloneSync`
- Platforms: Linux, FreeBSD, Darwin
- Summary: synchronize repository with optional push.
- Root (Common): not required
- Syntax (Common): myx.common git/cloneSync [--no-write/--no-push] dst_path repo_url [branch]

### `myx.common install/acmcms`
- Platforms: FreeBSD
- Summary: install acmcms components.
- Root (FreeBSD): required
- Syntax (FreeBSD): not explicitly declared in script output; check script help include/body

### `myx.common install/ae3`
- Platforms: FreeBSD
- Summary: install ae3 components.
- Root (FreeBSD): required
- Syntax (FreeBSD): not explicitly declared in script output; check script help include/body

### `myx.common install/brew`
- Platforms: Darwin
- Summary: install Homebrew and baseline tools.
- Root (Darwin): not required
- Syntax (Darwin): not explicitly declared in script output; check script help include/body

### `myx.common install/ensure/nativePackage`
- Platforms: Linux, FreeBSD, Darwin
- Summary: ensure native package is installed.
- Root (Common): not required
- Syntax (Common): not explicitly declared in script output; check script help include/body
- Root (Linux): required
- Syntax (Linux): myx.common install/ensure/nativePackage native_package_name [native_package_name2 [...]]
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common install/ensure/nativePackage native_package_name [native_package_name2 [...]]
- Root (Darwin): required
- Syntax (Darwin): myx.common install/ensure/nativePackage native_package_name [native_package_name2 [...]]

### `myx.common install/ensure/utilBashRsyncScreenSudo`
- Platforms: Linux, FreeBSD, Darwin
- Summary: ensure bash rsync screen sudo are installed.
- Root (Common): required
- Syntax (Common): not explicitly declared in script output; check script help include/body

### `myx.common install/ensure/utilDhcpIpfwPublicDns`
- Platforms: FreeBSD
- Summary: ensure DHCP/IPFW/Public-DNS tooling.
- Root (FreeBSD): required
- Syntax (FreeBSD): not explicitly declared in script output; check script help include/body

### `myx.common install/ensure/utilGoGitNano`
- Platforms: Linux, FreeBSD, Darwin
- Summary: ensure Go Git Nano are installed.
- Root (Common): required
- Syntax (Common): not explicitly declared in script output; check script help include/body

### `myx.common install/ensure/utilNodeYarnGit`
- Platforms: Linux, FreeBSD, Darwin
- Summary: ensure Node Yarn Git are installed.
- Root (Common): required
- Syntax (Common): not explicitly declared in script output; check script help include/body

### `myx.common install/farmanager`
- Platforms: Darwin
- Summary: install Far Manager on macOS.
- Root (Darwin): not required
- Syntax (Darwin): not explicitly declared in script output; check script help include/body

### `myx.common install/freebsd`
- Platforms: Linux
- Summary: run FreeBSD host bootstrap install.
- Root (Linux): required
- Syntax (Linux): myx.common install/freebsd

### `myx.common install/git`
- Platforms: Linux, FreeBSD, Darwin
- Summary: install Git.
- Root (Common): required
- Syntax (Common): not explicitly declared in script output; check script help include/body

### `myx.common install/java`
- Platforms: Linux, FreeBSD, Darwin
- Summary: install Java runtime/tools.
- Root (Common): required
- Syntax (Common): not explicitly declared in script output; check script help include/body
- Root (Darwin): not required
- Syntax (Darwin): not explicitly declared in script output; check script help include/body

### `myx.common install/monit`
- Platforms: FreeBSD
- Summary: install Monit.
- Root (FreeBSD): required
- Syntax (FreeBSD): not explicitly declared in script output; check script help include/body

### `myx.common install/myx.common-reinstall`
- Platforms: Linux, FreeBSD, Darwin
- Summary: reinstall myx.common from upstream.
- Root (Common): required
- Syntax (Common): myx.common install/myx.common-reinstall

### `myx.common install/updates`
- Platforms: Linux, FreeBSD, Darwin
- Summary: install system updates.
- Root (Linux): required
- Syntax (Linux): myx.common install/updates
- Root (FreeBSD): required
- Syntax (FreeBSD): not explicitly declared in script output; check script help include/body
- Root (Darwin): required
- Syntax (Darwin): myx.common install/updates

### `myx.common lib/catMarkdown`
- Platforms: Linux, FreeBSD, Darwin
- Summary: render markdown as plain terminal text.
- Root (Common): not required
- Syntax (Common): myx.common lib/catMarkdown [--strip-all] [--force-tty] [--basic-sed] [file]

### `myx.common lib/execShStdin`
- Platforms: Linux, FreeBSD, Darwin
- Summary: execute shell script from stdin.
- Root (Common): not required
- Syntax (Common): myx.common lib/execShStdin [--bash] [<arguments...>]

### `myx.common lib/fetchStdout`
- Platforms: Linux, FreeBSD, Darwin
- Summary: fetch URL content to stdout with optional cache.
- Root (Common): not required
- Syntax (Common): myx.common lib/fetchStdout [--do-cache] [--local-cache dir|--local-cache=dir] url

### `myx.common lib/installAuthorizedKey`
- Platforms: Linux, FreeBSD, Darwin
- Summary: install SSH key for a user.
- Root (Common): required
- Syntax (Common): myx.common lib/installAuthorizedKey <user-name> <ssh-key> [--remove]

### `myx.common lib/installEnsurePackage`
- Platforms: Linux, FreeBSD, Darwin
- Summary: install package if missing.
- Root (Common): required
- Syntax (Common): myx.common lib/installEnsurePackage utility_name [utility_name2 [...]]
- Root (Linux): required
- Syntax (Linux): myx.common lib/installEnsurePackage utility_name [utility_name2 [...]]
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common lib/installEnsurePackage utility_name [utility_name2 [...]]
- Root (Darwin): required
- Syntax (Darwin): myx.common lib/installEnsurePackage utility_name [utility_name2 [...]]

### `myx.common lib/installRootAuthorizedKey`
- Platforms: Linux, FreeBSD, Darwin
- Summary: install SSH key for root user.
- Root (Common): required
- Syntax (Common): myx.common lib/installRootAuthorizedKey <ssh-key> [--remove]

### `myx.common lib/installUser`
- Platforms: Linux, FreeBSD
- Summary: create or update local user account.
- Root (Linux): required
- Syntax (Linux): myx.common lib/installUser username [usertitle [uid-or-gid [home-path]]]
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common lib/installUser username [usertitle [uid-or-gid [home-path]]]

### `myx.common lib/installUserGroupMembership`
- Platforms: Linux, FreeBSD
- Summary: ensure user membership in groups.
- Root (Linux): required
- Syntax (Linux): myx.common lib/installUserGroupMembership username [group1 [group2...]]
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common lib/installUserGroupMembership username [group1 [group2...]]

### `myx.common lib/installUserPasswordHash`
- Platforms: Linux, FreeBSD
- Summary: set user password hash.
- Root (Linux): required
- Syntax (Linux): myx.common lib/installUserPasswordHash username password_hash
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common lib/installUserPasswordHash username password_hash

### `myx.common lib/installWheelUser`
- Platforms: Linux, FreeBSD, Darwin
- Summary: create admin-capable user account.
- Root (Common): required
- Syntax (Common): myx.common lib/installWheelUser username [usertitle]

### `myx.common lib/iterate`
- Platforms: Linux, FreeBSD, Darwin
- Summary: run command for each stdin line sequentially.
- Root (Common): not required
- Syntax (Common): myx.common lib/iterate [--verbose|--quiet] [--] <command ...>

### `myx.common lib/linesToArguments`
- Platforms: Linux, FreeBSD, Darwin
- Summary: convert input lines to shell arguments.
- Root (Common): not required
- Syntax (Common): myx.common lib/linesToArguments [--act 'command'] ['sed' arguments, see 'man sed'...]

### `myx.common lib/notifySlack`
- Platforms: Linux, FreeBSD, Darwin
- Summary: send notification to Slack.
- Root (Common): not required
- Syntax (Common): myx.common lib/notifySlack --text <text> [--logger] [--bearer <token-bearer>] [--channel <channel>|--alert|--audit|--track|--debug] [--user <user-name>] [--emoji <emoji>]

### `myx.common lib/notifySmart`
- Platforms: Linux, FreeBSD, Darwin
- Summary: send notification through available channel.
- Root (Common): not required
- Syntax (Common): myx.common lib/notifySmart --alert|--audit|--track|--debug [--user <user-name>] [--emoji <emoji>] --text <message>

### `myx.common lib/out`
- Platforms: Linux, FreeBSD, Darwin
- Summary: prefixed status output helper.
- Root (Common): not required
- Syntax (Common): not explicitly declared in script output; check script help include/body

### `myx.common lib/out.status`
- Platforms: Linux, FreeBSD, Darwin
- Summary: status-line output helper.
- Root (Common): not required
- Syntax (Common): not explicitly declared in script output; check script help include/body

### `myx.common lib/parallel`
- Platforms: Linux, FreeBSD, Darwin
- Summary: run command for stdin items in parallel.
- Root (Common): not required
- Syntax (Common): myx.common lib/parallel [--workers N|--workers=N] [--verbose|--quiet] [--] <command ...>

### `myx.common lib/prefix`
- Platforms: Linux, FreeBSD, Darwin
- Summary: prefix command output lines.
- Root (Common): not required
- Syntax (Common): myx.common lib/prefix [--verbose|--quiet] [--prefix-limit N] [--stdout] [--async] <prefix> <command ...>

### `myx.common lib/remoteContext`
- Platforms: Linux, FreeBSD, Darwin
- Summary: build/execute remote shell context script.
- Root (Common): not required
- Syntax (Common): myx.common lib/remoteContext [options] [--insert-path p[:target]] [--insert-script file] [--insert-command cmd] [--do-ssh host]

### `myx.common lib/replaceLine`
- Platforms: Linux, FreeBSD, Darwin
- Summary: replace matching line in a file.
- Root (Common): not required
- Syntax (Common): myx.common lib/replaceLine [--create] file search_regex replacement_line

### `myx.common lib/replaceText`
- Platforms: Linux, FreeBSD, Darwin
- Summary: replace text in a file.
- Root (Common): not required
- Syntax (Common): 

### `myx.common lib/sedInteractive`
- Platforms: Linux, FreeBSD, Darwin
- Summary: sed wrapper for interactive/stream mode.
- Root (Common): not required
- Syntax (Common): myx.common lib/sedInteractive ['sed' arguments, see 'man sed'...]
- Root (Darwin): not required
- Syntax (Darwin): myx.common lib/sedInteractive ['sed' arguments, see 'man sed'...]

### `myx.common lib/sedLineReader`
- Platforms: Linux, FreeBSD, Darwin
- Summary: line-buffered sed wrapper.
- Root (Common): not required
- Syntax (Common): myx.common lib/sedLineReader ['sed' arguments, see 'man sed'...]
- Root (Linux): not required
- Syntax (Linux): myx.common lib/sedLineReader ['sed' arguments, see 'man sed'...]
- Root (FreeBSD): not required
- Syntax (FreeBSD): myx.common lib/sedLineReader ['sed' arguments, see 'man sed'...]
- Root (Darwin): not required
- Syntax (Darwin): myx.common lib/sedLineReader ['sed' arguments, see 'man sed'...]

### `myx.common lib/setLoaderConf`
- Platforms: FreeBSD
- Summary: set key/value in loader.conf.
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common lib/setLoaderConf parameter [--grow/--shrink] value

### `myx.common lib/setSysctlConf`
- Platforms: Linux, FreeBSD
- Summary: set key/value in sysctl.conf.
- Root (Linux): not required
- Syntax (Linux): myx.common lib/setSysctlConf parameter [--grow/--shrink] value
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common lib/setSysctlConf parameter [--grow/--shrink] value

### `myx.common lib/setupShellCompletion`
- Platforms: Linux, FreeBSD, Darwin
- Summary: register shell completion command.
- Root (Common): not required
- Syntax (Common): myx.common lib/setupShellCompletion <utility_name> --command <list_command>
- Syntax (Common): myx.common lib/setupShellCompletion <utility_name> --directory <list_directory>
- Syntax (Common): myx.common lib/setupShellCompletion <utility_name> --remove

### `myx.common lib/unbuffer`
- Platforms: Linux, FreeBSD, Darwin
- Summary: run command with unbuffered output.
- Root (Common): not required
- Syntax (Common): myx.common lib/unbuffer  command [... arguments]
- Root (Linux): not required
- Syntax (Linux): myx.common lib/unbuffer  command [... arguments]

### `myx.common os/getCommonScreenRc`
- Platforms: Linux, FreeBSD, Darwin
- Summary: print default system screenrc path.
- Root (Common): not required
- Syntax (Common): myx.common os/getCommonScreenRc
- Root (Linux): not required
- Syntax (Linux): myx.common os/getCommonScreenRc
- Root (FreeBSD): not required
- Syntax (FreeBSD): myx.common os/getCommonScreenRc
- Root (Darwin): not required
- Syntax (Darwin): myx.common os/getCommonScreenRc

### `myx.common os/getCpuCount`
- Platforms: Linux, FreeBSD, Darwin
- Summary: print CPU core count.
- Root (Common): not required
- Syntax (Common): myx.common os/getCpuCount
- Root (Linux): not required
- Syntax (Linux): myx.common os/getCpuCount
- Root (FreeBSD): not required
- Syntax (FreeBSD): myx.common os/getCpuCount
- Root (Darwin): not required
- Syntax (Darwin): myx.common os/getCpuCount

### `myx.common os/getRamBytes`
- Platforms: Linux, FreeBSD, Darwin
- Summary: print total RAM bytes.
- Root (Common): not required
- Syntax (Common): myx.common os/getRamBytes
- Root (Linux): not required
- Syntax (Linux): myx.common os/getRamBytes
- Root (FreeBSD): not required
- Syntax (FreeBSD): myx.common os/getRamBytes
- Root (Darwin): not required
- Syntax (Darwin): myx.common os/getRamBytes

### `myx.common os/getRootHome`
- Platforms: Linux, FreeBSD, Darwin
- Summary: print root home path.
- Root (Common): not required
- Syntax (Common): myx.common os/getRootHome

### `myx.common os/getUserHome`
- Platforms: Linux, FreeBSD, Darwin
- Summary: print user home path.
- Root (Common): not required
- Syntax (Common): not explicitly declared in script output; check script help include/body
- Root (Linux): not required
- Syntax (Linux): myx.common os/getUserHome [--user username]
- Root (FreeBSD): not required
- Syntax (FreeBSD): myx.common os/getUserHome [--user username]
- Root (Darwin): not required
- Syntax (Darwin): myx.common os/getUserHome [--user username]

### `myx.common os/getUtilityPackage`
- Platforms: Linux, FreeBSD, Darwin
- Summary: map utility name to package name.
- Root (Common): not required
- Syntax (Common): myx.common os/getUtilityPackage [--no-default] utility_name
- Syntax (Common): myx.common os/getUtilityPackage --list-basic-packages
- Syntax (Common): myx.common os/getUtilityPackage --list-basic-utilities

### `myx.common os/getWheelGroupName`
- Platforms: Linux, FreeBSD, Darwin
- Summary: print primary admin group name.
- Root (Common): depends on mode
- Syntax (Common): myx.common os/getWheelGroupName

### `myx.common os/getWheelGroupNames`
- Platforms: Linux, FreeBSD, Darwin
- Summary: print admin group names list.
- Root (Common): not required
- Syntax (Common): not explicitly declared in script output; check script help include/body
- Root (Linux): not required
- Syntax (Linux): myx.common os/getWheelGroupNames
- Root (FreeBSD): not required
- Syntax (FreeBSD): myx.common os/getWheelGroupNames
- Root (Darwin): not required
- Syntax (Darwin): myx.common os/getWheelGroupNames

### `myx.common os/growSlashFs`
- Platforms: Linux
- Summary: grow Linux root filesystem.
- Root (Linux): required
- Syntax (Linux): myx.common os/growSlashFs --execute

### `myx.common os/growSlashFs.1`
- Platforms: Linux
- Summary: grow Linux root filesystem (variant 1).
- Root (Linux): depends on mode
- Syntax (Linux): myx.common os/growSlashFsLinux --yes

### `myx.common os/growSlashFs.2`
- Platforms: Linux
- Summary: grow Linux root filesystem (variant 2).
- Root (Linux): depends on mode
- Syntax (Linux): not explicitly declared in script output; check script help include/body

### `myx.common os/growSlashFsUfs`
- Platforms: FreeBSD
- Summary: grow FreeBSD UFS root filesystem.
- Root (FreeBSD): not required
- Syntax (FreeBSD): myx.common os/growSlashFsUfs --yes

### `myx.common os/installPostfixMTA`
- Platforms: FreeBSD
- Summary: install and enable Postfix MTA.
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common os/installPostfixMTA

### `myx.common os/needsReboot`
- Platforms: Linux, FreeBSD
- Summary: check whether reboot is required.
- Root (Linux): depends on mode
- Syntax (Linux): myx.common os/needsReboot [--silent|--print|--reboot|--no-reboot]
- Root (FreeBSD): depends on mode
- Syntax (FreeBSD): myx.common os/needsReboot [--silent|--print|--reboot|--no-reboot]

### `myx.common os/reclaimSpace`
- Platforms: Linux, FreeBSD
- Summary: clean caches/logs to reclaim disk space.
- Root (Linux): required
- Syntax (Linux): myx.common os/reclaimSpace
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common os/reclaimSpace

### `myx.common remove/completion`
- Platforms: Linux, FreeBSD, Darwin
- Summary: remove shell completion hooks.
- Root (Common): required
- Syntax (Common): myx.common remove/completion [--host]

### `myx.common remove/myx.common-uninstall`
- Platforms: Linux, FreeBSD, Darwin
- Summary: uninstall myx.common files.
- Root (Common): required
- Syntax (Common): myx.common remove/myx.common-uninstall --yes

### `myx.common remove/screen`
- Platforms: Linux, FreeBSD, Darwin
- Summary: remove screen setup artifacts.
- Root (Common): required
- Syntax (Common): myx.common remove/screen [--host]

### `myx.common reset/dnsCache`
- Platforms: Darwin
- Summary: flush DNS resolver cache.
- Root (Darwin): required
- Syntax (Darwin): myx.common reset/dnsCache

### `myx.common reset/ipfw`
- Platforms: FreeBSD
- Summary: reset firewall rules.
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common reset/ipfw

### `myx.common setup/bhyve`
- Platforms: FreeBSD
- Summary: configure bhyve virtualization host.
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common setup/bhyve

### `myx.common setup/client`
- Platforms: Linux, FreeBSD, Darwin
- Summary: apply client-side workstation setup.
- Root (Common): not required
- Syntax (Common): myx.common setup/client

### `myx.common setup/completion`
- Platforms: Linux, FreeBSD, Darwin
- Summary: install shell completion hooks.
- Root (Common): required
- Syntax (Common): myx.common setup/completion [--host]
- Root (Linux): required
- Syntax (Linux): myx.common setup/completion [--host]

### `myx.common setup/console`
- Platforms: Linux, FreeBSD, Darwin
- Summary: apply console environment setup.
- Root (Common): not required
- Syntax (Common): myx.common setup/console

### `myx.common setup/ipfw-open`
- Platforms: FreeBSD
- Summary: open selected firewall services.
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common setup/ipfw-open [--force]

### `myx.common setup/machine`
- Platforms: Linux, FreeBSD, Darwin
- Summary: apply base machine setup.
- Root (Common): required
- Syntax (Common): myx.common setup/machine

### `myx.common setup/screen`
- Platforms: Linux, FreeBSD, Darwin
- Summary: install screen configuration.
- Root (Common): required
- Syntax (Common): myx.common setup/screen [--host]

### `myx.common setup/server`
- Platforms: Linux, FreeBSD, Darwin
- Summary: apply server-side host setup.
- Root (Common): required
- Syntax (Common): myx.common setup/server
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common setup/server [--postfix-mta]

### `myx.common tune/networkProtect`
- Platforms: Linux, FreeBSD
- Summary: apply conservative network hardening.
- Root (Linux): required
- Syntax (Linux): myx.common tune/networkProtect
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common tune/networkProtect

### `myx.common tune/networkSpeed`
- Platforms: Linux, FreeBSD
- Summary: apply performance-oriented network tuning.
- Root (Linux): required
- Syntax (Linux): myx.common tune/networkSpeed
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common tune/networkSpeed

### `myx.common tune/zfsQuarterCache`
- Platforms: FreeBSD
- Summary: set ZFS ARC to quarter of RAM.
- Root (FreeBSD): required
- Syntax (FreeBSD): myx.common tune/zfsQuarterCache [--upsert/--remove]

### `myx.common user/requireRoot`
- Platforms: Linux, FreeBSD, Darwin
- Summary: assert script is running as root.
- Root (Common): required
- Syntax (Common): myx.common user/requireRoot [command_name]

### `myx.common vm/create`
- Platforms: FreeBSD
- Summary: create or update VM configuration.
- Root (FreeBSD): not required
- Syntax (FreeBSD): 

### `myx.common vm/list`
- Platforms: Linux, FreeBSD
- Summary: list configured VMs.
- Root (Linux): not required
- Syntax (Linux): myx.common vm/list
- Root (FreeBSD): not required
- Syntax (FreeBSD): myx.common vm/list

## Adding or Changing a Command

Each command lives at `share/myx.common/bin/<category>/<name>.<Variant>`,
where `<Variant>` is one of:

- `Common` — cross-platform default implementation.
- `Darwin` / `FreeBSD` / `Linux` — OS-specific override.
- `Abstract` — template only, carries a "should be overridden per OS"
  comment; never picked by the dispatcher directly.

`bin/myx.common` resolves `myx.common <category>/<name> [args]` in this
order: `<name>.$(uname -s)` (OS override) → `<name>.Common` (default) →
`include/obsolete/user/bin/<name>` (legacy fallback).

Each command has a help pair mirroring the `bin/` tree under `help/`, e.g.
`bin/lib/catMarkdown.Common` ↔ `help/lib/catMarkdown.help.include` +
`.help.md`. The `.help.include` prints `📘 Syntax:` line(s) and, on
`--help`, renders the paired `.help.md` via `myx.common lib/catMarkdown`.
