#!/usr/bin/env python3

# Upserts the "myx" stdio MCP server entry into a JSON config file, for
# setup/agentMcp.Common's workspace-detect tier (writes .vscode/mcp.json's
# top-level "servers" key when a real myx workspace is detected at the
# launch cwd - see that file's own header comment for the full priority
# chain).
#
# Deliberately a separate copy of myx.distro-system's own
# sh-lib/AgentMcpServerJsonUpsert.py, not a cross-package call into it:
# os-myx.common/CLAUDE.md states plainly that myx.common is "not
# architecturally related to myx.distro-*... the command tool itself has
# no dependency on distro-* code or conventions" - nor the reverse. Same
# precedent already established for agentMcpJsonParseRequest.awk /
# agentSlackMessagesFormat.awk sharing one JSON-parsing engine copied
# verbatim across this exact same package boundary (see that CLAUDE.md
# section) - copy the idiom, don't reach across packages for it.
#
# argv[1]: path to the JSON config file to upsert into (created if it
#   doesn't exist yet). argv[2]: path to the MCP server script to register
#   as the "myx" entry's stdio command. argv[3]: top-level object key the
#   server entry lives under (e.g. "servers" for VS Code's own
#   .vscode/mcp.json schema). argv[4] (optional): a JSON array of extra
#   launch args (e.g. ["--run"]) to add as the entry's own "args" field -
#   omitted entirely when argv[4] isn't given, same entry shape as before
#   this field existed.
#
# Non-destructive to unrelated entries: only the "myx" key under the given
# top-level key is set/overwritten - every other existing server entry,
# and the rest of the file's top-level object, is preserved as-is. Writes
# via a temp file + atomic os.replace (original file is never touched
# until the new content is fully written and valid), same safety shape as
# the myx.distro-system original this was copied from. Prints "OK" to
# stdout on success.

import json
import os
import sys

path = sys.argv[1]
server_script = sys.argv[2]
key = sys.argv[3]
args_json = sys.argv[4] if len(sys.argv) > 4 else None

data = {}
if os.path.exists(path):
	with open(path, "r", encoding="utf-8") as f:
		raw = f.read().strip()
	if raw:
		try:
			data = json.loads(raw)
		except json.JSONDecodeError as e:
			raise SystemExit("%s does not parse as JSON: %s" % (path, e))

if not isinstance(data, dict):
	raise SystemExit("%s top-level must be an object" % path)

servers = data.get(key)
if servers is None:
	servers = {}
if not isinstance(servers, dict):
	raise SystemExit("%s '%s' must be an object" % (path, key))

entry = {
	"type": "stdio",
	"command": server_script,
}
if args_json is not None:
	try:
		args = json.loads(args_json)
	except json.JSONDecodeError as e:
		raise SystemExit("argv[4] does not parse as JSON: %s" % e)
	if not isinstance(args, list):
		raise SystemExit("argv[4] must be a JSON array of args")
	entry["args"] = args

servers["myx"] = entry
data[key] = servers

tmp = path + ".tmp"
with open(tmp, "w", encoding="utf-8") as f:
	json.dump(data, f, indent=2, ensure_ascii=True)
	f.write("\n")
os.replace(tmp, path)
print("OK")
