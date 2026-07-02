# InstallWheelUser ( myx.common lib/installWheelUser )

Create admin-capable user account.

Supported OS: Linux, FreeBSD, Darwin.

Create/update a user and grant membership in administrative wheel/sudo groups.

Combines user creation and admin group assignment in one idempotent helper.

##  Arguments:

  <username>

      Account name to create or update.

  <user-title>

      Optional descriptive user title/gecos.

##  Options:

  None.

##  Requirements:

  Root privileges.

##  Examples:

	# Apply lib/installWheelUser with provided arguments
	`myx.common lib/installWheelUser deploy "Deploy User"`

	# Apply lib/installWheelUser with provided arguments
	`myx.common lib/installWheelUser demo myx`

	# Apply lib/installWheelUser with provided arguments
	`myx.common lib/installWheelUser demo`
