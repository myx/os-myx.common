#!/usr/bin/env awk
#
# md2txt-decorate.awk — plain-text export with H1/H2 underlines

BEGIN {
  in_fence = 0
  cmd      = ("CMD" in ENVIRON ? ENVIRON["CMD"] : "")
}

{
  line = $0

  # 1) Fenced code-blocks
  if (line ~ /^```/) {
    in_fence = !in_fence
    next
  }
  if (in_fence) {
    print line
    next
  }

  # 2) \1 placeholder
  if (cmd != "") gsub(/\\1/, cmd,  line)
  else           gsub(/\\1/, "",   line)

  # 3) ATX headings: strip #… and exactly one following space/tab

	if (sub(/^#[ \t]/, "", line)) {
		content = line
		print content
		# preserve leading spaces in content, underline only text
		match(content, /^[ \t]*/)
		indent2  = substr(content, 1, RLENGTH)
		textPart = substr(content, RLENGTH+1)
		underline = indent2
		for (i = 1; i <= length(textPart); i++) underline = underline "━" # "="
		print underline
		next
	}

	if (sub(/^##[ \t]/, "", line)) {
		content = line
		print content
		# preserve leading spaces in content, underline only text
		match(content, /^[ \t]*/)
		indent2  = substr(content, 1, RLENGTH)
		textPart = substr(content, RLENGTH+1)
		underline = indent2
		for (i = 1; i <= length(textPart); i++) underline = underline "─" #  "-"
		print underline
		next
	}

	if (sub(/^###[ \t]/, "", line)) {
		content = line
		print content
		# preserve leading spaces in content, underline only text
		match(content, /^[ \t]*/)
		indent2  = substr(content, 1, RLENGTH)
		textPart = substr(content, RLENGTH+1)
		underline = indent2
		for (i = 1; i <= length(textPart); i++) underline = underline "┄" # "-"
		print underline
		next
	}

  if (sub(/^#{4,6}[ \t]/, "", line)) {
    print line
    next
  }

  # 4) Numbered lists
  if (match(line, /^[ \t]*[0-9]+\.[ \t]+/)) {
    seq     = substr(line, RSTART, RLENGTH)
    content = substr(line, RSTART + RLENGTH)
    sub(/^[ \t]+/, "", content)
    print seq content
    next
  }

  # 5) Bullet lists (skip --flags)
  if (match(line, /^[ \t]*[-*+][ \t]+/) && line !~ /^[ \t]*--/) {
    content = substr(line, RSTART + RLENGTH)
    print "- " content
    next
  }

  # 6) Blockquotes
  if (sub(/^[ \t]*>[ \t]*/, "", line)) {
    print "> " line
    next
  }

	# 7) Inline `code`, **bold**, _italic_
	while (match(line, /`[^`]+`/)) {
		span  = substr(line, RSTART, RLENGTH)
		mid   = substr(span, 2, RLENGTH-2)
		line  = substr(line,1,RSTART-1) mid substr(line,RSTART+RLENGTH)
	}
	while (match(line, /\*\*[^*]+\*\*/)) {
		span  = substr(line, RSTART, RLENGTH)
		mid   = substr(span, 3, RLENGTH-4)
		line  = substr(line,1,RSTART-1) mid substr(line,RSTART+RLENGTH)
	}
	while (match(line, /_[^_]+_/)) {
		span  = substr(line, RSTART, RLENGTH)
		mid   = substr(span, 2, RLENGTH-2)
		line  = substr(line,1,RSTART-1) mid substr(line,RSTART+RLENGTH)
	}

	# 8) Fallback
	print line
}
