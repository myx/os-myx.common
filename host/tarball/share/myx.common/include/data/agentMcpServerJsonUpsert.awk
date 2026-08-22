#!/usr/bin/env awk

# Upserts one MCP server entry into a JSON config, by entry key, and drops every
# sibling entry whose "command" carries MYX_MCPUPSERT_DROPPATHPART as a path
# component. Prints the new document on stdout; never opens the target, so the
# caller owns the write. Params via ENVIRON:
# MYX_MCPUPSERT_{TOPKEY,ENTRYKEY,COMMAND,ARGS,DROPPATHPART}; caller sets LC_ALL=C.

function skipws(   c) {
	while (p <= n) {
		c = substr(s, p, 1)
		if (c == " " || c == "\t" || c == "\n" || c == "\r") p++
		else return
	}
}

function skipString(   c) {
	if (substr(s, p, 1) != "\"") return 0
	p++
	while (p <= n) {
		c = substr(s, p, 1)
		if (c == "\\") { p += 2; continue; }
		p++
		if (c == "\"") return 1
	}
	return 0
}

function skipValue(   c) {
	skipws()
	c = substr(s, p, 1)
	if (c == "\"") return skipString()
	if (c == "{") return skipObject()
	if (c == "[") return skipArray()
	if (p > n) return 0
	while (p <= n) {
		c = substr(s, p, 1)
		if (c == "," || c == "}" || c == "]" || c == " " || c == "\t" || c == "\n" || c == "\r") break
		p++
	}
	return 1
}

function skipObject(   c) {
	p++
	skipws()
	if (substr(s, p, 1) == "}") { p++; return 1; }
	while (1) {
		skipws()
		if (!skipString()) return 0
		skipws()
		if (substr(s, p, 1) != ":") return 0
		p++
		if (!skipValue()) return 0
		skipws()
		c = substr(s, p, 1)
		if (c == ",") { p++; continue; }
		if (c == "}") { p++; return 1; }
		return 0
	}
}

function skipArray(   c) {
	p++
	skipws()
	if (substr(s, p, 1) == "]") { p++; return 1; }
	while (1) {
		if (!skipValue()) return 0
		skipws()
		c = substr(s, p, 1)
		if (c == ",") { p++; continue; }
		if (c == "]") { p++; return 1; }
		return 0
	}
}

# Sets FOUND, VALUE_START, VALUE_END.
function findKeyInObjectAt(objStart, targetKey,   keyStart, key, valStart) {
	p = objStart
	FOUND = 0
	p++
	skipws()
	if (substr(s, p, 1) == "}") { p++; return 1; }
	while (1) {
		skipws()
		keyStart = p
		if (!skipString()) return 0
		key = substr(s, keyStart + 1, p - keyStart - 2)
		skipws()
		if (substr(s, p, 1) != ":") return 0
		p++
		skipws()
		valStart = p
		if (!skipValue()) return 0
		if (key == targetKey) { FOUND = 1; VALUE_START = valStart; VALUE_END = p; }
		skipws()
		if (substr(s, p, 1) == ",") { p++; continue; }
		if (substr(s, p, 1) == "}") { p++; return 1; }
		return 0
	}
}

# Sets OBJ_FIRST, OBJ_EMPTY. Restores p.
function objectShapeAt(objStart,   savedP) {
	savedP = p
	p = objStart + 1
	skipws()
	OBJ_FIRST = p
	OBJ_EMPTY = (substr(s, p, 1) == "}") ? 1 : 0
	p = savedP
}

# True when the entry object at valStart launches a command from our own tree --
# dropPart as a whole path component, never a substring.
function launchesOurs(valStart,   savedP, ok, cs, ce, cmd) {
	if (dropPart == "" || substr(s, valStart, 1) != "{") return 0
	savedP = p
	ok = findKeyInObjectAt(valStart, "command")
	cs = VALUE_START
	ce = VALUE_END
	p = savedP
	if (!ok || !FOUND || substr(s, cs, 1) != "\"") return 0
	cmd = substr(s, cs + 1, ce - cs - 2)
	gsub(/\\\//, "/", cmd)
	return index("/" cmd "/", "/" dropPart "/") > 0
}

# Sets DROP_FOUND, and DROP_START/DROP_END to the byte range to cut.
function findStale(objStart,   keyStart, key, valStart, valEnd, prevComma) {
	p = objStart + 1
	DROP_FOUND = 0
	prevComma = 0
	skipws()
	if (substr(s, p, 1) == "}") return 1
	while (1) {
		skipws()
		keyStart = p
		if (!skipString()) return 0
		key = substr(s, keyStart + 1, p - keyStart - 2)
		skipws()
		if (substr(s, p, 1) != ":") return 0
		p++
		skipws()
		valStart = p
		if (!skipValue()) return 0
		valEnd = p
		skipws()
		if (key != entryKey && launchesOurs(valStart)) {
			DROP_FOUND = 1
			if (substr(s, p, 1) == ",") { DROP_START = keyStart; DROP_END = p + 1; }
			else if (prevComma) { DROP_START = prevComma; DROP_END = valEnd; }
			else { DROP_START = keyStart; DROP_END = valEnd; }
			return 1
		}
		if (substr(s, p, 1) == ",") { prevComma = p; p++; continue; }
		if (substr(s, p, 1) == "}") { p++; return 1; }
		return 0
	}
}

function jsonEscape(v) {
	gsub(/\\/, "\\\\", v)
	gsub(/"/, "\\\"", v)
	return v
}

# Parses txt on its own, restoring the document scan.
function validJson(txt, want,   savedS, savedN, savedP, ok) {
	savedS = s; savedN = n; savedP = p
	s = txt; n = length(s); p = 1
	skipws()
	ok = (substr(s, p, 1) == want) && skipValue()
	if (ok) { skipws(); ok = (p > n); }
	s = savedS; n = savedN; p = savedP
	return ok
}

function entryJson(   t) {
	t = "{\"type\": \"stdio\", \"command\": \"" jsonEscape(command) "\""
	if (argsJson != "") t = t ", \"args\": " argsJson
	return t "}"
}

function fail(reason) {
	print reason > "/dev/stderr"
	FAILED = 1
	exit 1
}

function upsert(   entry, rootStart, topStart, head, tail, sep) {
	entry = entryJson()

	if (s ~ /^[ \t\r\n]*$/) {
		RESULT = "{\n  \"" jsonEscape(topKey) "\": {\n    \"" jsonEscape(entryKey) "\": " entry "\n  }\n}\n"
		return
	}

	n = length(s)
	p = 1
	skipws()
	if (substr(s, p, 1) != "{") fail("not-a-json-object")
	rootStart = p

	if (!findKeyInObjectAt(rootStart, topKey)) fail("unparsable")
	if (!FOUND) {
		objectShapeAt(rootStart)
		sep = OBJ_EMPTY ? "" : ", "
		head = substr(s, 1, OBJ_FIRST - 1)
		tail = substr(s, OBJ_FIRST)
		RESULT = head "\"" jsonEscape(topKey) "\": {\"" jsonEscape(entryKey) "\": " entry "}" sep tail
		return
	}

	topStart = VALUE_START
	if (substr(s, topStart, 1) != "{") fail(topKey "-not-an-object")

	if (!findKeyInObjectAt(topStart, entryKey)) fail("unparsable")
	if (!FOUND) {
		objectShapeAt(topStart)
		sep = OBJ_EMPTY ? "" : ", "
		head = substr(s, 1, OBJ_FIRST - 1)
		tail = substr(s, OBJ_FIRST)
		RESULT = head "\"" jsonEscape(entryKey) "\": " entry sep tail
		return
	}

	head = substr(s, 1, VALUE_START - 1)
	tail = substr(s, VALUE_END)
	RESULT = head entry tail
}

# One splice per pass; offsets shift, so each pass re-locates from scratch.
function dropPass(   rootStart, topStart) {
	if (dropPart == "") return 0
	s = RESULT
	n = length(s)
	p = 1
	skipws()
	if (substr(s, p, 1) != "{") fail("not-a-json-object")
	rootStart = p
	if (!findKeyInObjectAt(rootStart, topKey)) fail("unparsable")
	if (!FOUND) return 0
	topStart = VALUE_START
	if (substr(s, topStart, 1) != "{") return 0
	if (!findStale(topStart)) fail("unparsable")
	if (!DROP_FOUND) return 0
	RESULT = substr(s, 1, DROP_START - 1) substr(s, DROP_END)
	return 1
}

BEGIN {
	topKey = ENVIRON["MYX_MCPUPSERT_TOPKEY"]
	entryKey = ENVIRON["MYX_MCPUPSERT_ENTRYKEY"]
	command = ENVIRON["MYX_MCPUPSERT_COMMAND"]
	argsJson = ENVIRON["MYX_MCPUPSERT_ARGS"]
	dropPart = ENVIRON["MYX_MCPUPSERT_DROPPATHPART"]
	if (topKey == "" || entryKey == "" || command == "") fail("usage")
	if (argsJson != "" && !validJson(argsJson, "[")) fail("args-not-a-json-array")
}

{ doc = doc $0 "\n"; }

END {
	if (FAILED) exit 1
	s = doc
	upsert()
	passes = 0
	while (passes < 64 && dropPass()) passes++
	if (!validJson(RESULT, "{")) fail("generated-config-would-not-parse")
	printf "%s", RESULT
}
