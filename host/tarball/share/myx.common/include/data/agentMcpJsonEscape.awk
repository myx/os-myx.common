#!/usr/bin/env awk

# stdin -> JSON string content on stdout, without the surrounding quotes; embedded
# newlines become literal \n. Run under LC_ALL=C by the caller, so raw UTF-8 passes through byte for byte.

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
