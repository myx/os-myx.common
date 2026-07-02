# InstallPostfixMTA ( myx.common os/installPostfixMTA )

Configure Postfix as active MTA on FreeBSD host.

ensures sendmail is disabled and postfix is consistently enabled/restarted.

Requirements:

  root privileges.

Behavior:

  stops sendmail if running, sets compatibility_level=2, enables and restarts postfix.

Examples:

  myx.common os/installPostfixMTA
