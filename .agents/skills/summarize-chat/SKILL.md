---
name: summarize-chat
description: Progress scribe for Claude Code sessions. At session end, checks what changed and writes .tmp/summarize-chat/{CLAUDE_CODE_SESSION_ID}.json with progress and a structured markdown summary. Runs autonomously — no approval needed.
---

# Summarize Chat Skill

**Role**: Write a progress JSON file for the current chat session so devbot can display status.
**Scope**: Writes `.tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json`. Always runs — `CLAUDE_CODE_SESSION_ID` is set by Claude Code in every session.

## Context vs. Git State

You are always invoked with a **context block** describing what happened in the session. **Trust that context first.** Only run git commands to fill gaps the context doesn't cover.

- If the context says "committed and pushed" → `progress = done`. Do not run git to verify.
- If the context says "PR #N was opened" → `progress = pr #N`. Do not run `gh pr view`.
- If the context says "changes are staged but not committed" → `progress = dirty`.
- Only run git commands when the context is ambiguous or silent about the final state.

## Steps

1. Get the session ID and working directory:

   ```bash
   echo "$CLAUDE_CODE_SESSION_ID"
   pwd
   ```

2. **Only if the context does not clearly state the final git state**, check:

   ```bash
   git status --short
   git log --oneline origin/HEAD..HEAD 2>/dev/null || true
   ```

   Do NOT run `gh pr list` or `gh pr view` unless the context explicitly mentions a PR was opened this session.

3. **Exclusive scope rule** — determine which changes count:
   - If any changed files are inside `modules/` subdirectories, scope only to those module(s). Ignore super-repo-level changes (top-level `docs/`, `AGENTS.md`, submodule pointer changes, etc.).
   - If all changed files are at the super-repo level (no `modules/` paths), scope to the super repo only.
   - Never mix module changes with super-repo-level changes in the same assessment.

4. Determine the `progress` value — **prefer context over git commands**:
   - **`done`** — context says committed and pushed, OR git confirms nothing unpushed.
   - **`pr #<number>`** — context explicitly says a PR was opened this session with that number. Never infer a PR from `gh pr list`; only use a PR number the caller gave you.
   - **`dirty`** — context says staged/uncommitted, or git shows uncommitted/unpushed changes.
   - **`question`** — the session ended with a direct question to the user.
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
- Never fabricate work — base everything on the context you were given and git state only when needed.
- Use the Write tool to write the file so JSON escaping is handled correctly.
