#!/usr/bin/env awk

BEGIN {

  ansi = 0
  for (i = 1; i < ARGC; i++) {
    if (ARGV[i] == "--use-ansi") {
      ansi = 1
      delete ARGV[i]; ARGC--
    }
  }

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
  } else {
    # no colors
    R=""; H1_ON=""; H2_ON=""; H3_ON=""
    B_ON=""; B_OFF=""; I_ON=""; I_OFF=""
    C_ON=""; C_OFF=""; Q_ON=""; Q_OFF=""
    BUL_ON=""; BUL_OFF=""
  }

  in_fence = 0
  cmd      = ("CMD" in ENVIRON ? ENVIRON["CMD"] : "")
}

{
	line = $0

		# expand tabs to four spaces
	gsub(/\t/, "    ", line)

	# 1) Fenced code-blocks
	if (line ~ /^```/) {
		in_fence = !in_fence
		next
	}
	if (in_fence) {
		print C_ON line C_OFF
		next
	}

	# 2) \1 placeholder
	if (cmd != "") gsub(/\\1/, cmd,  line)
	else           gsub(/\\1/, "",   line)

	# 3) ATX headings: strip #… and one following space/tab

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
		next
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
		next
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
		next
	}

	if (sub(/^#{4,6}[ \t]/, "", line)) {
		print H3_ON line R
		next
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
			while (match(content, /`[^`]+`/)) {
				span   = substr(content, RSTART, RLENGTH)
				inner  = substr(span, 2, RLENGTH-2)
				rep    = C_ON inner C_OFF
				content = substr(content,1,RSTART-1) rep substr(content,RSTART+RLENGTH)
			}

			while (match(content, /\*\*[^*]+\*\*/)) {
				span   = substr(content, RSTART, RLENGTH)
				inner  = substr(span, 3, RLENGTH-4)
				rep    = B_ON inner B_OFF
				content = substr(content,1,RSTART-1) rep substr(content,RSTART+RLENGTH)
			}
			
			while (match(content, /_[^_]+_/)) {
				span   = substr(content, RSTART, RLENGTH)
				inner  = substr(span, 2, RLENGTH-2)
				rep    = I_ON inner I_OFF
				content = substr(content,1,RSTART-1) rep substr(content,RSTART+RLENGTH)
			}

			printf("%s%s%s%s%s%s\n", indent B_ON, BUL_ON, seq, BUL_OFF, B_OFF, content)
			next
		}
	}


	# 5) Bullet lists – preserve indent
	if (match(line, /^[ \t]*/)) {
		indent = substr(line,1,RLENGTH)
		rest   = substr(line,RLENGTH+1)
		if (match(rest,/^[-*+][ \t]+/) && rest !~ /^--/) {
			content = substr(rest, RSTART+RLENGTH)

			# apply inline formatting on content
			while (match(content, /`[^`]+`/)) {
				span   = substr(content, RSTART, RLENGTH)
				inner  = substr(span, 2, RLENGTH-2)
				rep    = C_ON inner C_OFF
				content = substr(content,1,RSTART-1) rep substr(content,RSTART+RLENGTH)
			}
			
			while (match(content, /\*\*[^*]+\*\*/)) {
				span   = substr(content, RSTART, RLENGTH)
				inner  = substr(span, 3, RLENGTH-4)
				rep    = B_ON inner B_OFF
				content = substr(content,1,RSTART-1) rep substr(content,RSTART+RLENGTH)
			}

			while (match(content, /_[^_]+_/)) {
				span   = substr(content, RSTART, RLENGTH)
				inner  = substr(span, 2, RLENGTH-2)
				rep    = I_ON inner I_OFF
				content = substr(content,1,RSTART-1) rep substr(content,RSTART+RLENGTH)
			}

			printf("%s%s•%s%s %s\n", indent BUL_ON, B_ON, B_OFF, BUL_OFF, content)
			next
		}
	}

	# 6) Blockquotes
	if (sub(/^[ \t]*>[ \t]*/, "", line)) {
		print I_ON "> " line Q_OFF
		next
	}

	# 7) Inline `code`, **bold**, _italic_
	while (match(line, /`[^`]+`/)) {
		span = substr(line, RSTART, RLENGTH)
		inner = substr(span, 2, RLENGTH-2)
		rep = C_ON inner C_OFF
		line = substr(line,1,RSTART-1) rep substr(line,RSTART+RLENGTH)
	}
	while (match(line, /\*\*[^*]+\*\*/)) {
		span = substr(line, RSTART, RLENGTH)
		inner = substr(span, 3, RLENGTH-4)
		rep = B_ON inner B_OFF
		line = substr(line,1,RSTART-1) rep substr(line,RSTART+RLENGTH)
	}
	while (match(line, /_[^_]+_/)) {
		span = substr(line, RSTART, RLENGTH)
		inner = substr(span, 2, RLENGTH-2)
		rep = I_ON inner I_OFF
		line = substr(line,1,RSTART-1) rep substr(line,RSTART+RLENGTH)
	}

	# 8) Fallback: print unchanged
	print line
}
