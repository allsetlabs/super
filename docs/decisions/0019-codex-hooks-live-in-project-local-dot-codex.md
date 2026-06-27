# 0019 — Codex hooks live in project-local `.codex/`

**Date**: 2026-06-27
**Status**: Accepted

## Context

The super repo already mirrored lifecycle hooks across three coding agents:

- Claude via `.claude/settings.json` and `.claude/hooks/`
- Kimi via `.kimi-code/config/hooks.toml` and `.kimi-code/hooks/`
- Copilot via `.copilot-code/config/hooks.toml` and `.copilot-code/hooks/`

Codex also supports lifecycle hooks, but its native discovery model differs: it can load project-local hooks directly from `<repo>/.codex/config.toml` or `<repo>/.codex/hooks.json` when the project is trusted.

## Decision

Store Codex hook configuration in the repo-local `.codex/config.toml` layer, with shell scripts in `.codex/hooks/`.

Mirror the same two hook intents used by the other agents:

- `Stop` continues substantive sessions until the session-end skills have been run.
- `PostToolUse` reminds the agent to run `sync-docs` and `sync-api` after a `git commit`.

## Rationale

- **Use Codex's native project-local mechanism**: unlike Kimi and Copilot, Codex does not need a user-level registration script for repo hooks when the project is trusted.
- **Keep repo policy versioned with the repo**: the hook definitions live next to the workspace they govern.
- **Preserve four-way symmetry of intent**: Claude, Kimi, Copilot, and Codex should all enforce the same operational expectations even though their hook transport differs.

## Consequences

- Future hook changes in this repo must be mirrored across four surfaces, not three: `.claude/`, `.kimi-code/`, `.copilot-code/`, and `.codex/`.
- Codex users must trust the project-local `.codex/` layer for these hooks to run.
- No `setup-codex-hooks.sh` is needed because Codex discovers the repo-local config directly.
