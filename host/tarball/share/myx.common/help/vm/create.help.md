# Create ( myx.common vm/create )

Create or update VM configuration.

Supported OS: FreeBSD.

Usage notes:

  Use --help to print detailed help for this command.

Examples:

  myx.common vm/create --linux/--freebsd/--ubuntu-lvm <name> <cores> <ram> <disk> [--shrink-disk] [--net <lan-name> <mac-address>...] <iso>
  myx.common vm/create --linux      bb1-h1  8  8192M 120G --net lan22 52:54:20:25:20:28 ubuntu-20.04.3-live-server-amd64.iso
  myx.common vm/create --freebsd    dss-h3  8  8192M 120G --net lan22 52:54:20:22:20:32 FreeBSD-13.1-RELEASE-amd64-disc1.iso
  myx.common vm/create --ubuntu-lvm bb1-h3  8  8192M 120G --net lan22 52:54:20:25:20:30 ubuntu-20.04.3-live-server-amd64.iso
