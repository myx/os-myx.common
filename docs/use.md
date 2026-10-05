# Use

[Back to the README](../README.md)

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
