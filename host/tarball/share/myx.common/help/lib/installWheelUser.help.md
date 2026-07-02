# InstallWheelUser ( myx.common lib/installWheelUser )

Create/update a user and grant membership in administrative wheel/sudo groups.

combines user creation and admin group assignment in one idempotent helper.

Arguments:

  <username>

      Account name to create or update.

  <user-title>

      Optional descriptive user title/gecos.

Requirements:

  root privileges.

Examples:

  myx.common lib/installWheelUser deploy "Deploy User"
