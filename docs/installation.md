# Installation

[Back to the README](../README.md)

## Requirements

- macOS, FreeBSD, or Linux with `apt`. Run as root, the installer checks for one of these.
- `curl`, `fetch` or `wget`, for the download.
- Network access to `raw.githubusercontent.com` and `github.com`.

## Install

With `curl`:

	curl -L https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e

With `fetch`, on FreeBSD:

	fetch -o - https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e

With no network access to the script itself, paste it instead. Run this as root, paste the whole script text, then press CTRL+D:

	sh -c 'eval "`cat`"'

Run as root, the installer puts the command at `/usr/local/bin/myx.common` and its files under `/usr/local/share/myx.common/`.

Per-OS install scripts also exist: [macOS](https://github.com/myx/os-myx.common-macosx), [Ubuntu and Debian](https://github.com/myx/os-myx.common-ubuntu), [FreeBSD](https://github.com/myx/os-myx.common-freebsd). Each README says how it differs from this installer.

## Upgrade, reinstall, uninstall

Run the install command again to upgrade. It downloads the current `master` and replaces the installed files.

Reinstall from upstream later, or remove it:

	myx.common install/myx.common-reinstall
	myx.common remove/myx.common-uninstall --yes

## Shell completion

Install shell completion, then press TAB after `myx.common ` to list commands:

	myx.common setup/completion
