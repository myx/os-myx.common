# Create ( myx.common vm/create )

Create or update VM configuration.

Supported OS: FreeBSD.

##  Arguments:

  {--freebsd|--linux|--ubuntu-lvm}

      Required VM profile selector.
      Chooses the VM template/boot strategy used by creation flow.

  <name>

      VM name/template identifier.

  <cores>

      CPU core count.

  <ram>

      Memory size.

  <disk>

      Disk size.

  <iso>

      Installer ISO filename/path.

##  Options:

  --shrink-disk

      Allow shrinking disk in VM profile.

  --net <lan-name> <mac-address>...

      Configure VM network pair arguments.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Create VM with explicit resource settings
	`myx.common vm/create --linux bb1-h1 8 8192M 120G --net lan22 52:54:20:25:20:28 ubuntu-20.04.3-live-server-amd64.installer.iso`

	# Create VM with explicit resource settings
	`myx.common vm/create --freebsd dss-h3 8 8192M 120G --net lan22 52:54:20:22:20:32 FreeBSD-13.1-RELEASE-amd64-disc1.installer.iso`

	# Create VM with explicit resource settings
	`myx.common vm/create --ubuntu-lvm bb1-h3 8 8192M 120G --net lan22 52:54:20:25:20:30 ubuntu-20.04.3-live-server-amd64.installer.iso`
