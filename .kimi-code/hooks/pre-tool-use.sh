#!/usr/bin/env bash
# Kimi PreToolUse hook: reminders and safety checks before Bash tool calls.

set -e

input=$(cat)
tool_name=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_name",""))')

# Only run in projects that have the Kimi memory agent reference.
if [ ! -e ".kimi-code/agents/memory.md" ]; then
  exit 0
fi

if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

command=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))')

# Remind about sync-docs before git commit.
if printf '%s' "$command" | grep -Eq '^git(\s+.*)?\s+commit'; then
  echo '📝 Before committing, run /sync-docs to ensure documentation is up to date.'
fi

exit 0
