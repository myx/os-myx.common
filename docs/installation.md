# Installation

[Back to the README](../README.md)

With `curl`:

	curl -L https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e

With `fetch`, on FreeBSD:

	fetch -o - https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e

Reinstall from upstream later, or remove it:

	myx.common install/myx.common-reinstall
	myx.common remove/myx.common-uninstall --yes

Install shell completion, then press TAB after `myx.common ` to list commands:

	myx.common setup/completion
