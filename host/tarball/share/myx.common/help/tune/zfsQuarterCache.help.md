# ZfsQuarterCache ( myx.common tune/zfsQuarterCache )

Set ZFS ARC to quarter of RAM.

Supported OS: FreeBSD.
Requires root privileges.

##  Arguments:

  None.

##  Options:

  --upsert

      Create or update setting.

  --remove

      Remove previously configured state.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Set ZFS ARC to quarter of RAM
	`myx.common tune/zfsQuarterCache`

	# Set ZFS ARC to quarter of RAM
	`myx.common tune/zfsQuarterCache --upsert`

	# Remove previously configured value
	`myx.common tune/zfsQuarterCache --remove`
