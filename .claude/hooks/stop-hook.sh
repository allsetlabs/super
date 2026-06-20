#!/usr/bin/env bash
# Stop hook: on every substantive stop, prompt the agent to run session-end
# agents (memory + decision-records + summarize-chat) before ending.
input=$(cat)
read -r stop_active tpath < <(printf '%s' "$input" | /usr/bin/python3 -c \
  'import sys,json;d=json.load(sys.stdin);print(d.get("stop_hook_active",False),d.get("transcript_path",""))')

# Never loop: if our block already forced a continue, allow the stop.
[ "$stop_active" = "True" ] && exit 0

# Skip trivial sessions (nothing worth capturing yet).
[ -n "$tpath" ] && [ -f "$tpath" ] && [ "$(wc -c <"$tpath")" -lt 20000 ] && exit 0

printf '%s' '{"decision":"block","reason":"Before ending, run these in order: (1) If this session surfaced anything worth remembering — personal (events, people, feelings, plans) or work (what you built/changed, decisions, which module) — invoke the memory agent (.claude/agents/memory.md) to append a timestamped entry to today'\''s by_date file. (2) Invoke the decision-records agent (.claude/agents/decision-records.md) to check whether this session made any non-obvious or hard-to-reverse decisions and write an ADR if so. (3) Invoke the summarize-chat agent (.claude/agents/summarize-chat.md) — it always writes .tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json. After completing all applicable agents, stop silently without saying anything."}'
