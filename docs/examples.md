# Examples

[Back to the README](../README.md)

## Find what runs on this machine

	myx.common which os/getCpuCount
	myx.common which --uname FreeBSD os/getCpuCount

## Read help for another platform

	myx.common help --uname Linux os/getUtilityPackage

## Clone or update a repository

	myx.common git/clonePull /tmp/example-repo https://github.com/example/example.git
	myx.common git/clonePull --on-conflict-stash /tmp/example-repo https://github.com/example/example.git main

## Run a script from stdin

	printf 'echo hello-from-stdin\n' | myx.common lib/execShStdin
	printf 'echo "shell=$0"\n' | myx.common lib/execShStdin --bash

## Register and remove the MCP server

	myx.common setup/agentMcp
	myx.common remove/agentMcp

Run both from the same directory. Restart the agent host after `setup/agentMcp`, so it picks up the server.
