# Java ( myx.common install/java )

Install Java runtime/tools.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges.

##  Arguments:

  None.

##  Options:

  None.

##  OS-Specifics:

  Darwin: installed via Homebrew (myx.common lib/installEnsurePackage,
  package 'openjdk'). Bootstraps Homebrew first if not already present.
  Invoke via sudo; the SUDO_USER env variable must be set.

  Linux, FreeBSD: installed via the native package manager
  (myx.common lib/installEnsurePackage, package name per OS).

##  Usage notes:

  Use --help to print detailed help for this command.

  If Java is already installed, this command reports its version and
  exits without changes, on all supported OS.

##  Examples:

	# Ensure Java is installed
	`myx.common install/java`
