# InstallPostfixMTA ( myx.common os/installPostfixMTA )

Install and enable Postfix MTA.

Supported OS: FreeBSD.

Configure Postfix as active MTA on FreeBSD host.

Ensures sendmail is disabled and postfix is consistently enabled/restarted.

##  Arguments:

  None.

##  Options:

  None.

##  Requirements:

  Root privileges.

Behavior:

  Stops sendmail if running, sets compatibility_level=2, enables and restarts postfix.

##  Examples:

	# Install and enable Postfix MTA
	`myx.common os/installPostfixMTA`
