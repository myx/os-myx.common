# IpfwOpen ( myx.common setup/ipfw-open )

Open selected firewall services.

Supported OS: FreeBSD.
Requires root privileges.

##  Arguments:

  None.

##  Options:

  --force

      Rewrite /usr/local/etc/ipfw.sh.
      By default, the file is written only when it is missing or empty.

##  Usage notes:

  Use --help to print detailed help for this command.


##  Notes:

##  Examples:

	# Open selected firewall services
	`myx.common setup/ipfw-open`

	# Force apply and overwrite existing state
	`myx.common setup/ipfw-open --force`
