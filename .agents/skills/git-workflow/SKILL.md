---
name: git-workflow
description: Git workflow with commit standards for committing directly to main. Use when performing any git operation (commit, push, branch, merge).
---

# Git Workflow

Read and follow ALL rules below before performing any git operation.

## Workflow: Always Commit to `main`

All commits go directly to `main`. No feature branches, no PRs.

## Commit Message Format

```
<type>(<scope>): <short description>

## Summary
- <bullet points describing changes>

## Changelog
- <what changed and why, per file or logical group>

## Test Plan
- [ ] <testing steps>

## Model
<AI model that ran this session, e.g. Claude Sonnet 4.6>

Co-Authored-By: <AI tool and model, e.g. Claude Sonnet 4.6 <noreply@anthropic.com>>
```

**Types**: `feat`, `fix`, `hotfix`, `refactor`, `chore`, `docs`, `test`, `style`, `perf`, `ci`

**Scope** = module name (the submodule's directory name). Omit scope for cross-module changes.

## Execution Steps

When `/commit` is invoked, execute these steps in order:

### Step 1: Analyze Changes

Run in parallel:

- `git branch --show-current`
- `git status`
- `git diff --staged` and `git diff` (to see all changes)
- `git log --oneline -5` (for commit message style reference)

If there are no changes to commit, inform the user and stop.

### Step 2: Identify Session Files

Only stage files that were **edited in this session**. The model must track which files it touched during the conversation and pass only those to `git add`. Do NOT stage all modified files blindly.

- List the files edited during this session explicitly
- Stage only those files: `git add <file1> <file2> ...`
- Never use `git add .` or `git add -A`

### Step 3: Commit

Draft and commit using HEREDOC format:

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <short description>

## Summary
- <bullet points describing changes>

## Changelog
- <what changed and why, per file or logical group>

## Test Plan
- [ ] <testing steps>

## Model
<AI model name, e.g. Claude Sonnet 4.6>

Co-Authored-By: <AI model name, e.g. Claude Sonnet 4.6 <noreply@anthropic.com>>
EOF
)"
```

### Step 4: Push to Main

Push directly to main:

```bash
git push origin main
```

Confirm to the user that the commit was pushed to main.

### Important Notes

- **NEVER** use `--no-verify` flag
- **NEVER** use `git add .` or `git add -A` — always stage specific files
- Only stage files edited in this session
- Commit message title under 70 chars
- Default push target is always `main`
