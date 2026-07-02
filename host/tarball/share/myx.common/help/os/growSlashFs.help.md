# GrowSlashFs ( myx.common os/growSlashFs )

Grow Linux root filesystem.

Supported OS: Linux.
Requires root privileges.

##  Arguments:

  None.

##  Options:

  --execute

      Option supported by this command.

##  Usage notes:

  Use --help to print detailed help for this command.


##  Notes:

  Grows root filesystem to fill all available disk/partition space (plain or LVM; ext2/ext3/ext4/xfs/btrfs).
  Default: preview mode (prints detected values and planned command).
  Execute: pass --execute to run planned command chain.
  Requires tools as needed: findmnt, lsblk, growpart, pvresize/lvextend, resize2fs/xfs_growfs/btrfs.

##  Examples:

	# Grow Linux root filesystem
	`myx.common os/growSlashFs`

	# Grow Linux root filesystem
	`myx.common os/growSlashFs --execute`
