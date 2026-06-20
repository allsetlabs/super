#!/usr/bin/env bash
# Kimi PostToolUse hook: run summarize-chat after every git commit.

set -e

input=$(cat)
tool_name=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_name",""))')

# Only run in projects that have the agents directory.
if [ ! -e ".claude/agents/summarize-chat.md" ]; then
  exit 0
fi

if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

command=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))')

if printf '%s' "$command" | grep -Eq '^git(\s+.*)?\s+commit'; then
  echo 'Commit complete. Now spawn a coder sub-agent using the prompt from .claude/agents/summarize-chat.md to update .tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json.'
fi

exit 0
