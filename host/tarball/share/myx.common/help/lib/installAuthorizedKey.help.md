# InstallAuthorizedKey ( myx.common lib/installAuthorizedKey )

Install SSH key for a user.

Supported OS: Linux, FreeBSD, Darwin.
Requires root privileges.

Usage notes:

  Use --help to print detailed help for this command.

Examples:

```sh
  myx.common lib/installAuthorizedKey deploy 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGexamplekey deploy@host'
```

```sh
  myx.common lib/installAuthorizedKey deploy 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGexamplekey deploy@host' --remove
```
