#!/usr/bin/env awk

# Locates (or, in validate mode, sanity-checks) a specific nested key inside
# a JSON config file, WITHOUT a general parse/rewrite of the whole
# structure - used by setup/agentMcp and remove/agentMcp to surgically
# splice the top-level "mcpServers"."myx.common" entry in ~/.claude.json via
# byte offsets (head -c / tail -c), leaving every other byte untouched.
#
# Input: whole file content as one record (caller sets RS to slurp-all).
# Modes (-v mode=...):
#   locate (default) - prints KEY=VALUE facts (1-based byte offsets) about
#     the "mcpServers" key and, within it, the "myx.common" key.
#   validate - prints "VALID" if the input parses as one well-formed JSON
#     value with nothing left over, else "INVALID <reason>". Used as a
#     self-contained (no jq/python needed) sanity check after splicing.

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

# Walks the direct key/value pairs of the object whose "{" is at objStart,
# looking for targetKey. Sets FOUND plus (if found) KEY_START, VALUE_START,
# VALUE_END, PAIR_END_NO_COMMA, PAIR_END_WITH_COMMA, HAD_TRAILING_COMMA,
# PRECEDING_COMMA_POS (0 if none). Always sets FIRST_KEY_START (insertion
# point for a brand new first key) and IS_EMPTY, and OBJ_CLOSE (position
# right after the object's closing "}"). Returns 1 on a structurally valid
# walk, 0 if the object didn't parse cleanly.
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

BEGIN {
	if (mode == "") mode = "locate"
}

{
	s = $0
	n = length(s)
	p = 1

	if (mode == "validate") {
		skipws()
		if (!skipValue()) { print "INVALID could-not-parse-root-value"; exit }
		skipws()
		if (p <= n) { print "INVALID trailing-data-after-root-value"; exit }
		print "VALID"
		exit
	}

	skipws()
	if (substr(s, p, 1) != "{") { print "NOTJSON"; exit }
	rootOpen = p

	if (!findKeyInObjectAt(rootOpen, "mcpServers")) { print "PARSE_ERROR"; exit }

	if (FOUND) {
		print "MCPSERVERS_FOUND=1"
		print "MCPSERVERS_VALUE_START=" VALUE_START
		print "MCPSERVERS_VALUE_END=" VALUE_END
		mcpServersValueStart = VALUE_START
		if (substr(s, mcpServersValueStart, 1) != "{") { print "MCPSERVERS_NOT_OBJECT=1"; exit }
		if (!findKeyInObjectAt(mcpServersValueStart, "myx.common")) { print "PARSE_ERROR"; exit }
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
	} else {
		print "MCPSERVERS_FOUND=0"
		print "ROOT_FIRST_KEY_START=" FIRST_KEY_START
		print "ROOT_IS_EMPTY=" IS_EMPTY
	}
}
