# InstallUser ( myx.common lib/installUser )

Create or update a local system user and home directory.

unifies user provisioning flow across Linux and FreeBSD scripts.

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

  root privileges.

Examples:

  myx.common lib/installUser build "Build User" 1201 /home/build
