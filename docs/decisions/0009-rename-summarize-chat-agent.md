# 0009 — Rename session-end agent from `chat-summary` to `summarize-chat`

**Date**: 2026-06-20
**Status**: Accepted

## Context

The super repo's session-end automation includes three agents: `memory`, `decision-records`, and a chat-progress scribe. The chat scribe was originally named `chat-summary` and wrote to `.tmp/chat-summary/`. As the session-end hook responsibilities were consolidated under a single `stop-hook` (see ADR 0008), the agent's naming stood out as inconsistent: it used a noun-first form (`chat-summary`) while its actual behavior is an imperative action (summarize this chat). The name also did not pair naturally with the other session-end agents, which are named after the action they perform (`memory`, `decision-records`, `summarize-chat`).

## Decision

Rename the chat-progress scribe and all of its references from `chat-summary` to `summarize-chat`:

- `.claude/agents/chat-summary.md` → `.claude/agents/summarize-chat.md`
- `.tmp/chat-summary/` → `.tmp/summarize-chat/`
- Update both session-end stop hooks (`.claude/hooks/stop-hook.sh` and `.kimi-code/hooks/stop-hook.sh`) to invoke `summarize-chat` and write to `.tmp/summarize-chat/`.
- Update `AGENTS.md` rule 0 to reference the `summarize-chat` agent.
- Update the devbot backend route that reads the per-session progress JSON to look in `.tmp/summarize-chat/`.
- Update existing ADR 0008 and today's memory entry to use the new name.

## Rationale

The new name uses an imperative verb-object form (`summarize-chat`) that matches what the agent actually does and aligns with the action-oriented naming of the other session-end agents. It also makes the temporary directory and API contract self-describing: `.tmp/summarize-chat/{session_id}.json` clearly indicates both the action and the artifact. Keeping the agent name, file path, and backend reader in sync avoids confusion when debugging session-end flow or adding new consumers of the summary file.

## Consequences

- The rename touched the super repo (`AGENTS.md`, hooks, agent file, ADRs) and the devbot submodule (backend route), so reverting it requires coordinated changes in both places.
- Any existing `.tmp/chat-summary/` files are no longer read by devbot; historical summaries remain on disk but are orphaned unless manually migrated.
- Future session-end agents should follow the same action-oriented naming convention to keep the set consistent.
