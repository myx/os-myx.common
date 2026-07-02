# NotifySlack ( myx.common lib/notifySlack )

Send notification to Slack.

Supported OS: Linux, FreeBSD, Darwin.

##  Arguments:

  None.

##  Options:

  --text <text>

      Set message text.

  --logger

      Also write output to system logger.

  --bearer <token-bearer>

      Set bearer token value.

  --channel <channel>

      Set target channel.

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

##  Usage notes:

  Use --help to print detailed help for this command.


##  Notes:

  Note:
  When ommited, bearer, channel and user are taken from SLACK_TOKEN, SLACK_TOPIC and HOST env variables respectively.
  When channel selected using --alert, --audit, --track or --debug option, command will override channel selection using SLACK_{ALERT|AUDIT|TRACK|DEBUG} (defaulting to SLACK_TOPIC) env varisable respectively.
  When --logger option is set, message will be duplicated to system logger facility and stderr standard output stream.

##  Examples:

	# Send notification to Slack
	`myx.common lib/notifySlack --text "Deploy complete"`

	# Send notification to a selected channel
	`myx.common lib/notifySlack --text "Disk pressure on db01" --alert --emoji :warning:`

	# Run for a specific user
	`myx.common lib/notifySlack --text "Backup finished" --logger --channel ops --user buildbot`
