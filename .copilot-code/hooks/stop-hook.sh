#!/usr/bin/env bash
# Copilot Stop hook: once per substantive session, remind the main agent to run
# the session-end skills (memory, decision-records, summarize-chat) before ending.
# Mirrors .claude/hooks/stop-hook.sh and .kimi-code/hooks/stop-hook.sh.

set -e

input=$(cat)
session_id=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("session_id",""))')

if [ -z "$session_id" ]; then
  exit 0
fi

# Only run in projects that have the memory skill.
if [ ! -e ".agents/skills/memory/SKILL.md" ]; then
  exit 0
fi

# Only nag once per session.
marker="/tmp/copilot-stop-hook-${session_id}"
if [ -f "$marker" ]; then
  exit 0
fi

# Find the session wire file to judge whether the session is substantive.
wire_file=""
session_dir=$(find "$HOME/.copilot-code/sessions" -maxdepth 2 -type d -name "$session_id" 2>/dev/null | head -n 1)
if [ -n "$session_dir" ] && [ -d "$session_dir" ]; then
  wire_file=$(find "$session_dir" -maxdepth 1 -name 'wire.jsonl' -print 2>/dev/null | head -n 1)
fi

# Skip trivial sessions (wire file smaller than ~10 KB).
if [ -n "$wire_file" ] && [ -f "$wire_file" ]; then
  size=$(wc -c < "$wire_file")
  if [ "$size" -lt 10240 ]; then
    exit 0
  fi
fi

touch "$marker"

cat <<'REMINDER'
Before ending this session, run these in order:
1. Memory (only if worth remembering — personal: events, people, feelings, plans; work: what you built/changed, decisions, which module): invoke the Skill tool with skill="memory".
2. Decision records (only when irreversible changes were made — new architecture, deleted data, major config, public API changes): invoke the Skill tool with skill="decision-records".
3. Summarize chat (always): invoke the Skill tool with skill="summarize-chat" — it writes .tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json.
After completing all applicable tasks, stop silently without saying anything.
REMINDER

exit 2
