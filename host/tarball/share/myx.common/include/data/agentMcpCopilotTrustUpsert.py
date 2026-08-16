#!/usr/bin/env python3

# Upserts a cwd into the copilot CLI's own local-MCP trust gate
# (~/.copilot/settings.json's "trustedFolders" array), for
# setup/agentMcp.Common's SetupAgentMcpCopilotTrust - see that function's
# own header comment for why this exists (`copilot -p`, headless, silently
# skips starting any local/stdio MCP server unless cwd is already listed
# there).
#
# argv[1]: path to ~/.copilot/settings.json (created as "{}" by the caller
#   if missing). argv[2]: the cwd to add to "trustedFolders".
#
# Non-destructive to unrelated keys: only "trustedFolders" is read/written,
# the rest of the top-level object is preserved as-is. A no-op (still
# prints "OK") when cwd is already present. Writes via a temp file + atomic
# os.replace, same safety shape as agentMcpServerJsonUpsert.py.

import json
import os
import sys

path = sys.argv[1]
cwd = sys.argv[2]

with open(path, "r", encoding="utf-8") as f:
	raw = f.read().strip()
try:
	data = json.loads(raw) if raw else {}
except json.JSONDecodeError as e:
	raise SystemExit("%s does not parse as JSON: %s" % (path, e))

if not isinstance(data, dict):
	raise SystemExit("%s top-level must be an object" % path)

folders = data.get("trustedFolders")
if not isinstance(folders, list):
	folders = []

if cwd not in folders:
	folders.append(cwd)
	data["trustedFolders"] = folders
	tmp = path + ".tmp"
	with open(tmp, "w", encoding="utf-8") as f:
		json.dump(data, f, indent=2, ensure_ascii=True)
		f.write("\n")
	os.replace(tmp, path)

print("OK")
