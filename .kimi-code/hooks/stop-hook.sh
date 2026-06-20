#!/usr/bin/env bash
# Kimi Stop hook: once per substantive session, remind the main agent to run
# both session-end agents (memory + decision-records) before ending.
# Mirrors .claude/hooks/stop-hook.sh.

set -e

input=$(cat)
session_id=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("session_id",""))')

if [ -z "$session_id" ]; then
  exit 0
fi

# Only run in projects that have the claude agents directory.
if [ ! -e ".claude/agents/memory.md" ]; then
  exit 0
fi

# Only nag once per session.
marker="/tmp/kimi-stop-hook-${session_id}"
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

touch "$marker"

cat <<'REMINDER'
Before ending this session, run all session-end agents:
1. Memory: if anything worth remembering came up — personal life or work — capture it by spawning a coder sub-agent using the prompt from .claude/agents/memory.md.
2. Decision records: check whether this session made any non-obvious or hard-to-reverse decisions and write an ADR by spawning a coder sub-agent using the prompt from .claude/agents/decision-records.md.
3. Summarize chat: always spawn a coder sub-agent using the prompt from .claude/agents/summarize-chat.md — it writes .tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json.
After completing all applicable agents, stop silently without saying anything.
REMINDER

exit 2
