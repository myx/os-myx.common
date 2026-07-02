# NotifySlack ( myx.common lib/notifySlack )

Send notification to Slack.

Supported OS: Linux, FreeBSD, Darwin.

Usage notes:

  Use --help to print detailed help for this command.

Notes:

  Note:
  When ommited, bearer, channel and user are taken from SLACK_TOKEN, SLACK_TOPIC and HOST env variables respectively.
  When channel selected using --alert, --audit, --track or --debug option, command will override channel selection using SLACK_{ALERT|AUDIT|TRACK|DEBUG} (defaulting to SLACK_TOPIC) env varisable respectively.
  When --logger option is set, message will be duplicated to system logger facility and stderr standard output stream.
