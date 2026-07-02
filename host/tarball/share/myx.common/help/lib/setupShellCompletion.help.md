# SetupShellCompletion ( myx.common lib/setupShellCompletion )

Register shell completion command.

Supported OS: Linux, FreeBSD, Darwin.

Install, update, or remove shell completion hooks for a utility command.

Centralizes completion setup logic for bash/csh/zsh rc files so scripts can
provision completion in one call.

Arguments:

  <utility-name>

      Command name that should receive completion.

Options:

  --command <list-command>

      Use command output as completion candidates.

  --directory <list-directory>

      Use directory entries as completion candidates.

  --remove

      Remove completion entries created by this helper.

Examples:

  myx.common lib/setupShellCompletion myx.common --command "myx.common help --bare"
  myx.common lib/setupShellCompletion my-tool --directory ./commands
  myx.common lib/setupShellCompletion myx.common --remove
