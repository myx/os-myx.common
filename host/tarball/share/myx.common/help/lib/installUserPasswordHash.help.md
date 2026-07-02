# InstallUserPasswordHash ( myx.common lib/installUserPasswordHash )

Set password hash for an existing local user.

automates non-interactive account password provisioning from deployment scripts.

Arguments:

  <username>

      Existing account name.

  <password-hash>

      Hash value accepted by target platform usermod/pw tooling.

Requirements:

  root privileges.

Examples:

  myx.common lib/installUserPasswordHash deploy '$6$....'
