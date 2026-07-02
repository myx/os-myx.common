# NeedsReboot ( myx.common os/needsReboot )

Check whether reboot is required.

Supported OS: Linux, FreeBSD.

Check reboot requirement state and optionally trigger reboot.

Provides a portable interface for update workflows that need reboot gating.

##  Arguments:

  None.

##  Options:

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

##  Notes:

  Exit codes:
  - `0`: reboot-required
  - `1`: up-to-date
  - `2`: invalid-args

##  Examples:

	# Force printing current status
	`myx.common os/needsReboot --print`

	# Suppress normal status output
	`myx.common os/needsReboot --silent`
