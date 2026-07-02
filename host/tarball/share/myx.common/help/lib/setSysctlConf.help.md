# SetSysctlConf ( myx.common lib/setSysctlConf )

Set key/value in sysctl.conf.

Supported OS: Linux, FreeBSD.
Requires root privileges.

##  Arguments:

  <parameter>

      Configuration parameter name.

  <value>

      Target value to apply.

##  Options:

  --grow

      Option supported by this command.

  --shrink

      Option supported by this command.

##  Usage notes:

  Use --help to print detailed help for this command.

##  Examples:

	# Set parameter value with lib/setSysctlConf
	`myx.common lib/setSysctlConf kern.maxfiles 200000`

	# Increase value when target is higher
	`myx.common lib/setSysctlConf kern.maxfiles --grow 250000`

	# Decrease value when target is lower
	`myx.common lib/setSysctlConf kern.maxfiles --shrink 150000`
