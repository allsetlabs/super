#!/usr/bin/env bash
# Kimi PostToolUse hook: after a git commit, run sync-docs and sync-api.
# Mirrors .claude/settings.json PostToolUse hook for Bash(git commit*).

set -e

input=$(cat)
tool_name=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_name",""))')

if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

command=$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))')

# Only fire for git commit commands.
if ! printf '%s' "$command" | grep -Eq '^git(\s+.*)?\s+commit'; then
  exit 0
fi

cat <<'REMINDER'
Git commit completed. Per CLAUDE.md rules, now run:
1. sync-docs skill — update docs/<module>/index.md for any module whose code changed. Invoke the Skill tool with skill="sync-docs".
2. sync-api skill — only if backend or API code was edited. Invoke the Skill tool with skill="sync-api".
REMINDER

exit 2
