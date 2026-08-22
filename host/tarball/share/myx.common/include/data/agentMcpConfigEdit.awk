#!/usr/bin/env awk

# Locates (locate mode) or sanity-checks (validate mode) one nested key in a
# JSON config by byte offset, without ever reparsing or rewriting the file.
# MYX_AGENTMCP_CWD is an environment variable, never -v: awk's -v decodes
# backslash escapes and would undo agentMcpJsonEscape.awk's own escaping,
# breaking byte-comparison for a cwd containing '"' or '\'.
# Modes and the emitted fact names: os-myx.common/MAGIC.md.

function skipws(   c) {
	while (p <= n) {
		c = substr(s, p, 1)
		if (c == " " || c == "\t" || c == "\n" || c == "\r") p++
		else break
	}
}

function skipString(   c, ok) {
	if (substr(s, p, 1) != "\"") return 0
	p++
	while (p <= n) {
		c = substr(s, p, 1)
		if (c == "\\") { p += 2; continue }
		if (c == "\"") { p++; return 1 }
		p++
	}
	return 0
}

function skipValue(   c, ok) {
	skipws()
	c = substr(s, p, 1)
	if (c == "\"") { return skipString() }
	else if (c == "{") { return skipObject() }
	else if (c == "[") { return skipArray() }
	else if (c == "t") { if (substr(s, p, 4) != "true") return 0; p += 4; return 1 }
	else if (c == "f") { if (substr(s, p, 5) != "false") return 0; p += 5; return 1 }
	else if (c == "n") { if (substr(s, p, 4) != "null") return 0; p += 4; return 1 }
	else if (c == "-" || (c >= "0" && c <= "9")) {
		while (p <= n) {
			c = substr(s, p, 1)
			if (c == "-" || c == "+" || c == "." || c == "e" || c == "E" || (c >= "0" && c <= "9")) p++
			else break
		}
		return 1
	}
	return 0
}

function skipObject(   c, ok) {
	p++ # {
	skipws()
	if (substr(s, p, 1) == "}") { p++; return 1 }
	while (1) {
		skipws()
		if (!skipString()) return 0
		skipws()
		if (substr(s, p, 1) != ":") return 0
		p++
		if (!skipValue()) return 0
		skipws()
		c = substr(s, p, 1)
		if (c == ",") { p++; continue }
		else if (c == "}") { p++; return 1 }
		else return 0
	}
}

function skipArray(   c, ok) {
	p++ # [
	skipws()
	if (substr(s, p, 1) == "]") { p++; return 1 }
	while (1) {
		if (!skipValue()) return 0
		skipws()
		c = substr(s, p, 1)
		if (c == ",") { p++; continue }
		else if (c == "]") { p++; return 1 }
		else return 0
	}
}

# Walks one object's direct pairs for targetKey; sets FOUND plus the splice offsets MAGIC.md lists.
function findKeyInObjectAt(objStart, targetKey,   keyStart, key, valStart, c, lastCommaPos) {
	p = objStart
	FOUND = 0
	PRECEDING_COMMA_POS = 0
	p++ # {
	skipws()
	FIRST_KEY_START = p
	if (substr(s, p, 1) == "}") { IS_EMPTY = 1; p++; OBJ_CLOSE = p; return 1 }
	IS_EMPTY = 0
	lastCommaPos = 0
	while (1) {
		skipws()
		keyStart = p
		if (substr(s, p, 1) != "\"") return 0
		key = substr(s, p + 1)
		if (!skipString()) return 0
		key = substr(s, keyStart + 1, p - keyStart - 2)
		skipws()
		if (substr(s, p, 1) != ":") return 0
		p++
		skipws()
		valStart = p
		if (!skipValue()) return 0
		if (key == targetKey) {
			FOUND = 1
			KEY_START = keyStart
			VALUE_START = valStart
			VALUE_END = p
			PAIR_END_NO_COMMA = p
			PRECEDING_COMMA_POS = lastCommaPos
		}
		skipws()
		c = substr(s, p, 1)
		if (c == ",") {
			if (FOUND && KEY_START == keyStart) {
				HAD_TRAILING_COMMA = 1
				PAIR_END_WITH_COMMA = p + 1
			}
			lastCommaPos = p
			p++
			continue
		} else if (c == "}") {
			if (FOUND && KEY_START == keyStart) {
				HAD_TRAILING_COMMA = 0
				PAIR_END_WITH_COMMA = p
			}
			p++
			OBJ_CLOSE = p
			return 1
		} else {
			return 0
		}
	}
}

# Saves and restores p, so the caller's own in-progress walk is unaffected.
function commandTokenAt(objStart,   savedP, ret) {
	savedP = p
	ret = ""
	if (substr(s, objStart, 1) == "{" && findKeyInObjectAt(objStart, "command") && FOUND)
		ret = substr(s, VALUE_START, VALUE_END - VALUE_START)
	p = savedP
	return ret
}

# True only when "myx.common" is a whole path component of the command, never a substring.
function isOurCommand(tok,   v) {
	if (tok == "" || substr(tok, 1, 1) != "\"") return 0
	v = substr(tok, 2, length(tok) - 2)
	gsub(/\\\//, "/", v)
	return v ~ /(^|\/)myx\.common(\/|$)/
}

# Finds the first pair other than "myx.common" whose command comes from this tree - a duplicate registration.
function findStaleEntryInObjectAt(objStart,   keyStart, key, valStart, c, lastCommaPos) {
	p = objStart
	STALE_FOUND = 0
	p++ # {
	skipws()
	if (substr(s, p, 1) == "}") { return 1 }
	lastCommaPos = 0
	while (1) {
		skipws()
		keyStart = p
		if (substr(s, p, 1) != "\"") return 0
		if (!skipString()) return 0
		key = substr(s, keyStart + 1, p - keyStart - 2)
		skipws()
		if (substr(s, p, 1) != ":") return 0
		p++
		skipws()
		valStart = p
		if (!skipValue()) return 0
		if (!STALE_FOUND && key != "myx.common" && isOurCommand(commandTokenAt(valStart))) {
			STALE_FOUND = 1
			STALE_KEY_START = keyStart
			STALE_PAIR_END_NO_COMMA = p
			STALE_PRECEDING_COMMA_POS = lastCommaPos
		}
		skipws()
		c = substr(s, p, 1)
		if (c == ",") {
			if (STALE_FOUND && STALE_KEY_START == keyStart) {
				STALE_HAD_TRAILING_COMMA = 1
				STALE_PAIR_END_WITH_COMMA = p + 1
			}
			lastCommaPos = p
			p++
			continue
		} else if (c == "}") {
			if (STALE_FOUND && STALE_KEY_START == keyStart) {
				STALE_HAD_TRAILING_COMMA = 0
				STALE_PAIR_END_WITH_COMMA = p
			}
			p++
			return 1
		} else {
			return 0
		}
	}
}

BEGIN {
	if (mode == "") mode = "locate"
	cwd = ENVIRON["MYX_AGENTMCP_CWD"]
}

# Rejoin the records under the default RS: a NUL RS is the empty string, which
# selects paragraph mode and would split the document on any blank line.
{ doc = (NR == 1) ? $0 : doc "\n" $0; }

END {
	s = doc
	n = length(s)
	p = 1

	if (mode == "validate") {
		skipws()
		if (!skipValue()) { print "INVALID could-not-parse-root-value"; exit; }
		skipws()
		if (p <= n) { print "INVALID trailing-data-after-root-value"; exit; }
		print "VALID"
		exit
	}

	if (cwd == "") { print "NOCWD"; exit; }

	skipws()
	if (substr(s, p, 1) != "{") { print "NOTJSON"; exit; }
	rootOpen = p

	if (!findKeyInObjectAt(rootOpen, "projects")) { print "PARSE_ERROR"; exit; }
	if (!FOUND) {
		print "PROJECTS_FOUND=0"
		print "ROOT_FIRST_KEY_START=" FIRST_KEY_START
		print "ROOT_IS_EMPTY=" IS_EMPTY
		exit
	}
	print "PROJECTS_FOUND=1"
	projectsValueStart = VALUE_START
	if (substr(s, projectsValueStart, 1) != "{") { print "PROJECTS_NOT_OBJECT=1"; exit; }

	if (!findKeyInObjectAt(projectsValueStart, cwd)) { print "PARSE_ERROR"; exit; }
	if (!FOUND) {
		print "PROJECT_FOUND=0"
		print "PROJECTS_FIRST_KEY_START=" FIRST_KEY_START
		print "PROJECTS_IS_EMPTY=" IS_EMPTY
		exit
	}
	print "PROJECT_FOUND=1"
	projectValueStart = VALUE_START
	if (substr(s, projectValueStart, 1) != "{") { print "PROJECT_NOT_OBJECT=1"; exit; }

	if (!findKeyInObjectAt(projectValueStart, "mcpServers")) { print "PARSE_ERROR"; exit; }
	if (!FOUND) {
		print "MCPSERVERS_FOUND=0"
		print "PROJECT_FIRST_KEY_START=" FIRST_KEY_START
		print "PROJECT_IS_EMPTY=" IS_EMPTY
		exit
	}
	print "MCPSERVERS_FOUND=1"
	mcpServersValueStart = VALUE_START
	if (substr(s, mcpServersValueStart, 1) != "{") { print "MCPSERVERS_NOT_OBJECT=1"; exit; }

	if (!findKeyInObjectAt(mcpServersValueStart, "myx.common")) { print "PARSE_ERROR"; exit; }
	if (FOUND) {
		print "ENTRY_FOUND=1"
		print "ENTRY_KEY_START=" KEY_START
		print "ENTRY_VALUE_START=" VALUE_START
		print "ENTRY_VALUE_END=" VALUE_END
		print "ENTRY_PAIR_END_NO_COMMA=" PAIR_END_NO_COMMA
		print "ENTRY_PAIR_END_WITH_COMMA=" PAIR_END_WITH_COMMA
		print "ENTRY_HAD_TRAILING_COMMA=" HAD_TRAILING_COMMA
		print "ENTRY_PRECEDING_COMMA_POS=" PRECEDING_COMMA_POS
	} else {
		print "ENTRY_FOUND=0"
		print "MCPSERVERS_FIRST_KEY_START=" FIRST_KEY_START
		print "MCPSERVERS_IS_EMPTY=" IS_EMPTY
	}

	# Duplicate registration under some other key, spliced out by setup/agentMcp.
	if (!findStaleEntryInObjectAt(mcpServersValueStart)) { print "PARSE_ERROR"; exit; }
	print "STALE_FOUND=" STALE_FOUND
	if (STALE_FOUND) {
		print "STALE_KEY_START=" STALE_KEY_START
		print "STALE_PAIR_END_NO_COMMA=" STALE_PAIR_END_NO_COMMA
		print "STALE_PAIR_END_WITH_COMMA=" STALE_PAIR_END_WITH_COMMA
		print "STALE_HAD_TRAILING_COMMA=" STALE_HAD_TRAILING_COMMA
		print "STALE_PRECEDING_COMMA_POS=" STALE_PRECEDING_COMMA_POS
	}
}