#!/usr/bin/env bash
# Kimi Stop hook: once per substantive session, remind the main agent to invoke
# the memory agent before ending. Mirrors the intent of .claude/hooks/journal-reminder.sh.

set -e

# Read JSON event payload from stdin.
input=$(cat)
session_id=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("session_id",""))')

if [ -z "$session_id" ]; then
  exit 0
fi

# Only run in projects that have the Kimi memory agent reference.
if [ ! -e ".kimi-code/agents/memory.md" ]; then
  exit 0
fi

# Only nag once per session.
marker="/tmp/kimi-memory-reminder-${session_id}"
if [ -f "$marker" ]; then
  exit 0
fi

# Find the session wire file to judge whether the session is substantive.
wire_file=""
session_dir=$(find "$HOME/.kimi-code/sessions" -maxdepth 2 -type d -name "$session_id" 2>/dev/null | head -n 1)
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

# Mark that we have nagged for this session.
touch "$marker"

# Block the Stop event and append a reminder to the main agent's context.
cat <<'REMINDER'
Before ending this session: if anything worth remembering came up — personal life or work — capture it by reading .kimi-code/agents/memory.md and dispatching a coder sub-agent with that prompt. If nothing is journal-worthy, end the session silently.
REMINDER

exit 2
