#!/usr/bin/env bash
# Codex PostToolUse hook: after a git commit Bash command, remind the agent to
# run sync-docs and sync-api. Mirrors the intent of the Claude, Kimi, and
# Copilot post-commit hooks.

set -e

input=$(cat)
command=$(
  printf '%s' "$input" | /usr/bin/python3 -c '
import json, sys
d = json.load(sys.stdin)
tool_input = d.get("tool_input") or {}
print(tool_input.get("command", ""))
'
)

# Only fire for git commit commands.
if ! printf '%s' "$command" | grep -Eq '^git(\s+.*)?\s+commit'; then
  exit 0
fi

cat >&2 <<'REMINDER'
Git commit completed. Per AGENTS.md rules, now run:
1. sync-docs skill — update docs/<module>/index.md for any module whose code changed.
2. sync-api skill — only if backend or API code was edited.
REMINDER

exit 2
