# InstallUserGroupMembership ( myx.common lib/installUserGroupMembership )

Ensure user membership in groups.

Supported OS: Linux, FreeBSD.
Requires root privileges.

##  Arguments:

  <username>

      User account name.

  <group1>

      First group name.

  <group2>

      Second group name.

##  Options:

  None.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Apply lib/installUserGroupMembership with provided arguments
	`myx.common lib/installUserGroupMembership myx wheel`

	# Apply lib/installUserGroupMembership with provided arguments
	`myx.common lib/installUserGroupMembership myx wheel operator`
