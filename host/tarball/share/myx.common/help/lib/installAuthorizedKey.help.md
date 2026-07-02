# InstallAuthorizedKey ( myx.common lib/installAuthorizedKey )

Install SSH key for a user.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges.

##  Arguments:

  <user-name>

      User account name.

  <ssh-key>

      SSH public key string.

##  Options:

  --remove

      Remove previously configured state.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Apply lib/installAuthorizedKey with provided arguments
	`myx.common lib/installAuthorizedKey deploy 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGexamplekey deploy@host'`

	# Remove previously configured value
	`myx.common lib/installAuthorizedKey deploy 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGexamplekey deploy@host' --remove`
