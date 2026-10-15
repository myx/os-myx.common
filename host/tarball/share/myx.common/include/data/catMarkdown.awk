#!/usr/bin/env awk

BEGIN {

  ansi = 0
  spans = 0; width = 0; nowrap = 0; ascii = 0
  for (i = 1; i < ARGC; i++) {
    if (ARGV[i] == "--use-ansi") {
      ansi = 1
      delete ARGV[i]
    } else if (ARGV[i] == "--spans") {
      spans = 1
      delete ARGV[i]
    } else if (ARGV[i] ~ /^--width=[0-9]+$/) {
      width = substr(ARGV[i], 9) + 0
      delete ARGV[i]
    } else if (ARGV[i] == "--no-wrap") {
      nowrap = 1
      delete ARGV[i]
    } else if (ARGV[i] == "--ascii") {
      ascii = 1
      delete ARGV[i]
    }
  }
  if (spans) ansi = 0

  if (ansi) {
	esc = sprintf("%c",27)
    R      = esc "[0m"
    H1_ON  = esc "[1;95m"
    H2_ON  = esc "[1;94m"
    H3_ON  = esc "[1;92m"
    B_ON   = esc "[1m";    B_OFF   = esc "[22m"
    I_ON   = esc "[3m";    I_OFF   = esc "[23m"
    C_ON   = esc "[96m";   C_OFF   = R
    Q_ON   = esc "[90m";   Q_OFF   = R
    BUL_ON = esc "[32m";   BUL_OFF = R
    IC_ON  = C_ON;         IC_OFF  = C_OFF
  } else if (spans) {
    # --spans: marks of no width open and close the looks; each line is printed as its text,
    # a TAB, and its spans `<byte offset>+<bytes>+<look>`, comma-separated (emitSpans)
    split("h1 h2 h3 strong em code quote rule meta item head link", lookNames, " ")
    for (i = 1; i <= 12; i++) { MARK[lookNames[i]] = sprintf("%c", i < 7 ? i : i + 7); LOOK[MARK[lookNames[i]]] = lookNames[i] }
    POP = sprintf("%c", 20); RESET = sprintf("%c", 21)
    R      = RESET
    H1_ON  = MARK["h1"]; H2_ON = MARK["h2"]; H3_ON = MARK["h3"]
    B_ON   = MARK["strong"]; B_OFF = POP
    I_ON   = MARK["em"];     I_OFF = POP
    C_ON   = MARK["code"];   C_OFF = R
    Q_ON   = MARK["meta"];   Q_OFF = R
    BUL_ON = MARK["item"];   BUL_OFF = R
    IC_ON  = C_ON;           IC_OFF  = C_OFF
    for (i = 1; i < 256; i++) ORD[sprintf("%c", i)] = i
  } else {
    # no colors
    R=""; H1_ON=""; H2_ON=""; H3_ON=""
    B_ON=""; B_OFF=""; I_ON=""; I_OFF=""
    C_ON=""; C_OFF=""; Q_ON=""; Q_OFF=""
    BUL_ON=""; BUL_OFF=""
    # inline code keeps its backticks where nothing else marks it
    IC_ON="`"; IC_OFF="`"
  }
  if (!spans) for (i = 1; i < 256; i++) ORD[sprintf("%c", i)] = i
  # an awk that counts characters, not bytes, measures a text by its length (cellsOf)
  utf8chars = (length("é") == 1)

  # the marks of a table, a rule and, with --ascii, of headings and items
  UNDER1 = "━"; UNDER2 = "─"; UNDER3 = "┄"; ITEM = "➤"; RULE = "─"; COLUMN = " │ "; CROSS = "─┼─"
  if (ascii) { UNDER1 = "="; UNDER2 = "-"; UNDER3 = "-"; ITEM = "*"; RULE = "-"; COLUMN = " | "; CROSS = "-+-" }
  RULE_MOST = 72

  in_fence = 0
  cmd      = ("CMD" in ENVIRON ? ENVIRON["CMD"] : "")
}

# Inline `code`, _italic_, **bold**: code is never touched by the other two
function inline(s,    out, at, len) {
	out = ""
	while (match(s, /`[^`]+`/)) {
		at = RSTART; len = RLENGTH
		out = out emphasis(substr(s, 1, at-1)) IC_ON substr(s, at+1, len-2) IC_OFF
		s   = substr(s, at+len)
	}
	return out emphasis(s)
}

# _italic_ only at word boundaries: an _ inside a word stays; then **bold**, then *italic*,
# a letter or a digit inside each of its stars, so that a pattern (`*.md`, `note-*`) stays; with --spans a link [text](target) shows as its text, in the look
# of a link
function emphasis(s,    out, at, len) {
	while (spans && match(s, /\[[^]]+\]\([^)]+\)/)) {
		at = RSTART; len = RLENGTH
		out = substr(s, at+1, len-2)
		s = substr(s, 1, at-1) MARK["link"] substr(out, 1, index(out, "](")-1) POP substr(s, at+len)
	}
	out = ""
	while (match(s, /(^|[^A-Za-z0-9_])_[^_]+_([^A-Za-z0-9_]|$)/)) {
		at = RSTART; len = RLENGTH
		if (substr(s, at, 1) != "_") { at++; len-- }
		if (substr(s, at+len-1, 1) != "_") len--
		out = out substr(s, 1, at-1) I_ON substr(s, at+1, len-2) I_OFF
		s   = substr(s, at+len)
	}
	s = out s
	while (match(s, /\*\*[^*]+\*\*/)) {
		s = substr(s, 1, RSTART-1) B_ON substr(s, RSTART+2, RLENGTH-4) B_OFF substr(s, RSTART+RLENGTH)
	}
	out = ""
	while (match(s, /(^|[^A-Za-z0-9*])\*[A-Za-z0-9]([^*]*[A-Za-z0-9])?\*([^A-Za-z0-9*]|$)/)) {
		at = RSTART; len = RLENGTH
		if (substr(s, at, 1) != "*") { at++; len-- }
		if (substr(s, at+len-1, 1) != "*") len--
		out = out substr(s, 1, at-1) I_ON substr(s, at+1, len-2) I_OFF
		s   = substr(s, at+len)
	}
	return out s
}

# One rendered line: printed as it is, or with --spans as its text and spans, broken at
# words to --width=N, a broken line going on after `hang`
function emit(s, hang) {
	if (!spans) { print s; return }
	emitSpans(s, hang)
}

function repeat(mark, count,    out) {
	out = ""
	while (count-- > 0) out = out mark
	return out
}

# ---- cells: how many cells of a terminal a text takes ----

function seqLen(b) {
	return b < 128 ? 1 : b >= 240 ? 4 : b >= 224 ? 3 : b >= 192 ? 2 : 1
}

# the code point of the character of `len` bytes at byte k of B[key, ...]
function codeAt(B, key, k, len,    cp, i) {
	cp = ORD[B[key, k]]
	if (len == 2) cp -= 192; else if (len == 3) cp -= 224; else if (len == 4) cp -= 240
	for (i = 1; i < len; i++) cp = cp * 64 + ORD[B[key, k+i]] - 128
	return cp
}

# a joiner, a selector and a combining mark take none; a wide character and an emoji two
function cpCells(cp) {
	if (cp < 768) return 1
	if (cp == 8205 || (cp >= 65024 && cp <= 65039) || (cp >= 768 && cp <= 879) || (cp >= 8400 && cp <= 8447) \
	    || (cp >= 127995 && cp <= 127999) || (cp >= 917536 && cp <= 917631)) return 0
	if ((cp >= 4352 && cp <= 4447) || (cp >= 11904 && cp <= 42191 && cp != 12351) || (cp >= 44032 && cp <= 55203) \
	    || (cp >= 63744 && cp <= 64255) || (cp >= 65072 && cp <= 65103) || (cp >= 65280 && cp <= 65376) \
	    || (cp >= 65504 && cp <= 65510) || (cp >= 127744 && cp <= 128591) || (cp >= 128640 && cp <= 128767) \
	    || (cp >= 129280 && cp <= 129535) || (cp >= 129648 && cp <= 129791) || (cp >= 131072 && cp <= 262141)) return 2
	if (cp >= 8960 && cp <= 11263 && index(" 8986 8987 9193 9194 9195 9196 9200 9203 9725 9726 9748 9749 9800 9801 9802 9803 9804 9805 9806 9807 9808 9809 9810 9811 9855 9875 9889 9898 9899 9917 9918 9924 9925 9934 9940 9962 9970 9971 9973 9978 9981 9989 9994 9995 10024 10060 10062 10067 10068 10069 10071 10133 10134 10135 10160 10175 11035 11036 11088 11093 ", " " cp " ")) return 2
	return 1
}

# the cells of the bytes a..e of B[key, ...]: a selector of emoji after a character that
# takes one makes it take two
function rangeCells(B, key, a, e,    k, len, cp, w, last, lastCp, total) {
	total = 0; last = 0
	for (k = a; k <= e; k += len) {
		len = seqLen(ORD[B[key, k]])
		cp = codeAt(B, key, k, len)
		w = cpCells(cp)
		if (cp == 65039 && last == 1 && lastCp >= 8960) w = 1
		total += w
		last = w; lastCp = cp
	}
	return total
}

# the cells of a text with no looks in it
function cellsOf(s,    k, n) {
	if (utf8chars) return length(s)
	n = length(s)
	for (k = 1; k <= n; k++) TB["c", k] = substr(s, k, 1)
	return rangeCells(TB, "c", 1, n)
}

# a text with its looks taken out: the codes of a terminal and the marks of --spans
function visible(s) {
	gsub(/\033\[[0-9;]*m/, "", s)
	gsub(/[\001-\006\016-\025]/, "", s)
	return s
}

# ---- --spans: a line as bytes, each with its look ----

# the bytes of a rendered text into DB[key, ...] and their looks into DL[key, ...]; gives their count
function decode(s, key,    n, k, c, o, sp, ST) {
	n = 0; sp = 0
	for (k = 1; k <= length(s); k++) {
		c = substr(s, k, 1)
		o = ORD[c]
		if (o >= 1 && o < 32 && c != "\t") {
			if (c == POP) { if (sp > 0) sp-- }
			else if (c == RESET) sp = 0
			else if (c in LOOK) ST[++sp] = LOOK[c]
			continue
		}
		DB[key, ++n] = c
		DL[key, n] = sp > 0 ? ST[sp] : ""
	}
	DN[key] = n
	return n
}

# where the bytes a..n of DB[key, ...] break to take at most `room` cells: the last byte of
# the piece (BREAK_END) and the first of the rest (BREAK_NEXT), at a space where there is one
function breakAt(key, a, n, room,    k, len, w, used, lastSpace, cp, last, lastCp, seen) {
	used = 0; lastSpace = 0; last = 0; lastCp = 0; seen = 0
	for (k = a; k <= n; k += len) {
		len = seqLen(ORD[DB[key, k]])
		cp = codeAt(DB, key, k, len)
		w = cpCells(cp)
		if (cp == 65039 && last == 1 && lastCp >= 8960) w = 1
		if (used + w > room) break
		if (DB[key, k] == " ") { if (seen) lastSpace = k } else seen = 1
		used += w; last = w; lastCp = cp
	}
	if (k > n) { BREAK_END = n; BREAK_NEXT = n + 1; return }
	if (lastSpace) { BREAK_END = lastSpace - 1; BREAK_NEXT = lastSpace }
	else { BREAK_END = k > a ? k - 1 : a + seqLen(ORD[DB[key, a]]) - 1; BREAK_NEXT = BREAK_END + 1 }
	while (BREAK_END > a && DB[key, BREAK_END] == " ") BREAK_END--
	while (BREAK_NEXT <= n && DB[key, BREAK_NEXT] == " ") BREAK_NEXT++
}

# the bytes a..e of DB[key, ...] after `lead`, appended to the line being built (LB)
function lbAdd(key, a, e,    k) {
	for (k = a; k <= e; k++) { LBB[++LBN] = DB[key, k]; LBL[LBN] = DL[key, k] }
}

function lbText(s, look,    k) {
	for (k = 1; k <= length(s); k++) { LBB[++LBN] = substr(s, k, 1); LBL[LBN] = look }
}

# the line built, printed as its text, a TAB and its spans; then a new one
function lbEmit(    k, text, out, start) {
	text = ""; out = ""; start = 0
	for (k = 1; k <= LBN; k++) {
		text = text LBB[k]
		if (k == LBN || LBL[k+1] != LBL[k]) {
			if (LBL[k] != "") out = out (out == "" ? "" : ",") start "+" (k - start) "+" LBL[k]
			start = k
		}
	}
	print text "\t" out
	LBN = 0
}

function emitSpans(s, hang,    n, a, room, first) {
	n = decode(s, "L")
	LBN = 0
	if (n == 0 || width <= 0 || nowrap) { lbAdd("L", 1, n); lbEmit(); return }
	a = 1; first = 1
	while (a <= n) {
		if (!first) lbText(hang, "")
		room = width - (first ? 0 : cellsOf(hang))
		if (room < 1) room = 1
		breakAt("L", a, n, room)
		lbAdd("L", a, BREAK_END)
		lbEmit()
		a = BREAK_NEXT; first = 0
	}
}

# ---- front matter, rules, tables ----

# the front matter at the top of a text: its lines as they are, in the look of facts, with
# no line of dashes around them
function flushFront(    i, line) {
	for (i = 1; i <= frontN; i++) {
		line = FRONT[i]
		gsub(/\t/, "    ", line)
		emit(Q_ON line Q_OFF, "  ")
	}
	frontN = 0
}

function isRule(s) {
	return s ~ /^ ? ? ?(-[ \t]*-[ \t]*-[- \t]*|\*[ \t]*\*[ \t]*\*[* \t]*|_[ \t]*_[ \t]*_[_ \t]*)$/
}

function emitRule() {
	emit((spans ? MARK["rule"] : Q_ON) repeat(RULE, spans && width > 0 && !nowrap && width < RULE_MOST ? width : RULE_MOST) Q_OFF, "")
}

# the columns aligned to the right, by the separator under the head: `--:`, not `:-:`
function tableAligns(s,    count, parts, i) {
	sub(/^[ \t]*\|/, "", s); sub(/\|[ \t]*$/, "", s)
	count = split(s, parts, "|")
	for (i = 1; i <= count; i++) RIGHT[i] = (parts[i] ~ /-:[ \t]*$/ && parts[i] !~ /^[ \t]*:/)
}

function isTableSeparator(s) {
	return s ~ /^[ \t]*\|?[ \t]*:?-+:?[ \t]*(\|[ \t]*:?-+:?[ \t]*)+\|?[ \t]*$/
}

# the cells of a row of a table, trimmed, into TC[row, ...]
function tableRow(s,    count, parts, i, cell) {
	gsub(/\t/, "    ", s)
	sub(/^[ ]*\|/, "", s); sub(/\|[ ]*$/, "", s)
	count = split(s, parts, "|")
	tableRows++
	for (i = 1; i <= count; i++) {
		cell = parts[i]; sub(/^[ ]+/, "", cell); sub(/[ ]+$/, "", cell)
		TC[tableRows, i] = cell
	}
	TN[tableRows] = count
	if (count > tableColumns) tableColumns = count
}

# A table in columns, its head strong and a line under it. With --spans and --width=N, one
# wider than that has its widest columns narrowed and the words of their cells broken in
# them, its rows set apart by a line; with --no-wrap, or without --spans, it keeps its width.
function emitTable(    r, c, w, natural, total, room, widest, least, line, broken, k, rendered, key, lines, i) {
	for (c = 1; c <= tableColumns; c++) { natural[c] = 0; least[c] = 0 }
	for (r = 1; r <= tableRows; r++) for (c = 1; c <= tableColumns; c++) {
		rendered = r == 1 ? B_ON TC[r, c] B_OFF : inline(TC[r, c])
		if (spans && r == 1) rendered = MARK["head"] TC[r, c] RESET
		TR[r, c] = rendered
		w = cellsOf(visible(rendered))
		TW[r, c] = w
		if (w > natural[c]) natural[c] = w
		if (r == 1) least[c] = w
	}
	for (c = 1; c <= tableColumns; c++) { if (least[c] < 6) least[c] = natural[c] < 6 ? natural[c] : 6 ; CW[c] = natural[c] }
	total = 0
	for (c = 1; c <= tableColumns; c++) total += CW[c]
	room = width - cellsOf(COLUMN) * (tableColumns - 1)
	broken = 0
	if (spans && width > 0 && !nowrap && total > room) {
		while (total > room) {
			widest = 0
			for (c = 1; c <= tableColumns; c++) if (CW[c] > least[c] && (!widest || CW[c] > CW[widest])) widest = c
			if (!widest) break
			CW[widest]--; total--
		}
		broken = 1
	}
	if (!spans) {
		for (r = 1; r <= tableRows; r++) {
			line = ""
			for (c = 1; c <= tableColumns; c++)
				line = line (c > 1 ? Q_ON COLUMN Q_OFF : "") (RIGHT[c] && r > 1 ? repeat(" ", CW[c] - TW[r, c]) TR[r, c] : TR[r, c] (c < tableColumns ? repeat(" ", CW[c] - TW[r, c]) : ""))
			print line
			if (r == 1) {
				line = ""
				for (c = 1; c <= tableColumns; c++) line = line (c > 1 ? CROSS : "") repeat(RULE, CW[c])
				print Q_ON line Q_OFF
			}
		}
		return
	}
	for (r = 1; r <= tableRows; r++) {
		lines = 1
		for (c = 1; c <= tableColumns; c++) {
			key = "T" SUBSEP r SUBSEP c
			decode(TR[r, c], key)
			PIECES[r, c] = 0
			k = 1
			while (k <= DN[key]) {
				if (broken) breakAt(key, k, DN[key], CW[c]); else { BREAK_END = DN[key]; BREAK_NEXT = DN[key] + 1 }
				PIECES[r, c]++
				PA[r, c, PIECES[r, c]] = k; PE[r, c, PIECES[r, c]] = BREAK_END
				k = BREAK_NEXT
			}
			if (PIECES[r, c] > lines) lines = PIECES[r, c]
		}
		if (broken && r > 2) emitTableRule()
		for (i = 1; i <= lines; i++) {
			LBN = 0
			for (c = 1; c <= tableColumns; c++) {
				key = "T" SUBSEP r SUBSEP c
				if (c > 1) lbText(COLUMN, "rule")
				w = i <= PIECES[r, c] ? rangeCells(DB, key, PA[r, c, i], PE[r, c, i]) : 0
				if (RIGHT[c] && r > 1) lbText(repeat(" ", CW[c] - w), "")
				if (i <= PIECES[r, c]) lbAdd(key, PA[r, c, i], PE[r, c, i])
				if (c < tableColumns && !(RIGHT[c] && r > 1)) lbText(repeat(" ", CW[c] - w), "")
			}
			lbEmit()
		}
		if (r == 1) emitTableRule()
	}
}

function emitTableRule(    c, line) {
	line = ""
	for (c = 1; c <= tableColumns; c++) line = line (c > 1 ? CROSS : "") repeat(RULE, CW[c])
	LBN = 0; lbText(line, "rule"); lbEmit()
}

function flushTable() {
	emitTable()
	tableRows = 0; tableColumns = 0
	split("", RIGHT)
}

# ---- a line of the text ----

function renderLine(line,    indent, content, indent2, textPart, underline, i, rest, seq, level, mark) {

    # 0a) Single-line fenced code: ```foo bar``` → print "foo bar"
    if (!in_fence && line ~ /^[ \t]*```[^`]*```[ \t]*$/) {
        match(line, /^[ \t]*/)
        indent = substr(line, 1, RLENGTH)
        gsub(/\t/, "    ", indent)

        content = line
        sub(/^[ \t]*```/,    "", content)
        sub(/```[ \t]*$/,    "", content)

        emit(indent C_ON content C_OFF, indent)
        return
    }

	# 1) Fenced code-blocks
	if (sub(/^[ \t]{0,3}```.*$/, "", line)) {
		in_fence = in_fence ? 0 : 1
		return
	}

	# expand tabs to four spaces
	gsub(/\t/, "    ", line)
	
	if (in_fence) {
		emit(C_ON line C_OFF, "")
		return
	}

	# 2) \1 placeholder
	if (cmd != "") gsub(/\\1/, cmd,  line)
	else           gsub(/\\1/, "",   line)

	# 3) ATX headings: strip #… and one following space/tab

	if (spans && match(line, /^##?#?#?#?#?[ \t]/)) {
		level = RLENGTH - 1
		content = substr(line, RLENGTH + 1)
		match(content, /^[ \t]*/)
		indent2  = substr(content, 1, RLENGTH)
		textPart = substr(content, RLENGTH+1)
		mark = level == 1 ? "h1" : level == 2 ? "h2" : "h3"
		emit(MARK[mark] content RESET, indent2)
		if (level <= 3) {
			i = cellsOf(textPart)
			if (width > 0 && !nowrap && i > width - length(indent2)) i = width - length(indent2)
			emit(indent2 MARK[mark] repeat(level == 1 ? UNDER1 : level == 2 ? UNDER2 : UNDER3, i) RESET, "")
		}
		return
	}

	if (sub(/^#[ \t]/, "", line)) {
		content = line
		print H1_ON content
		# preserve leading spaces in content, underline only text
		match(content, /^[ \t]*/)
		indent2  = substr(content, 1, RLENGTH)
		textPart = substr(content, RLENGTH+1)
		underline = indent2
		for (i = 1; i <= length(textPart); i++) underline = underline "━"
		print underline R
		return
	}
	
	if (sub(/^##[ \t]/, "", line)) {
		content = line
		print H2_ON content
		# preserve leading spaces in content, underline only text
		match(content, /^[ \t]*/)
		indent2  = substr(content, 1, RLENGTH)
		textPart = substr(content, RLENGTH+1)
		underline = indent2
		for (i = 1; i <= length(textPart); i++) underline = underline "─"
		print underline R
		return
	}

	if (sub(/^###[ \t]/, "", line)) {
		content = line
		print H3_ON content
		# preserve leading spaces in content, underline only text
		match(content, /^[ \t]*/)
		indent2  = substr(content, 1, RLENGTH)
		textPart = substr(content, RLENGTH+1)
		underline = indent2
		for (i = 1; i <= length(textPart); i++) underline = underline "┄"
		print underline R
		return
	}

	if (sub(/^#{4,6}[ \t]/, "", line)) {
		print H3_ON line R
		return
	}

	# 4) Numbered lists – preserve indent
	if (match(line, /^[ \t]*/)) {
		indent = substr(line,1,RLENGTH)
		rest   = substr(line,RLENGTH+1)
		if (match(rest,/^[0-9]+\.[ \t]+/)) {
			seq     = substr(rest, RSTART, RLENGTH)
			content = substr(rest, RSTART+RLENGTH)
			sub(/^[ \t]+/, "", content)

			# apply inline formatting on content
			content = inline(content)

			emit(sprintf("%s%s%s%s%s%s", indent B_ON, BUL_ON, seq, BUL_OFF, B_OFF, content), indent repeat(" ", length(seq)))
			return
		}
	}


	# 5) Bullet lists – preserve indent
	if (match(line, /^[ \t]*/)) {
		indent = substr(line,1,RLENGTH)
		rest   = substr(line,RLENGTH+1)
		if (match(rest,/^[-*+][ \t]+/) && rest !~ /^--/) {
			content = substr(rest, RSTART+RLENGTH)

			# apply inline formatting on content
			content = inline(content)

			if (spans) { emit(indent MARK["item"] ITEM RESET " " content, indent "  "); return }
			printf("%s%s➤%s%s %s\n", indent BUL_ON, B_ON, B_OFF, BUL_OFF, content)
			return
		}
	}

	# 6) Blockquotes
	if (sub(/^[ \t]*>[ \t]*/, "", line)) {
		if (spans) { emit(MARK["quote"] "> " line RESET, "  "); return }
		print I_ON "> " line Q_OFF
		return
	}

	# 7) Inline `code`, **bold**, _italic_
	line = inline(line)

	# 8) Fallback: print unchanged
	match(line, /^[ ]*/)
	emit(line, substr(line, 1, RLENGTH))
}

# A text, line by line: the front matter on its first line, a rule after a blank line, a
# table, a head row and the separator under it, held until its last row; every other line
# rendered as it comes (renderLine).
{
	src = $0
	blankBefore = lastBlank
	lastBlank = (src ~ /^[ \t]*$/)
	if (front == 1) {
		if (src ~ /^(---|\.\.\.)[ \t]*$/) { front = 2; flushFront(); next }
		FRONT[++frontN] = src
		next
	}
	if (NR == 1 && src ~ /^---[ \t]*$/) { front = 1; next }
	if (tableRows) {
		if (!in_fence && src ~ /\|/ && !lastBlank) { tableRow(src); next }
		flushTable()
	}
	if (held) {
		held = 0
		if (!in_fence && isTableSeparator(src)) { tableRow(heldLine); tableAligns(src); next }
		renderLine(heldLine)
	}
	if (!in_fence && blankBefore && isRule(src) && src !~ /\|/) { emitRule(); next }
	if (!in_fence && src ~ /\|/ && src !~ /^[ \t]*```/) { held = 1; heldLine = src; next }
	renderLine(src)
}

END {
	if (front == 1) { renderLine("---"); for (i = 1; i <= frontN; i++) renderLine(FRONT[i]) }
	if (tableRows) flushTable()
	if (held) renderLine(heldLine)
}
