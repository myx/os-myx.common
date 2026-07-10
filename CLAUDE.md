# os-myx.common — AI assistant context

Self-contained cross-platform (Linux/FreeBSD/Darwin) devops CLI. Not
architecturally related to myx.distro-*: its `project.inf` `Provides:`
entries (`deploy-export:...`, `image-install:exec-update-before:...`) only
register it as an installable package in the distro-* index/pipeline — the
command tool itself has no dependency on distro-* code or conventions.
Don't carry over distro-* conventions here or vice versa.

Canonical human doc: `README.md` (command index, per-command
Platforms/Root/Syntax, and "Adding or Changing a Command" for suffix/dispatch
mechanics). No generator produces it — it's hand-maintained; keep it in sync
by hand when adding/changing commands.

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

Convention (1) is only safe for functions with no real per-OS behavior. For
a function that *does* need OS dispatch but is still called via convention
(1), the `.Common` file itself must manually replicate the OS-selection
logic. Confirmed real example: `install/ensure/nativePackage.Common` — this
command has genuinely different Darwin/FreeBSD/Linux implementations
(~30-39 lines each), yet `lib/installEnsurePackage.Common` sources it via
convention (1) (`type InstallEnsureNativePackage ... || .
.../nativePackage.Common`). So `nativePackage.Common` itself checks for
`nativePackage.$MYXUNIX` and manually sources+delegates to it, erroring
("abstract method") if no OS override exists. If you add a new command with
real per-OS variants, check whether anything sources it via convention (1)
— if so, its `.Common` file needs this same manual self-redirect, or the
caller needs to switch to convention (2).

myx.distro-* uses the same `type X >/dev/null 2>&1 || . file` idiom, but
resolves the path via `myx.common which lib/X` (one subprocess, but
OS-aware) rather than hardcoding `.Common` — a stricter version of the same
pattern. See `myx.distro-*` CLAUDE.md's Dispatchers section.
