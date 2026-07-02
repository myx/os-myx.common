# RemoteContext ( myx.common lib/remoteContext )

Build/execute remote shell context script.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

	--insert-tarball <tarball-path>

				Will insert contents of given local tar file to be extracted into remote's temp directory
				used as root.

	--insert-path <path>
	--insert-path <base-path>:<relative-path>

				Will insert contents of given directory into relative path of remote's temp directory

	--insert-script <script-source-path>

				Will insert contents of script source file provided into executable rc-script that will
				execute after all directories are unpacked.

	--insert-command <script-source>

				Will insert the script text provided in <script-source> argument into executable rc-script
				that will execute after all directories are unpacked.

##  Options:

	--verbose, -v

				Adds a line before and after execution, so you see commands that do not
				output anything.

	--interactive, -i

				Adds 'exec bash -l' to remote script and executes 'cat' locally.

	--force, -f

				Do not fail on errors (less pipe checks and ignore if input file or directory is missing).

	--require-bash

				Sometimes your scripts need bash to run. Do require 'bash' to be running or available.
				Will check for bash, will try to spawn to bash, will fail cleanly if bash not available.
				Will try to install bash if --force is specified and we run under root, when --force &&
				--interactive are used will try sudo if not root.

	--use-bzip2, --bz2

				Use `bzip2` compression. (Default is `gzip`; `bzip2` may not be available on pristine
				linux systems.)

	--use-xz, --xz

				Use `xz` compression. (Default is `gzip`; `xz` may not be available on pristine MacOS,
				linux or FreeBSD systems.)

	--use-gzip, --gzip

				Use `gzip` compression. (This is the default setting.)

	--myx.common

				Adds `myx.common` files and inserts commands to make sure it is found in 'PATH' variable.

##  Usage notes:

	This command emits a shell payload.

	Use one of two execution modes:
	1) Pass remote target with `--do-ssh`.
	2) Pipe payload to `ssh ... sh -s` manually.

##  Examples:

	# Run via built-in SSH mode
	`myx.common lib/remoteContext --insert-command 'uname -a' --do-ssh -p 27 root@server3.example.org`

	# Run via explicit pipe to SSH
	`myx.common lib/remoteContext --insert-command 'uname -a' | ssh -p 27 root@server3.example.org sh -s`

	# Open interactive remote session context
	`myx.common lib/remoteContext --interactive --insert-path "/usr/local/:share/myx.common" --insert-script "/usr/local/share/myx.common/include/data/console-myx.common-bootstrap"`

	# Open interactive remote session context
	`myx.common lib/remoteContext --interactive --insert-path "/usr/local/:share/myx.common" --insert-command 'export PATH="$PWD/share/myx.common:$PATH"'`

	# Open interactive remote session context
	`myx.common lib/remoteContext --interactive --insert-path "$MY_APP/remote-tarball" --insert-command "$( RemoteScriptGenerator.sh --make )"`
