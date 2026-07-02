# os-myx.common

Install:

`curl -L https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh | sh -e`

or

`fetch https://raw.githubusercontent.com/myx/os-myx.common/master/sh-scripts/install-myx.common.sh -o - | sh -e`


(Depends on whether you have `curl`)

## Available commands

OS-independent (all platforms):
- `myx.common os/getCpuCount` — print logical CPU count
- `myx.common os/getRamBytes` — print total RAM in bytes
- `myx.common os/getCommonScreenRc` — print path to system screenrc
- `myx.common os/getWheelGroupNames` — print space-separated sudo/wheel group names
- `myx.common os/getWheelGroupName` — print primary wheel group name
- `myx.common os/getUserHome [--user username]` — print home directory base or user home
- `myx.common os/getRootHome` — print root home directory
- `myx.common os/getUtilityPackage [--no-default] utility_name` — resolve package name for a utility
- `myx.common os/needsReboot [--silent|--print|--reboot|--no-reboot]` — check if reboot is needed (exits 0 if yes)
- `myx.common os/reclaimSpace` — remove caches, stale packages, old logs (requires root)

Linux-only:
- `myx.common os/growSlashFs [--execute]` — grow root filesystem to fill available disk/partition space

FreeBSD-only:
- `myx.common os/growSlashFsUfs [--execute] [diskName sliceName [ufsIdx [swapIdx]]]` — grow root UFS filesystem
- `myx.common os/installPostfixMTA [--relay-host h] [--relay-credentials c] [--force-tls]` — install and configure Postfix MTA
