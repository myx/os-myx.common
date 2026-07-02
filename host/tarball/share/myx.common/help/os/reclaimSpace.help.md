# ReclaimSpace ( myx.common os/reclaimSpace )

Clean caches/logs to reclaim disk space.

Supported OS: Linux, FreeBSD.

Run platform-specific cleanup tasks to free disk space.

Collects common cache/log cleanup operations into one command for maintenance flows.

Requirements:

  Root privileges.

Behavior:

  Linux: apt cache cleanup, autoremove, /tmp cleanup, journal vacuum.
  FreeBSD: pkg autoremove/clean, /tmp cleanup, freebsd-update cache cleanup.

Examples:

  Sudo myx.common os/reclaimSpace

Notes:

  Actions: clean /tmp, apt cache, apt autoremove, journal vacuum
  actions: clean /tmp, freebsd-update cache, pkg cache, pkg autoremove
