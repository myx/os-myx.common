# Extension

[Back to the README](../README.md)

## Add a command

A command lives at `bin/<category>/<name>.<Variant>`. The variant is `Common` for every platform, or the output of `uname -s` for one platform.

- Give each command a help pair at the matching path under `help/`: `<name>.help.include` and `<name>.help.md`. One pair serves every variant. A command without both files is incomplete.
- Make the file executable. A file without its execute bit is skipped silently.
- Check a help claim by running the command, not by reading its source.

Files under `include/` are internal. They are not commands, and they need no help pair.

## Reach another command

Two calling conventions exist, and they differ.

- Source the file directly: `type <FunctionName> >/dev/null 2>&1 || . "${MYXROOT:-...}/bin/<category>/<name>.Common"`. It spawns no process. It always uses the `Common` variant. Use it only for a function with no per-OS behaviour.
- Call it through the dispatcher: `myx.common <category>/<name> [args]`. It costs a process and picks the right variant for the operating system.

A function that has per-OS variants but is reached by direct sourcing must select the variant itself. `install/ensure/nativePackage` is the example. Its `Common` file delegates to the platform file, and it fails with `abstract method` when the running OS has none.
