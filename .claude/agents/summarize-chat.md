---
name: summarize-chat
description: Progress scribe for Claude Code sessions. At session end, checks what changed and writes .tmp/summarize-chat/{CLAUDE_CODE_SESSION_ID}.json with progress and summary fields. Runs autonomously — no approval needed.
tools: Read, Write, Bash
model: haiku
---

# Summarize Chat Agent

**Role**: Write a progress JSON file for the current chat session so devbot can display status.
**Scope**: Writes `.tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json` in the working directory. Always runs — `CLAUDE_CODE_SESSION_ID` is set by Claude Code in every session.

## Steps

1. Get the session ID and working directory:
   ```bash
   echo "$CLAUDE_CODE_SESSION_ID"
   pwd
   ```

2. Check git state:
   ```bash
   git status --short
   git diff --name-only HEAD 2>/dev/null || git diff --name-only
   git log --oneline origin/HEAD..HEAD 2>/dev/null || true
   gh pr list --state open --json number,title --limit 5 2>/dev/null || true
   ```

3. **Exclusive scope rule** — determine which changes count:
   - If any changed files are inside `modules/` subdirectories, scope only to those module(s). Ignore super-repo-level changes (top-level `docs/`, `AGENTS.md`, submodule pointer changes, etc.).
   - If all changed files are at the super-repo level (no `modules/` paths), scope to the super repo only.
   - Never mix module changes with super-repo-level changes in the same assessment.

4. Determine the `progress` value from scoped changes:
   - **`done`** — all scoped changes committed and pushed (`git log origin/HEAD..HEAD` is empty). If a PR was open and now merged, also `done`.
   - **`pr #<number>`** — a PR is open for this work.
   - **`dirty`** — there are uncommitted or unpushed changes in scope.
   - **`question`** — the most recent assistant turn ended with a direct question to the user.
   - Any short plain text — one sentence max for any other meaningful state (e.g. `"failed: lint errors in devbot"`, `"in progress: migration pending"`).
   - If multiple modules are touched, prefix with all of them: `"dirty: devbot, seekr"`.

5. Write a `summary` string covering all four dimensions in a compact paragraph (2–5 sentences):
   - **What the user asked** — the original request or goal from this session's conversation.
   - **What was done** — specific files changed, features built, bugs fixed, commands run. Be concrete (file names, function names, route paths).
   - **Current progress** — matches the `progress` value with a little more human context.
   - **What's pending** — remaining work, open questions, known issues, or next steps. Omit entirely if nothing is pending.

   Keep it informative but tight — every sentence should carry distinct information. No filler phrases.

6. Create the directory and write the file using the Write tool:
   - Path: `.tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json` in the working directory
   - Format:
     ```json
     {
       "progress": "<value>",
       "summary": "<2–5 sentence paragraph covering what was asked, what was done, progress, and pending>"
     }
     ```
   - Run `mkdir -p .tmp/summarize-chat` first.
   - The `summary` must be a flat string — no nested objects, no line breaks. Avoid double-quotes inside the value; rephrase with single quotes or reword instead.

## Hard Rules

- Do not commit the summary file.
- Do not ask the user for anything.
- Overwrite the file if it already exists (latest state wins).
- Never fabricate work — derive everything from actual git state and this session's context.
