# InstallUser ( myx.common lib/installUser )

Create or update local user account.

Supported OS: Linux, FreeBSD.

Create or update a local system user and home directory.

Unifies user provisioning flow across Linux and FreeBSD scripts.

Arguments:

  <username>

      Account name.

  <user-title>

      Optional gecos/display title.

  <uid-or-gid>

      Optional numeric uid/gid value used during creation/update.

  <home-path>

      Optional home directory path.

Requirements:

  Root privileges.

Examples:

```sh
myx.common lib/installUser build "Build User" 1201 /home/build
```

```sh
myx.common lib/installUser deploy
```
