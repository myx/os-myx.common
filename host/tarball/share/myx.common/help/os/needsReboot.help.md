# NeedsReboot ( myx.common os/needsReboot )

Check reboot requirement state and optionally trigger reboot.

provides a portable interface for update workflows that need reboot gating.

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
