# InstallRootAuthorizedKey ( myx.common lib/installRootAuthorizedKey )

Install SSH key for root user.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges.

##  Arguments:

  <ssh-key>

      SSH public key string.

##  Options:

  --remove

      Remove previously configured state.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Apply lib/installRootAuthorizedKey with provided arguments
	`myx.common lib/installRootAuthorizedKey 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGrootexamplekey root@host'`

	# Remove previously configured value
	`myx.common lib/installRootAuthorizedKey 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGrootexamplekey root@host' --remove`
