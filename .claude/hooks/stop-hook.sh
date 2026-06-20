#!/usr/bin/env bash
# Stop hook: on every substantive stop, invoke the three session-end skills.
input=$(cat)
read -r stop_active tpath < <(printf '%s' "$input" | /usr/bin/python3 -c \
  'import sys,json;d=json.load(sys.stdin);print(d.get("stop_hook_active",False),d.get("transcript_path",""))')

# Never loop: if our block already forced a continue, allow the stop.
[ "$stop_active" = "True" ] && exit 0

# Skip trivial sessions (nothing worth capturing yet).
[ -n "$tpath" ] && [ -f "$tpath" ] && [ "$(wc -c <"$tpath")" -lt 20000 ] && exit 0

printf '%s' '{"decision":"block","reason":"Before ending, invoke these three skills using the Skill tool (they run inline with full session context): (1) Invoke the '\''memory'\'' skill if this session surfaced anything worth remembering — personal (events, people, feelings, plans) or work (what you built/changed, decisions, which module). (2) Invoke the '\''decision-records'\'' skill to check whether this session made any non-obvious or hard-to-reverse decisions and write an ADR if so. (3) Always invoke the '\''summarize-chat'\'' skill to write .tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json. After completing all applicable tasks, stop silently without saying anything."}'
