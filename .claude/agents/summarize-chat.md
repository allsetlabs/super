---
name: summarize-chat
description: Progress scribe for Claude Code sessions. At session end, checks what changed and writes .tmp/summarize-chat/{CLAUDE_CODE_SESSION_ID}.json with progress and a structured markdown summary. Runs autonomously — no approval needed.
tools: Read, Write, Bash
model: haiku
---

# Summarize Chat Agent

**Role**: Write a progress JSON file for the current chat session so devbot can display status.
**Scope**: Writes `.tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json`. Always runs — `CLAUDE_CODE_SESSION_ID` is set by Claude Code in every session.

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
   - **`done`** — all scoped changes committed and pushed (`git log origin/HEAD..HEAD` is empty).
   - **`pr #<number>`** — a PR is open for this work.
   - **`dirty`** — there are uncommitted or unpushed changes in scope.
   - **`question`** — the most recent assistant turn ended with a direct question to the user.
   - Any short plain text — one sentence max for any other meaningful state (e.g. `"failed: lint errors in devbot"`).
   - If multiple modules are touched, prefix with all of them: `"dirty: devbot, seekr"`.

5. Write a `summary` in **structured markdown** with these sections. Use `##` for section headings and `-` bullet points for items inside. Only include a section if it has content — omit empty sections entirely.

   ```markdown
   ## What You Asked
   - <concise bullet describing the user's request or goal>

   ## What Was Done
   - <specific file changed or feature built>
   - <another concrete action — function names, route paths, commands run>

   ## What's Remaining
   - <pending work or next step>
   - <another item if applicable>

   ## Blockers
   - <any error, blocker, or open question preventing progress>

   ## Notes
   - <any other informative point worth remembering from this session>
   ```

   Rules for the markdown:
   - Every item is a bullet point (`-`), never a paragraph.
   - Be concrete: name files, functions, routes, commands — not vague descriptions.
   - Omit **What's Remaining**, **Blockers**, and **Notes** entirely if there's nothing to put there.
   - Keep each bullet tight — one fact per bullet.

6. Determine the output directory:
   - If `$DEVBOT_PROJECTS_DIR` is set, write to `$DEVBOT_PROJECTS_DIR/.tmp/summarize-chat/`.
   - Otherwise write to `.tmp/summarize-chat/` relative to the current working directory.
   - Run `mkdir -p <dir>` first, then write the file using the Write tool.
   - Path: `<dir>/$CLAUDE_CODE_SESSION_ID.json`
   - Format — the `summary` value is a JSON string with `\n` for newlines:
     ```json
     {
       "progress": "<value>",
       "summary": "<markdown string with \\n newlines>"
     }
     ```

## Hard Rules

- Do not commit the summary file.
- Do not ask the user for anything.
- Overwrite the file if it already exists (latest state wins).
- Never fabricate work — derive everything from actual git state and this session's context.
- Use the Write tool to write the file so JSON escaping is handled correctly.
