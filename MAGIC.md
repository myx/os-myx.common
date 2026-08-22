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

## Two calling conventions — easy to mix up

Both appear throughout `bin/`, and they are not interchangeable.

1. **Direct source, no dispatch** — `type <FunctionName> >/dev/null 2>&1 || . "${MYXROOT:-...}/bin/<category>/<name>.Common"`. Guards against re-sourcing, and hardcodes `.Common`: no subprocess, no OS-dispatch lookup. Pervasive, for functions assumed OS-invariant.
2. **Full dispatch** — `myx.common <category>/<name> [args]`, through the resolution order above. Costs a subprocess spawn, and is OS-aware.

- Convention 1 is only safe for a function with no real per-OS behaviour.
- A function that does need OS dispatch but is still reached by convention 1 must replicate the OS selection inside its own `.Common` file. `install/ensure/nativePackage.Common` is the pattern: it sources `nativePackage.$MYXUNIX`, delegates to it, and errors with `abstract method` when the running OS has no override. `lib/installEnsurePackage.Common` reaches it by convention 1.
- Any new command with real per-OS variants reached by convention 1 needs that same self-redirect, or a switch to convention 2.
- `myx.distro-*` uses the same `type X || . file` idiom but resolves the path with `myx.common which lib/X` — one subprocess, still OS-aware. A stricter form of the same pattern.

## `bin/` command ↔ `help/` pair

- Every `bin/<category>/<name>.<Variant>` has two files under `help/` at the matching relative path: `<name>.help.include` (short syntax, sourced by the command's own `--help` branch) and `<name>.help.md` (the full manual).
- One pair per command name, never per OS variant — the same text serves `.Common` and every `.<Platform>` sibling. This is why `myx.common help <command>` sources the `.help.include` directly instead of re-running the command, which would re-resolve against the live host and lose `--uname`.
- A new `bin/` command without both files is incomplete.

## `bin/` (public command) vs `include/` (internal resource)

- Not every script under `share/myx.common/` is a dispatchable command. `bin/` is the public, completable surface and needs the full help pair. `include/` is internal.
- `include/data/` holds raw resources, and standalone scripts an external system invokes at a fixed absolute path — `agentMcpServerJsonUpsert.py`, `agentMcpCopilotTrustUpsert.py`, `agentMcpConfigEdit.awk`, `agentMcpJsonEscape.awk`, `agentMcpTools.json`. `setup/agentMcp` reaches each as `$root/include/data/<file>`, never through the dispatcher.
- Those deliberately have no help pair, no README entry, and never appear in `myx.common help --bare`.
- "Needs a stable dispatcher-independent path" and "is a public command" are separate, independently decidable properties. A fixed-path requirement does not imply `include/`, and it does not imply `bin/` either: the MCP stdio server is `bin/lib/agentMcpServer.Common`, a public command with its own help pair, which `setup/agentMcp` still registers by direct file path because an MCP host config needs a path rather than a dispatcher call.

## `include/data/*.awk` — reusable JSON-parsing engine, copy don't reinvent

- `include/data/agentMcpJsonParseRequest.awk` carries a self-contained recursive-descent JSON engine — `skipws`, `hex2dec`, `utf8enc`, `parseString`, `parseValue`, `parseObject`, `parseArray` — plus an `emitLeaf` tailored to the exact field shape its one caller needs.
- It is not a general-purpose JSON parser, and its own header says so. It understands exactly the shapes its caller produces.
- `myx.distro-agents/sh-lib/AgentsSlackMessagesFormat.awk` is the same engine with its own `emitLeaf`, for Slack message fields — the established precedent for reuse across packages.
- For a third consumer pulling specific fields out of a small, predictable JSON shape from awk: copy the engine verbatim and write a new `emitLeaf`. No hand-rolled parser, no `jq` or `python3 -c` substitute.
- The reason is the zero-dependency constraint: these run where a JSON dependency cannot be assumed present.

## Verify a help claim by running the command

- Every claim in a `help.md` comes from actually running the command, never from reading its source.
- A legacy shim under `include/obsolete/user/bin/` needs no help pair and does not appear in `myx.common help`.
- A shim without its `+x` bit is unreachable, and the dispatcher reports nothing about it. Set mode 755 and invoke it to confirm.
