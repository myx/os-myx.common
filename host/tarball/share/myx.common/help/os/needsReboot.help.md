# NeedsReboot ( myx.common os/needsReboot )

Check whether reboot is required.

Supported OS: Linux, FreeBSD.

Check reboot requirement state and optionally trigger reboot.

Provides a portable interface for update workflows that need reboot gating.

Options:

  --silent

      Suppress normal status output.

  --print

      Force status output.

  --reboot

      Reboot when reboot is required.

  --no-reboot

      Never reboot; only report status.

Output:

  Reboot or Latest (suppressed with --silent).

Examples:

  myx.common os/needsReboot --print
  myx.common os/needsReboot --silent

Notes:

  Exit: 0=reboot-required, 1=up-to-date, 2=invalid-args
