# InstallUserPasswordHash ( myx.common lib/installUserPasswordHash )

Set user password hash.

Supported OS: Linux, FreeBSD.

Set password hash for an existing local user.

Automates non-interactive account password provisioning from deployment scripts.

##  Arguments:

  <username>

      Existing account name.

  <password-hash>

      Hash value accepted by target platform usermod/pw tooling.

##  Options:

  None.

##  Requirements:

  Root privileges.

##  Examples:

	# Apply lib/installUserPasswordHash with provided arguments
	`myx.common lib/installUserPasswordHash deploy '$6$.'`
