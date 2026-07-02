# InstallWheelUser ( myx.common lib/installWheelUser )

Create admin-capable user account.

Supported OS: Linux, FreeBSD, Darwin.

Create/update a user and grant membership in administrative wheel/sudo groups.

Combines user creation and admin group assignment in one idempotent helper.

Arguments:

  <username>

      Account name to create or update.

  <user-title>

      Optional descriptive user title/gecos.

Requirements:

  Root privileges.

Examples:

```sh
  myx.common lib/installWheelUser deploy "Deploy User"
```

```sh
  myx.common lib/installWheelUser demo myx
```

```sh
  myx.common lib/installWheelUser demo
```
