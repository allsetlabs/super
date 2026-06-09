#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // ""')
command=$(echo "$input" | jq -r '.tool_input.command // ""')

if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# Only check git commands
if ! echo "$command" | grep -qE 'git\s+'; then
  exit 0
fi

# Get current branch
current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")

# On main: only allow pull, fetch, checkout, status, log, diff, branch (without -D)
if [ "$current_branch" = "main" ]; then
  if echo "$command" | grep -qE 'git\s+(pull|fetch|checkout|switch|status|log|diff|stash|branch)\b'; then
    # Block branch -D main
    if echo "$command" | grep -qE 'git\s+branch\s+-[dD]\s+.*\bmain\b'; then
      echo "BLOCKED: Deleting the main branch is blocked." >&2
      exit 2
    fi
    exit 0
  fi
  echo "BLOCKED: Only git pull/fetch/checkout/status/log/diff are allowed on main. Create a feature branch first: git checkout -b feat/your-feature" >&2
  exit 2
fi

# Off main: block force push and push to main
if echo "$command" | grep -qE 'git\s+push\s+.*(--force|-f\b)'; then
  echo "BLOCKED: Force pushing is blocked for safety." >&2
  exit 2
fi
if echo "$command" | grep -qE 'git\s+push\s+.*\bmain\b'; then
  echo "BLOCKED: Pushing to main is blocked. Push your feature branch and merge via PR." >&2
  exit 2
fi

exit 0
