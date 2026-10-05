# os-myx.common

One command — `myx.common` — for everyday system administration on Linux, FreeBSD
and macOS. Each operation picks the right implementation for the machine it runs
on, so the same line works everywhere.

## Documentation

- [Installation](docs/installation.md) — requirements, install, upgrade and uninstall.
- [Configuration](docs/configuration.md) — settings, profile options and configuration commands.
- [Use](docs/use.md) — getting started, common tasks and selecting what to act on.
- [Commands](docs/commands.md) — the command reference.
- [Formats](docs/formats.md) — file formats, directives, stages and folder layout.
- [Extension](docs/extension.md) — adding your own members, builders, directives and commands.
- [Examples](docs/examples.md) — worked examples from start to finish.
- [Troubleshooting](docs/troubleshooting.md) — symptoms, causes and actions.

## Getting help

- `myx.common help` — every command available on this machine.
- `myx.common help <command>` — full syntax, per-platform variants, and whether root is required.
- `myx.common which <command>` — the exact script this machine will run.
- Press TAB after `myx.common ` once completion is installed.

## Related packages

Per-OS install entry points. Each one only bootstraps `os-myx.common`; all the
command logic lives here.

- [os-myx.common-macosx](https://github.com/myx/os-myx.common-macosx) — macOS install script.
- [os-myx.common-ubuntu](https://github.com/myx/os-myx.common-ubuntu) — Ubuntu and Debian install script.
- [os-myx.common-freebsd](https://github.com/myx/os-myx.common-freebsd) — FreeBSD install script.
