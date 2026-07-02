# GrowSlashFsUfs ( myx.common os/growSlashFsUfs )

Grow FreeBSD UFS root filesystem to consume additional disk space.

Supported OS: FreeBSD.

Encapsulates gpart + growfs sequence required after disk expansion.

Arguments:

  <disk-name> <slice-name> [<ufs-partition-index> [<swap-partition-index>]]

      Manual device selectors when auto values are not desired.

Options:

  --yes, --execute

      Execute immediately instead of dry syntax/help mode.

Requirements:

  Root privileges.

Examples:

  myx.common os/growSlashFsUfs --execute
  myx.common os/growSlashFsUfs ada0 s1 2 3
