# os-myx.common — AI assistant context

Self-contained cross-platform (Linux/FreeBSD/Darwin) devops CLI. Not
architecturally related to myx.distro-*: its `project.inf` `Provides:`
entries (`deploy-export:...`, `image-install:exec-update-before:...`) only
register it as an installable package in the distro-* index/pipeline — the
command tool itself has no dependency on distro-* code or conventions.
distro-* conventions don't carry over here, nor the reverse.

Canonical human doc: `README.md` (command index, per-command
Platforms/Root/Syntax, and "Adding or Changing a Command" for suffix/dispatch
mechanics). No generator produces it — hand-maintained, synced by hand when
commands change.

## Sibling repos are install-only placeholders

`os-myx.common-macosx`/`-ubuntu`/`-freebsd` each contain only `LICENSE` +
`project.inf` + `README.md` + one `install-myx.common-<os>.sh` script. All
command logic lives in `os-myx.common` itself, which already supports every
OS via the `.Common`/`.<Platform>` suffix mechanism (see README). The
sibling repos don't add commands — they just give each OS its own install
entry point/URL.

## Two calling conventions — easy to mix up

1. **Direct source (fast path), pervasive**: `type <FunctionName>
   >/dev/null 2>&1 || . "${MYXROOT:-...}/bin/<category>/<name>.Common"`.
   Guards against re-sourcing if already defined in this shell, and hardcodes
   `.Common` — **no subprocess, no OS-dispatch lookup**. Used dozens of
   times (`UserRequireRoot`, `ReplaceLine`, `Prefix`, `OsGetUserHome`, etc.)
   for functions assumed OS-invariant.
2. **Full dispatch (subprocess)**: `myx.common <category>/<name> [args]`,
   goes through `bin/myx.common`'s real OS-override resolution
   (`.$(uname -s)` → `.Common` → legacy). Costs a subprocess spawn but is
   OS-aware.

Convention (1) is only safe for functions with no real per-OS behavior. A
function that *does* need OS dispatch but is still called via convention
(1) must have its `.Common` file manually replicate the OS-selection logic
— e.g. `install/ensure/nativePackage.Common`: genuinely different
Darwin/FreeBSD/Linux implementations (~30-39 lines each), sourced via
convention (1) by `lib/installEnsurePackage.Common` (`type
InstallEnsureNativePackage ... || . .../nativePackage.Common`), so
`nativePackage.Common` itself checks for `nativePackage.$MYXUNIX` and
manually sources+delegates to it, erroring ("abstract method") if no OS
override exists. Any new command with real per-OS variants sourced via
convention (1) needs this same manual self-redirect, or a switch to
convention (2).

myx.distro-* uses the same `type X >/dev/null 2>&1 || . file` idiom, but
resolves the path via `myx.common which lib/X` (one subprocess, but
OS-aware) rather than hardcoding `.Common` — a stricter version of the same
pattern. See `myx.distro-*` CLAUDE.md's Dispatchers section.

## `bin/` (public command) vs `include/` (internal resource/stub)

Not every shell script under `share/myx.common/` is a dispatchable command.
`include/data/` also holds standalone scripts that need a stable absolute
path for some *external* system to invoke directly, but are not themselves
a public/completable myx.common command — e.g. `include/data/agentMcpServer.sh`,
an MCP (Model Context Protocol) stdio server for AI agent hosts, registered
by `setup/agentMcp` at its own direct path rather than via
`myx.common lib/agentMcpServer`. It deliberately has no help pair, no
README entry, and doesn't appear in `myx.common help --bare` — a curious
human finding it and running it directly just gets a hanging JSON-RPC
listener, which is accepted as fine since it's integration plumbing, not
API surface. "Needs a stable dispatcher-independent path" and "is a public
command" are separate, independently-decidable properties — a fixed-path
requirement doesn't imply `bin/`.

## `include/data/*.awk` — reusable JSON-parsing engine, copy don't reinvent

`agentMcpJsonParseRequest.awk` (MCP JSON-RPC message fields) and `agentSlackMessagesFormat.awk`
(added 2026-07-21, Slack `conversations.history`/`conversations.replies` message fields — consumed by
`myx.distro-system`'s `DistroAgentsTools.fn.sh --sweep-read-incoming-comms`, see that repo's own
CLAUDE.md) share the exact same recursive-descent JSON parsing engine (`skipws`/`hex2dec`/`utf8enc`/
`parseString`/`parseValue`/`parseObject`/`parseArray`) byte-for-byte — only each file's own `emitLeaf`
function differs, tailored to the specific flat/one-level-nested field shape that caller actually needs.
Neither is a general-purpose JSON parser (both say so in their own header comments) — they understand
exactly the shapes their one real caller produces. Convention for a third consumer pulling specific fields
out of a small, predictable JSON shape from awk (no `jq`/`python3` dependency): copy the parsing engine
verbatim from one of these two files, write a new `emitLeaf` — no hand-rolled fresh parser, no
`jq`/`python3 -c` substitute, since this engine already does the job with zero external dependencies.
Exists because `agentMcpServer.sh` and `DistroAgentsTools.fn.sh` both need to run in environments where a
JSON dependency can't be assumed present.

## `bin/mail/*` — credential handling and curl gotchas

New "mail" category (`bin/mail/send.Common`, `bin/mail/receive.Common`, added
2026-07-16) sends/lists email over authenticated SMTPS/IMAPS via curl — no
Gmail-specific logic beyond its defaults, `MAIL_SMTP_HOST`/`MAIL_IMAP_HOST`
etc. work against any implicit-TLS server. Both commands share the same
credential resolution: `MAIL_APP_PASSWORD` env var first, else `myx.common
lib/readKeychainSecret` (`MAIL_ACCOUNT`/`MAIL_KEYCHAIN_SERVICE`, defaulting to
the magic-team mailbox — see README for the full option list).

`lib/readKeychainSecret.Darwin` has no `.Common` fallback on purpose — it's
Darwin-only by design, same shape as `install/brew.Darwin` or
`reset/dnsCache.Darwin`, not a gap to fill in.

Two curl gotchas:
- Credential passed to curl only via `curl -K -` (config directives on
  stdin) — never argv, never a file. `curl --verbose` auth-debugging output,
  if captured to a file, is only safe to inspect on `<`-prefixed (server)
  lines; `>`-prefixed (client) lines carry the base64 `AUTH PLAIN` exchange
  and aren't safe to eyeball or grep-filter — the password already leaked
  into chat once this way.
- `receive.Common` fetches one message at a time via curl's native
  `imaps://host/INBOX;MAILINDEX=<n>;SECTION=...` URL form. A custom
  multi-message `FETCH range (...)` request was tried first and abandoned —
  curl only prints the `* N FETCH (...) {size}` summary tag lines for that
  form and silently drops the actual payload.
