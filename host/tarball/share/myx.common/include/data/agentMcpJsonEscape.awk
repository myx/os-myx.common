#!/usr/bin/env awk

# stdin (one or more lines of raw text) -> JSON string content on stdout,
# WITHOUT surrounding quotes. Embedded newlines become literal \n so the
# result is safe to place on a single JSON-RPC line. Byte-safe (run under
# LC_ALL=C by the caller) so raw UTF-8 passes through untouched.

BEGIN {
	for (i = 1; i <= 31; i++) esc[sprintf("%c", i)] = sprintf("\\u%04x", i)
}
{
	if (NR > 1) printf "\\n"
	line = $0
	out = ""
	ln = length(line)
	for (i = 1; i <= ln; i++) {
		c = substr(line, i, 1)
		if (c == "\\") out = out "\\\\"
		else if (c == "\"") out = out "\\\""
		else if (c in esc) out = out esc[c]
		else out = out c
	}
	printf "%s", out
}
