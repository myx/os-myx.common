# InstallRootAuthorizedKey ( myx.common lib/installRootAuthorizedKey )

Install SSH key for root user.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges.

Usage notes:

  Use --help to print detailed help for this command.

Examples:

```sh
  myx.common lib/installRootAuthorizedKey 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGrootexamplekey root@host'
```

```sh
  myx.common lib/installRootAuthorizedKey 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGrootexamplekey root@host' --remove
```
