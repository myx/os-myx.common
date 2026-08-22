# MAGIC.md — os-myx.common

Team-owned notes for the magic-* team. `myx.common` and `myx.distro-*` are separate projects that share a name prefix; nothing in the `myx.distro-*` MAGIC.md files carries over here.

## Probing git state here

- `myx.common/` is a container directory, not a repository. It holds four sibling repos one level down — `os-myx.common`, `os-myx.common-macosx`, `os-myx.common-ubuntu`, `os-myx.common-freebsd` — and the enclosing `source/` tree is not a repository either.
- `git rev-parse` from either of those levels answers "not a git repository": a true answer to the wrong question, and not evidence that a file is untracked.
- Probe from `os-myx.common/` itself. A destructive-looking edit there has a real `git checkout -- <path>` restore.

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
- `include/data/` holds raw resources, and standalone scripts an external system invokes at a fixed absolute path — `agentMcpServerJsonUpsert.awk`, `agentMcpCopilotTrustUpsert.awk`, `agentMcpConfigEdit.awk`, `agentMcpJsonEscape.awk`, `agentMcpTools.json`. `setup/agentMcp` reaches each as `$root/include/data/<file>`, never through the dispatcher.
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

## `bin/lib/agentMcpServer.Common` — MCP stdio server

How it is reached, and why it is shaped that way.

- Public and completable as `myx.common lib/agentMcpServer`, with its own help pair, but only ever really used one way: `myx.common setup/agentMcp` writes this file's absolute path plus `--run` into the MCP host's config as the launch command, and the host runs it as a subprocess. Not for interactive human use.
- It self-bootstraps `MYXROOT`/`MYXUNIX` from `$0` instead of trusting the dispatcher to have exported them, because that absolute-path launch bypasses the dispatcher entirely. Every other `bin/lib/*.Common` file can assume they are already set; this one cannot.
- The trailing `case "$0"` block is the standard `bin/lib/*.Common` dispatch shape, plus a `--run` guard unique to this file. Bare or accidental invocation must print help and exit, never fall into the loop — a long-running stdin-reading server started by accident hangs forever rather than merely printing the wrong thing.
- The server loop deliberately runs without `set -e`: it must survive an individual failing tool invocation, not abort the whole process on the first non-zero exit.

### Wire and payloads

- JSON-RPC 2.0 over stdin/stdout, newline-delimited, hand-rolled — no `jq`, no `python3`. Parsing and escaping come from the sibling `include/data/` awk resources; the tool definitions come from `include/data/agentMcpTools.json`.
- Tool definitions are static, so they live in a real `.json` file rather than an embedded shell literal — diffable and lintable as actual JSON. Its own newlines are stripped at load because the wire is newline-delimited.
- Two tools are exposed: `help` (wraps `myx.common help`) and `lib_execShStdin` (runs a command, returns stdout/stderr/exit status).
- `myx.common help` conventionally exits 1 even when it printed help successfully. The `help` tool therefore never derives `isError` from that exit status.
- **stdout is the wire itself.** The host parses every stdout line as a message, so nothing else may ever be written there — the startup diagnostic and every other message go to stderr.
- One session-id variable is folded from whichever host set one. `CLAUDE_CODE_SESSION_ID` is the only confirmed name; `COPILOT_SESSION_ID` and `GROK_SESSION_ID` are unconfirmed placeholders, harmless no-ops if unset and picked up automatically if a future host ever sets them. One flat fallback chain, no per-host branching.

### Resources capability

- `resources/list` and `resources/read` let a host read a command's full manual without spending a tool call — one resource per shipped `$MYXROOT/help/**/*.help.md`.
- URI is `myx-common://help/<category>/<name>`, mirroring the command's own addressing minus the `.help.md` suffix.
- `resources/read` re-derives and validates the path from the URI rather than trusting it: the URI is caller-supplied, and a well-behaved client is not the only possible one.
- This covers `$MYXROOT/help/*.help.md` only. The repo's own `README.md` is not part of the installed tree, so exposing it would first require changing what ships in the tarball.

### Concurrency model

- `lib_execShStdin` runs in the background so the request loop stays free to read and act on the next line — a `notifications/cancelled` for the in-flight call, a ping, another fast method — instead of blocking for the whole duration.
- Concurrent calls are allowed. Each in-flight job is tracked by its own request id under `$AGENT_MCP_REQ_BASE/inflight/<id>`, so unrelated calls never contend. A second call sharing an id already in flight is rejected with an immediate busy error rather than queued, so a single id's cancellation never has to reason about more than one job.
- A JSON-RPC id is untrusted — the spec permits string ids, so the raw token can contain `/`, `..`, or quotes, none of them safe in a path segment. `cksum(1)` derives the tracking filename: POSIX, a pure digit/space string on Darwin, FreeBSD and Linux alike, collision-resistant with no hand-rolled allow-list. It only needs to be stable within one running process, never across processes or machines.
- Response lines are serialized through a `mkdir`-based mutex. `mkdir` is atomic on every POSIX filesystem; `flock` is not guaranteed present on a bare FreeBSD or Darwin install. With more than one writer genuinely in flight this is not optional — without it two response lines could interleave mid-line and break JSON-RPC framing for both. Hold times are a single `printf`, so a tight spin is fine.
- The in-flight PID file is written to a private temp name then renamed into place. `mv(1)` within one directory is atomic, so a concurrent reader never observes a partially-written PID.
- `reqDir` is the loop's one shared scratch directory, wiped on the very next line read. Moving it to a uniquely-named private directory before backgrounding is what makes it safe for the async job to keep reading after the loop iteration returns.
- Cancellation sends TERM and clears tracking immediately, so a new call is not needlessly held busy waiting for the old one to die; the KILL escalation runs detached so neither the handler nor the loop blocks on it.

### Accepted limitations, not bugs

- **Timeout and cancellation are PID-based, not process-group-based.** A grandchild the command forks — a `curl` it shells out to, say — is not guaranteed to die with it and may linger detached. The same caveat covers PID reuse and the same-id busy check.
- No GNU `timeout(1)` dependency is assumed, since it is not guaranteed present on a bare FreeBSD or Darwin install; the optional `timeout` argument is a portable POSIX background-job plus watcher pattern instead, returning 124 when the watcher had to kill.
- The command is backgrounded directly rather than wrapped in a `( ... )` subshell, so `$!` is the real killable process — `env` execs into the target instead of forking, so its PID stays the target's PID. Routing every call through `env` even with zero `NAME=value` pairs avoids branching on whether env vars were requested.
- **Background jobs are deliberately not reaped.** POSIX sh has no portable non-blocking `wait`, and a blocking one would reintroduce exactly the stall this design avoids. They stay zombies until the server process exits and reaps them — typically once per MCP host session, so bounded and cheap rather than engineered away.
- **NUL bytes in command output are not supported** — a shared sh/awk limitation.
- A trailing newline at the very end of a command's output, or its absence, is not distinguishable after capture. Harmless for text results.

## Locale: the `include/data/*.awk` resources are byte tools

- `agentMcpJsonParseRequest.awk` and `agentMcpJsonEscape.awk` are byte-safe only when the caller sets `LC_ALL=C`. Raw UTF-8 has to pass through untouched, and `agentMcpJsonParseRequest.awk`'s `[A-Za-z_][A-Za-z0-9_]*` env-name guard has to collate as ASCII. Every call site in `setup/agentMcp` and `lib/agentMcpServer` sets it.
- A bracket range is locale-dependent and never safe unqualified. Measured on this estate's Darwin box: `case "A" in [a-z])` matches under `en_US.UTF-8`, and does not match under `LC_ALL=C`. Either pin `LC_ALL=C` or spell the set out.

## `include/data/agentMcpConfigEdit.awk` — locate and validate

- Two modes. `locate`, the default, walks `projects` -> `<cwd>` -> `mcpServers` -> `myx.common` and stops at the shallowest missing level, so the caller knows exactly what to splice in. `validate` prints `VALID`, or `INVALID <reason>`, for one well-formed JSON value with nothing left over — the post-splice sanity check, with no `jq` or `python3` involved.
- The caller passes the file unchanged; the program rejoins records under the default `RS` and acts in `END`. Every offset printed back is a 1-based byte offset into that file.
- `MYX_AGENTMCP_CWD` is an environment variable, never `-v cwd=...`. POSIX awk's `-v` performs its own backslash-escape decoding before assignment, which un-escapes the very `\"`/`\\` sequences `agentMcpJsonEscape.awk` just produced and breaks byte-comparison for a cwd containing `"` or `\`. `ENVIRON[]` values arrive undecoded. The observed failure is a duplicate `projects` key on re-run.
- Locate prints `PROJECTS_FOUND`, `PROJECT_FOUND`, `MCPSERVERS_FOUND` and `ENTRY_FOUND`. A missing level also prints that level's `*_FIRST_KEY_START` insertion point and `*_IS_EMPTY`. A present entry also prints `ENTRY_KEY_START`, `ENTRY_VALUE_START`, `ENTRY_VALUE_END`, `ENTRY_PAIR_END_NO_COMMA`, `ENTRY_PAIR_END_WITH_COMMA`, `ENTRY_HAD_TRAILING_COMMA` and `ENTRY_PRECEDING_COMMA_POS`.
- `NOTJSON`, `NOCWD`, `PARSE_ERROR` or any `*_NOT_OBJECT=1` means refuse and touch nothing.
- The `STALE_*` facts mark the first pair other than `myx.common` whose `command` sits inside the `myx.common` tree — a duplicate registration the host would launch twice. `myx.common` matches as a whole path component only; a directory merely named `not-myx.common-really` is a stranger's.

## `include/data/agentMcpJsonParseRequest.awk` — outDir fields

Each field goes to its own file under `-v outDir=...`, never to stdout or argv, so a value carrying embedded newlines or quotes round-trips intact.

- `method` — the method name, decoded.
- `has_id` — `1` when a top-level `id` was present; `id` — that id's raw JSON token, echoed back as-is.
- `tool_name` — `params.name`. `uri` — `params.uri`, decoded.
- `cancel_request_id` — `params.requestId` as a raw token, in the same format as `id` so the two compare directly.
- `client_name`, `client_version` — `params.clientInfo.*` on `initialize`, decoded.
- `arg_command`, `arg_uname`, `arg_stdin` — the matching `params.arguments.*`, decoded. `arg_timeout` — the raw number token.
- `arg_args_count` and `arg_args_<N>` — `params.arguments.args`. `arg_env_count`, `arg_env_name_<N>` and `arg_env_val_<N>` — `params.arguments.env`.
- An env key is emitted only when it matches `[A-Za-z_][A-Za-z0-9_]*`; a non-conforming key is skipped silently.
- Any other field is still parsed, to keep byte-position tracking correct, then discarded.
- **`comment` and `mergeOutputs` are declared in `agentMcpTools.json` and read by `agentMcpServer.Common` as `arg_comment` and `arg_merge_outputs`, but `emitLeaf` has no branch for either, so neither file is ever written.** `mergeOutputs: false` never separates the streams, and `comment` is never logged. Open, not yet fixed.

## `bin/setup/agentMcp.Common`

- Registers `bin/lib/agentMcpServer.Common --run` as an MCP server, keyed by the launch cwd, so each workspace or checkout keeps its own entry instead of one global entry that whichever workspace ran setup last silently overwrites.
- `MYX_AGENTMCP_TARGET_CWD` overrides `pwd` for a caller whose own process cwd is not the workspace being registered — an MCP-tool dispatch, whose server process holds a fixed cwd unrelated to the workspace the calling agent means. Without it the tier-2 marker check evaluates false: a plain wrong answer, not an error, with nothing to surface it.
- Three tiers, in this order:
  1. An explicit scope option, which would take priority over both below. None exists today; nothing to check until this command grows one.
  2. A real `myx.distro-*` workspace at the launch cwd — additionally upserts `<cwd>/.vscode/mcp.json`, VS Code/Copilot-Chat's own workspace-scoped config, top-level key `servers`, no git dependency. Detected by the `.local/myx/myx.distro-.local/sh-lib/LocalContext.include` marker at the exact cwd, no upward walk — the same check `myx.distro-system`'s `AgentsTools.Owner.include` uses.
  3. The home-scope registration, always, unless (1) ever applies: `~/.claude.json` `projects["<cwd>"].mcpServers."myx.common"`, spliced by byte range via `head`/`tail` and located by `agentMcpConfigEdit.awk`, never a full parse and rewrite. Backed up first, and validated as JSON before it replaces the original. Idempotent.
- **Tier 2 is additive, never a replacement for tier 3.** Claude Code does not read `.vscode/mcp.json` — `myx.distro-system` writes `.vscode/mcp.json` and `.mcp.json` as two separate targets for exactly that reason — so making tier 2 exclusive would silently stop Claude Code's own MCP discovery in every `myx.distro-*` workspace. A tier-2 failure is reported and must not block tier 3, which is why both tier-2 calls are wrapped in `||` against the caller's own `set -e`.
- Claude Code's own project-scope `.mcp.json` (top-level key `mcpServers`, requires a git repo root) is out of scope here, and still undecided.
- The pre-existing top-level `~/.claude.json` `"mcpServers"` key from before the local-scope rework is never read, migrated or removed. It simply stops receiving writes.
- Registration alone does not reach the copilot CLI: `copilot -p` is headless, with no TTY to prompt on, and silently skips starting any local/stdio MCP server unless cwd is already listed in `~/.copilot/settings.json` `trustedFolders`. Best-effort, and only when `copilot` is installed. Its temp file is written under `umask 077`, because `mv -f` carries the temp's mode and a 0644 temp would widen the 0600 target.
- The workspace upsert and the copilot trust edit live in their own `include/data/*.awk` files rather than an inline `awk '...'` block: shell-quoting a multi-line program body inline is exactly the syntax this codebase avoids by convention. They are `myx.common`-owned copies of the `myx.distro-system` idiom, not cross-package calls — `myx.common` depends on no `myx.distro-*` code or conventions, nor the reverse.
- Stale-entry removal runs before the locate pass, because each splice shifts every byte offset after it. One splice per pass, re-locating each time; an unparsable config is left alone and reported by the canonical write.

## `bin/remove/agentMcp.Common`

- Removes the entry `myx.common setup/agentMcp` registered, from `~/.claude.json` local-scope `projects["<cwd>"].mcpServers."myx.common"`. Idempotent: a no-op success when the entry is not present for this cwd. Same byte-range splice, backup and validate approach as `setup/agentMcp` — see that file for the scope rationale.
- **Known cwd exposure, deliberately deferred.** A caller whose own process cwd is not the workspace in question — dispatch through an MCP tool, for instance — removes the wrong entry, or none, silently. Unfixed here because this command has only the tier-3 home-scope removal, with no workspace-local tier to correct, and no live bug against it. This is the same class of exposure `setup/agentMcp.Common` carried before its `MYX_AGENTMCP_TARGET_CWD` fix.
- cwd reaches awk through the environment, never `-v cwd=...`: awk's `-v` decoding mangles a path containing `"` or `\`. See `agentMcpConfigEdit.awk`'s own header.
- The `.bak` is transient, the same convention `lib/replaceLine` uses — it exists only for the duration of the write, is removed on success, and is left behind as a recovery copy only if something fails mid-write. Writing directly into the config rather than a mktemp-and-swap also means its mode and ownership are never touched.
