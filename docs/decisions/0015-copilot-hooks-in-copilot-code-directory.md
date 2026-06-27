# 0015 — Copilot hooks live in `.copilot-code/`, following the Kimi pattern

**Date**: 2026-06-27
**Status**: Accepted

## Context

GitHub Copilot coding agent supports lifecycle hooks. GitHub's own convention places these in `.github/copilot-hooks/`. The super repo already has two hook sets: `.claude/hooks/` (Claude Code) and `.kimi-code/hooks/` (Kimi Code), each with its own registration mechanism. We needed to add equivalent Copilot hooks that trigger the same session-end skills (memory, decision-records, summarize-chat) and the post-commit sync (sync-docs, sync-api).

## Decision

Store Copilot hooks under `.copilot-code/hooks/` rather than `.github/copilot-hooks/`, and model the implementation on Kimi's pattern: shell scripts that emit plain text and exit with code 2 to inject feedback into the model.

Alongside the scripts, add `.copilot-code/config/hooks.toml` and `setup-copilot-hooks.sh` to mirror the Kimi registration mechanism exactly.

## Rationale

- **Consistency over GitHub convention**: The repo's two existing hook sets each live in a platform-named dot-directory (`.claude/`, `.kimi-code/`). Placing Copilot hooks in `.copilot-code/` makes the pattern immediately recognizable and searchable, whereas `.github/copilot-hooks/` would break the visual symmetry and mix platform config into the `.github/` directory (already used for CI and PR templates).
- **Kimi over Claude implementation**: Claude's hook uses a block/continue JSON protocol specific to Claude Code. Kimi's uses plain stdout + exit 2, which is more portable and easier to read. Copilot's feedback mechanism is closer to Kimi's, making that a lower-risk template.
- **AGENTS.md hook-sync rule extended**: The existing rule already mandated mirroring hooks across Claude and Kimi; extending it to Copilot keeps all three in sync without introducing a new process.

## Consequences

- Engineers looking for Copilot hooks in `.github/` will not find them — the `.copilot-code/` location must be documented in AGENTS.md (done).
- Any future Copilot hook additions must follow the same exit-2 / plain-text pattern and be registered in `.copilot-code/config/hooks.toml`.
- If GitHub changes its official hooks directory convention, migration is straightforward: move scripts and update the TOML.
