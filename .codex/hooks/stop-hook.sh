#!/usr/bin/env bash
# Codex Stop hook: once per substantive session, continue the turn with the
# session-end skill reminders (memory, decision-records, summarize-chat).
# Mirrors the intent of the Claude, Kimi, and Copilot stop hooks.

set -e

input=$(cat)
read -r session_id transcript_path stop_active < <(
  printf '%s' "$input" | /usr/bin/python3 -c '
import json, sys
d = json.load(sys.stdin)
print(d.get("session_id", ""), d.get("transcript_path", ""), d.get("stop_hook_active", False))
'
)

if [ -z "$session_id" ]; then
  exit 0
fi

# Only run in projects that have the memory skill.
if [ ! -e ".agents/skills/memory/SKILL.md" ]; then
  exit 0
fi

# Never loop: once continued, allow the next stop to complete.
if [ "$stop_active" = "True" ]; then
  printf '%s\n' '{"continue":true}'
  exit 0
fi

# Skip trivial sessions.
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  size=$(wc -c < "$transcript_path")
  if [ "$size" -lt 20000 ]; then
    printf '%s\n' '{"continue":true}'
    exit 0
  fi
fi

printf '%s\n' '{"decision":"block","reason":"Before ending, run these three skills inline with full session context: (1) memory if this session surfaced anything worth remembering, personal or work; (2) decision-records if this session made any non-obvious or hard-to-reverse decisions; (3) summarize-chat always, so it writes the session progress file under .tmp/summarize-chat/. After completing all applicable tasks, stop silently without saying anything."}'
