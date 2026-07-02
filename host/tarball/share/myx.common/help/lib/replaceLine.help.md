# ReplaceLine ( myx.common lib/replaceLine )

Replace matching line in a file.

Supported OS: Linux, FreeBSD, Darwin.

Replace or enforce a single configuration line in a text file.

This helper is intended for idempotent config updates in scripts, so running it
multiple times keeps the same final line without duplicating entries.

Behavior:
- Removes lines matching <from-regexp> (grep regexp match).
- Appends <to-value> if that exact line does not already exist.
- Creates a temporary .bak backup during rewrite.

Arguments:

  <file>

      Target file to update.

  <from-regexp>

      Search regexp for lines that should be removed before adding replacement.

  <to-value>

      Final line value to ensure in file.

Options:

  --create

      Create target directory/file when file does not exist yet.

Examples:

```sh
  myx.common lib/replaceLine /etc/ssh/sshd_config "^Port *" "Port 7727"
```

```sh
  myx.common lib/replaceLine /usr/local/etc/sudoers "^%wheel ALL=*" "%wheel ALL=(root) ALL"
```

```sh
  myx.common lib/replaceLine --create ./env/app.conf "^APP_MODE=" "APP_MODE=production"
```
