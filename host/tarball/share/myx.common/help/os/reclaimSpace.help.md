# ReclaimSpace ( myx.common os/reclaimSpace )

Run platform-specific cleanup tasks to free disk space.

collects common cache/log cleanup operations into one command for maintenance flows.

Requirements:

  root privileges.

Behavior:

  Linux: apt cache cleanup, autoremove, /tmp cleanup, journal vacuum.
  FreeBSD: pkg autoremove/clean, /tmp cleanup, freebsd-update cache cleanup.

Examples:

  sudo myx.common os/reclaimSpace
