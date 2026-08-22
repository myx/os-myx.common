# os-myx.common — AI assistant context

Self-contained cross-platform (Linux/FreeBSD/Darwin) devops CLI. Not
architecturally related to myx.distro-*: its `project.inf` `Provides:`
entries (`deploy-export:...`, `image-install:exec-update-before:...`) only
register it as an installable package in the distro-* index/pipeline — the
command tool itself has no dependency on distro-* code or conventions.
distro-* conventions don't carry over here, nor the reverse.

Canonical human doc: `README.md` — install, everyday tasks and the command
index, written for a person using the tool. No generator produces it —
hand-maintained, synced by hand when commands change.

Contributor mechanics are in `MAGIC.md` — the `<name>.<Variant>` command
resolution order, the two calling conventions and their OS-dispatch trap, the
`bin/` ↔ `help/` pairing rule, `bin/` vs `include/`, and the reusable
`include/data/*.awk` JSON engine.

## Sibling repos are install-only placeholders

`os-myx.common-macosx`/`-ubuntu`/`-freebsd` each contain only `LICENSE` +
`project.inf` + `README.md` + one `install-myx.common-<os>.sh` script. All
command logic lives in `os-myx.common` itself, which already supports every
OS via the `.Common`/`.<Platform>` suffix mechanism (see README). The
sibling repos don't add commands — they just give each OS its own install
entry point/URL.
