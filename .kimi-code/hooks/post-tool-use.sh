#!/usr/bin/env bash
# Kimi PostToolUse hook: reminders after code changes.

set -e

input=$(cat)
tool_name=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_name",""))')

# Only run in projects that have the Kimi memory agent reference.
if [ ! -e ".kimi-code/agents/memory.md" ]; then
  exit 0
fi

case "$tool_name" in
  Edit|Write)
    echo '✅ Code modified. Remember to run: npm run lint && npm run type-check'
    ;;
esac

exit 0
