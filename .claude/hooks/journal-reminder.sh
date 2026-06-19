#!/usr/bin/env bash
# Stop hook: once per substantive session, prompt the agent to journal any
# un-captured personal/work content to the memory module before ending.
input=$(cat)
read -r session_id stop_active tpath < <(printf '%s' "$input" | /usr/bin/python3 -c \
  'import sys,json;d=json.load(sys.stdin);print(d.get("session_id",""),d.get("stop_hook_active",False),d.get("transcript_path",""))')

# Never loop: if our block already forced a continue, allow the stop.
[ "$stop_active" = "True" ] && exit 0

# Only nag once per session.
marker="/tmp/claude-journal-reminder-${session_id}"
[ -f "$marker" ] && exit 0

# Skip trivial sessions (nothing worth journaling yet).
[ -n "$tpath" ] && [ -f "$tpath" ] && [ "$(wc -c <"$tpath")" -lt 20000 ] && exit 0

touch "$marker"
printf '%s' '{"decision":"block","reason":"Before ending: if this session surfaced anything worth remembering — personal (events, people, feelings, plans) or work (what you built/changed, decisions, which module) — invoke the memory agent to append a timestamped entry to today'"'"'s by_date file and show it for approval. If nothing is journal-worthy, stop silently without saying anything."}'
