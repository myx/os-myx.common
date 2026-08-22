# MAGIC.md — os-myx.common

Team-owned notes for the magic-* team. `myx.common` and `myx.distro-*` are separate projects that share a name prefix; nothing in the `myx.distro-*` MAGIC.md files carries over here.

## Command resolution: `<name>.<Variant>`

`myx.common <category>/<name>` tries three paths in this fixed order and takes the first match. Never reorder them.

1. `bin/<category>/<name>.$(uname -s)` — this OS's own implementation.
2. `bin/<category>/<name>.Common` — the cross-platform implementation.
3. `include/obsolete/user/bin/<category>/<name>` — legacy-name fallback, a thin redirect kept after a rename.

- `bin/myx.common` runs the match only if it is executable, so a candidate missing its `+x` bit is skipped silently and the next one wins.
- `lib/which` walks the same chain but tests for a plain file, so it can name a path the dispatcher would refuse to run.
- `lib/which --uname <OS>` and `MYXUNIX` resolve the chain as another OS would. `bin/myx.common` itself always reads the live `$(uname -s)`.
- `Abstract` is a template stub. The dispatcher never selects it.

## `bin/` command ↔ `help/` pair

- Every `bin/<category>/<name>.<Variant>` has two files under `help/` at the matching relative path: `<name>.help.include` (short syntax, sourced by the command's own `--help` branch) and `<name>.help.md` (the full manual).
- One pair per command name, never per OS variant — the same text serves `.Common` and every `.<Platform>` sibling. This is why `myx.common help <command>` sources the `.help.include` directly instead of re-running the command, which would re-resolve against the live host and lose `--uname`.
- A new `bin/` command without both files is incomplete.
- `include/` scripts deliberately have no pair. `include/data/` holds raw resources and standalone scripts that an external system invokes at a fixed path; needing a stable path does not make something a public command.

## Verify a help claim by running the command

- Every claim in a `help.md` comes from actually running the command, never from reading its source.
- A legacy shim under `include/obsolete/user/bin/` needs no help pair and does not appear in `myx.common help`.
- A shim without its `+x` bit is unreachable, and the dispatcher reports nothing about it. Set mode 755 and invoke it to confirm.