# Server ( myx.common setup/server )

Apply server-side host setup.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges.

##  Arguments:

  None.

##  Options:

  --postfix-mta

      FreeBSD only. Installs and enables Postfix MTA (myx.common os/installPostfixMTA).

##  OS-Specifics:

  --postfix-mta:
    FreeBSD: installs and enables Postfix MTA.
    Linux, Darwin: accepted but silently ignored, no effect.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Apply server-side host setup
	`myx.common setup/server`

	# Apply server-side host setup
	`myx.common setup/server --postfix-mta`
