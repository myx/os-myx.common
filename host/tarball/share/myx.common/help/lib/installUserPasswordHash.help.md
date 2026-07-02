# InstallUserPasswordHash ( myx.common lib/installUserPasswordHash )

Set user password hash.

Supported OS: Linux, FreeBSD.

Set password hash for an existing local user.

Automates non-interactive account password provisioning from deployment scripts.

Arguments:

  <username>

      Existing account name.

  <password-hash>

      Hash value accepted by target platform usermod/pw tooling.

Requirements:

  Root privileges.

Examples:

```sh
  myx.common lib/installUserPasswordHash deploy '$6$.'
```
