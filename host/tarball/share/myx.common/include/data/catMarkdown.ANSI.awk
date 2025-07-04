#!/usr/bin/env awk
#
# md2ansi.awk — Markdown → ANSI-coloured terminal output

BEGIN {
  esc      = sprintf("%c",27)
  R        = esc "[0m"
  H1_ON    = esc "[1;95m"
  H2_ON    = esc "[1;94m"
  H3_ON    = esc "[1;92m"
  B_ON     = esc "[1m";     B_OFF = esc "[22m"
  I_ON     = esc "[3m";     I_OFF = esc "[23m"
  C_ON     = esc "[96m";    C_OFF = R
  Q_ON     = esc "[90m";    Q_OFF = R
  BUL_ON   = esc "[32m";    BUL_OFF = R

  in_fence = 0
  cmd      = ("CMD" in ENVIRON ? ENVIRON["CMD"] : "")
}

{
  line = $0

  # 1) Fenced code‐blocks
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

  # 3) ATX headings: strip #… and exactly one following space/tab

  if (sub(/^#[ \t]/, "", line)) {
    print H1_ON line R
    next
  }
  if (sub(/^##[ \t]/, "", line)) {
    print H2_ON line R
    next
  }
  if (sub(/^#{3,6}[ \t]/, "", line)) {
    print H3_ON line R
    next
  }

  # 4) Numbered lists
  if (match(line, /^[ \t]*[0-9]+\.[ \t]+/)) {
    seq     = substr(line, RSTART, RLENGTH)
    content = substr(line, RSTART + RLENGTH)
    sub(/^[ \t]+/, "", content)

    # inline formatting inside list content
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


    printf("%s%s%s %s\n", B_ON, seq, B_OFF, content)
    next
  }

  # 5) Bullet lists (skip --flags)
  if (match(line, /^[ \t]*[-*+][ \t]+/) && line !~ /^[ \t]*--/) {
    content = substr(line, RSTART + RLENGTH)

    # inline formatting inside list content
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


    printf("%s•%s %s\n", BUL_ON, BUL_OFF, content)
    next
  }

  # 6) Blockquotes
  if (sub(/^[ \t]*>[ \t]*/, "", line)) {
    print I_ON "> " line Q_OFF
    next
  }

  # 7) Inline code, bold, italic
  while (match(line, /`[^`]+`/)) {
    span  = substr(line, RSTART, RLENGTH)
    mid   = substr(span, 2, RLENGTH-2)
    rep   = C_ON mid C_OFF
    line  = substr(line,1,RSTART-1) rep substr(line,RSTART+RLENGTH)
  }
  while (match(line, /\*\*[^*]+\*\*/)) {
    span  = substr(line, RSTART, RLENGTH)
    mid   = substr(span, 3, RLENGTH-4)
    rep   = B_ON mid B_OFF
    line  = substr(line,1,RSTART-1) rep substr(line,RSTART+RLENGTH)
  }
  while (match(line, /_[^_]+_/)) {
    span  = substr(line, RSTART, RLENGTH)
    mid   = substr(span, 2, RLENGTH-2)
    rep   = I_ON mid I_OFF
    line  = substr(line,1,RSTART-1) rep substr(line,RSTART+RLENGTH)
  }

  # 8) Fallback
  print line
}
