#!/usr/bin/env awk

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

  # 3) ATX headings: strip #… and one following space/tab

  if (sub(/^#[ \t]/, "", line)) {
    content = line
    print content
	# preserve leading spaces in content, underline only text
    match(content, /^[ \t]*/)
    indent2  = substr(content, 1, RLENGTH)
    textPart = substr(content, RLENGTH+1)
    underline = indent2
    for (i = 1; i <= length(textPart); i++) underline = underline "━"
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
    for (i = 1; i <= length(textPart); i++) underline = underline "─"
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
    for (i = 1; i <= length(textPart); i++) underline = underline "┄"
    print underline
    next
  }

  if (sub(/^#{4,6}[ \t]/, "", line)) {
    print line
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

      # inline code, bold, italic on content
      while (match(content, /`[^`]+`/)) {
        span   = substr(content, RSTART, RLENGTH)
        inner  = substr(span, 2, RLENGTH-2)
        content = substr(content,1,RSTART-1) inner substr(content,RSTART+RLENGTH)
      }
      while (match(content, /\*\*[^*]+\*\*/)) {
        span   = substr(content, RSTART, RLENGTH)
        inner  = substr(span, 3, RLENGTH-4)
        content = substr(content,1,RSTART-1) inner substr(content,RSTART+RLENGTH)
      }
      while (match(content, /_[^_]+_/)) {
        span   = substr(content, RSTART, RLENGTH)
        inner  = substr(span, 2, RLENGTH-2)
        content = substr(content,1,RSTART-1) inner substr(content,RSTART+RLENGTH)
      }

      print indent seq content
      next
    }
  }

  # 5) Bullet lists – preserve indent
  if (match(line, /^[ \t]*/)) {
    indent = substr(line,1,RLENGTH)
    rest   = substr(line,RLENGTH+1)
    if (match(rest,/^[-*+][ \t]+/) && rest !~ /^--/) {
      content = substr(rest, RSTART+RLENGTH)

      # inline code, bold, italic on content
      while (match(content, /`[^`]+`/)) {
        span   = substr(content, RSTART, RLENGTH)
        inner  = substr(span, 2, RLENGTH-2)
        content = substr(content,1,RSTART-1) inner substr(content,RSTART+RLENGTH)
      }
      while (match(content, /\*\*[^*]+\*\*/)) {
        span   = substr(content, RSTART, RLENGTH)
        inner  = substr(span, 3, RLENGTH-4)
        content = substr(content,1,RSTART-1) inner substr(content,RSTART+RLENGTH)
      }
      while (match(content, /_[^_]+_/)) {
        span   = substr(content, RSTART, RLENGTH)
        inner  = substr(span, 2, RLENGTH-2)
        content = substr(content,1,RSTART-1) inner substr(content,RSTART+RLENGTH)
      }

      print indent "- " content
      next
    }
  }

  # 6) Blockquotes
  if (sub(/^[ \t]*>[ \t]*/, "", line)) {
    print "> " line
    next
  }

	# 7) Inline `code`, **bold**, _italic_
  while (match(line, /`[^`]+`/)) {
    span = substr(line, RSTART, RLENGTH)
    inner = substr(span, 2, RLENGTH-2)
    line = substr(line,1,RSTART-1) inner substr(line,RSTART+RLENGTH)
  }
  while (match(line, /\*\*[^*]+\*\*/)) {
    span = substr(line, RSTART, RLENGTH)
    inner = substr(span, 3, RLENGTH-4)
    line = substr(line,1,RSTART-1) inner substr(line,RSTART+RLENGTH)
  }
  while (match(line, /_[^_]+_/)) {
    span = substr(line, RSTART, RLENGTH)
    inner = substr(span, 2, RLENGTH-2)
    line = substr(line,1,RSTART-1) inner substr(line,RSTART+RLENGTH)
  }

  # 8) Fallback: print unchanged
  print line
}
