# SetLoaderConf ( myx.common lib/setLoaderConf )

Set key/value in loader.conf.

Supported OS: FreeBSD.
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

	# Set parameter value with lib/setLoaderConf
	`myx.common lib/setLoaderConf kern.maxfiles 200000`

	# Increase value when target is higher
	`myx.common lib/setLoaderConf kern.maxfiles --grow 250000`

	# Decrease value when target is lower
	`myx.common lib/setLoaderConf kern.maxfiles --shrink 150000`
