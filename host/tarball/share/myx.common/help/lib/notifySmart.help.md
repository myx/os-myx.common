# NotifySmart ( myx.common lib/notifySmart )

Send notification through available channel.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  None.

##  Options:

  --alert

      Use alert channel selection.

  --audit

      Use audit channel selection.

  --track

      Use track channel selection.

  --debug

      Use debug channel selection.

  --user <user-name>

      Set target user.

  --emoji <emoji>

      Set emoji marker.

  --text <message>

      Set message text.

##  Usage notes:

  Use --help to print detailed help for this command.


##  Notes:

  Note:
  This command will write the message to stderr and system logging utility.
  If there is SLACK_TOKEN environment variable set, it will try sending Slack message as well.

##  Examples:

	# List available commands and groups
	`myx.common help`
