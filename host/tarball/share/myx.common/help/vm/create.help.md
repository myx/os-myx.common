# Create ( myx.common vm/create )

Create or update VM configuration.

Supported OS: Linux, FreeBSD.

##  Arguments:

  {--freebsd|--linux|--ubuntu-lvm|--uefi}

      Required VM profile selector.
      Chooses the VM template/boot strategy.

      --uefi is FreeBSD only.

      Linux only: Backend (Proxmox+ZFS or libvirt+LVM) is selected automatically or via environment.

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

##  Environment:

  MYX_VM_ENGINE

      Override backend selection.
      Set to 'libvirt' to force libvirt+LVM backend instead of auto-detected Proxmox+ZFS.
      When unset, Proxmox is used if 'qm' and 'pvesm' are available; otherwise libvirt.

  MYX_VM_LVM_POOL

      Override libvirt LVM pool name used for VM disk volumes.
      When unset, the first active logical pool reported by virsh is used.

##  OS-Specifics:

  Root privileges:
    Linux: required.
    FreeBSD: not required.

  Profile selector:
    --uefi is FreeBSD only, not available on Linux.

  Backend (Linux only):
    Proxmox (qm/pvesm) is used if available; otherwise libvirt+LVM.
    Override via MYX_VM_ENGINE=libvirt.
    FreeBSD always uses vm-bhyve; there is no backend choice.

  Default ISO directories:
    FreeBSD (vm-bhyve): /vms/.iso/
    Linux (Proxmox backend): /var/lib/vz/template/iso/
    Linux (libvirt backend): /var/lib/libvirt/images/

##  Usage notes:

  Use --help to print detailed help for this command.

  ISO argument rules:
    If <iso> starts with '/', it is treated as an absolute file path.
    If <iso> does not start with '/', it is treated as a filename in the default ISO directory for the active system/backend.

  Relative paths with '/' are not accepted. Use either filename-only or absolute path.

##  Examples:

	# Create VM using FreeBSD profile
	`myx.common vm/create --freebsd dss-h3 8 8192M 120G --net lan22 52:54:20:22:20:32 FreeBSD-13.1-RELEASE-amd64-disc1.iso`

	# Create VM using Linux profile
	`myx.common vm/create --linux bb1-h1 8 8192M 120G --net lan22 52:54:20:25:20:28 ubuntu-20.04.3-live-server-amd64.installer.iso`

	# Create VM using Ubuntu LVM profile
	`myx.common vm/create --ubuntu-lvm bb1-h3 8 8192M 120G --net lan22 52:54:20:25:20:30 ubuntu-20.04.3-live-server-amd64.installer.iso`

	# Linux only: force libvirt+LVM backend on Linux host
	`MYX_VM_ENGINE=libvirt myx.common vm/create --ubuntu-lvm bb1-h3 8 8192M 120G --net br0 52:54:20:25:20:30 ubuntu-20.04.3-live-server-amd64.iso`
