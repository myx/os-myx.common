#!/usr/bin/env awk

# Adds MYX_MCPTRUST_FOLDER to the copilot CLI settings document's
# "trustedFolders" array. Prints the document on stdout -- byte-identical when
# the folder is already listed and the input ends with a newline; an input
# without one gains it, since awk cannot see that difference. Never opens the
# target, so the caller owns the write. Caller sets LC_ALL=C.

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

function hex2dec(h,   i, c, v, r) {
	r = 0
	for (i = 1; i <= length(h); i++) {
		c = tolower(substr(h, i, 1))
		v = index("0123456789abcdef", c) - 1
		r = r * 16 + v
	}
	return r
}

function utf8enc(cp,   c1, c2, c3, c4) {
	if (cp < 128) {
		return sprintf("%c", cp)
	} else if (cp < 2048) {
		c1 = 192 + int(cp / 64)
		c2 = 128 + (cp % 64)
		return sprintf("%c%c", c1, c2)
	} else if (cp < 65536) {
		c1 = 224 + int(cp / 4096)
		c2 = 128 + int(cp / 64) % 64
		c3 = 128 + (cp % 64)
		return sprintf("%c%c%c", c1, c2, c3)
	} else {
		c1 = 240 + int(cp / 262144)
		c2 = 128 + int(cp / 4096) % 64
		c3 = 128 + int(cp / 64) % 64
		c4 = 128 + (cp % 64)
		return sprintf("%c%c%c%c", c1, c2, c3, c4)
	}
}

# Decodes the string starting at p, leaving p just past its closing quote.
function parseString(   c, out, hex, code, hex2, code2, cp) {
	p++
	out = ""
	while (p <= n) {
		c = substr(s, p, 1)
		if (c == "\"") { p++; break; }
		if (c == "\\") {
			p++
			c = substr(s, p, 1)
			if (c == "\"") out = out "\""
			else if (c == "\\") out = out "\\"
			else if (c == "/") out = out "/"
			else if (c == "b") out = out "\b"
			else if (c == "f") out = out "\f"
			else if (c == "n") out = out "\n"
			else if (c == "r") out = out "\r"
			else if (c == "t") out = out "\t"
			else if (c == "u") {
				hex = substr(s, p + 1, 4)
				code = hex2dec(hex)
				p += 4
				if (code >= 55296 && code <= 56319 && substr(s, p + 1, 2) == "\\u") {
					hex2 = substr(s, p + 3, 4)
					code2 = hex2dec(hex2)
					if (code2 >= 56320 && code2 <= 57343) {
						cp = 65536 + (code - 55296) * 1024 + (code2 - 56320)
						out = out utf8enc(cp)
						p += 6
					} else {
						out = out utf8enc(code)
					}
				} else {
					out = out utf8enc(code)
				}
			}
			else out = out c
			p++
		} else {
			out = out c
			p++
		}
	}
	return out
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

# Sets ARR_EMPTY, ARR_CLOSE, ARR_HAS. Restores p.
function arrayScanAt(arrStart, target,   savedP, elStart, resumeP, el) {
	savedP = p
	ARR_HAS = 0
	p = arrStart + 1
	skipws()
	if (substr(s, p, 1) == "]") { ARR_EMPTY = 1; ARR_CLOSE = p; p = savedP; return 1; }
	ARR_EMPTY = 0
	while (1) {
		skipws()
		elStart = p
		if (!skipValue()) { p = savedP; return 0; }
		if (substr(s, elStart, 1) == "\"") {
			resumeP = p
			p = elStart
			el = parseString()
			p = resumeP
			if (el == target) ARR_HAS = 1
		}
		skipws()
		if (substr(s, p, 1) == ",") { p++; continue; }
		if (substr(s, p, 1) == "]") { ARR_CLOSE = p; p = savedP; return 1; }
		p = savedP
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

function fail(reason) {
	print reason > "/dev/stderr"
	FAILED = 1
	exit 1
}

function upsert(   quoted, rootStart, arrStart, head, tail, sep) {
	quoted = "\"" jsonEscape(folder) "\""

	if (s ~ /^[ \t\r\n]*$/) {
		RESULT = "{\n  \"trustedFolders\": [\n    " quoted "\n  ]\n}\n"
		return
	}

	n = length(s)
	p = 1
	skipws()
	if (substr(s, p, 1) != "{") fail("not-a-json-object")
	rootStart = p

	if (!findKeyInObjectAt(rootStart, "trustedFolders")) fail("unparsable")
	if (!FOUND) {
		objectShapeAt(rootStart)
		sep = OBJ_EMPTY ? "" : ", "
		head = substr(s, 1, OBJ_FIRST - 1)
		tail = substr(s, OBJ_FIRST)
		RESULT = head "\"trustedFolders\": [" quoted "]" sep tail
		return
	}

	arrStart = VALUE_START
	# A "trustedFolders" that is not an array is replaced outright, as the
	# Python this replaces did.
	if (substr(s, arrStart, 1) != "[") {
		RESULT = substr(s, 1, arrStart - 1) "[" quoted "]" substr(s, VALUE_END)
		return
	}

	if (!arrayScanAt(arrStart, folder)) fail("unparsable")
	if (ARR_HAS) {
		RESULT = s
		return
	}
	sep = ARR_EMPTY ? "" : ", "
	RESULT = substr(s, 1, ARR_CLOSE - 1) sep quoted substr(s, ARR_CLOSE)
}

BEGIN {
	folder = ENVIRON["MYX_MCPTRUST_FOLDER"]
	if (folder == "") fail("usage")
}

{ doc = doc $0 "\n"; }

END {
	if (FAILED) exit 1
	s = doc
	upsert()
	if (!validJson(RESULT, "{")) fail("generated-config-would-not-parse")
	printf "%s", RESULT
}