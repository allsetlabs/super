# Decision Records

Why the super repo is organized the way it is. One file per decision, newest first.

| #    | Decision                                                                                                                                            | Date       |
| ---- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| 0019 | [Codex hooks live in project-local `.codex/`](0019-codex-hooks-live-in-project-local-dot-codex.md)                                                   | 2026-06-27 |
| 0018 | [Two-tier memory: hot cache + deep `context/` directory](0018-two-tier-memory-context-directory.md)                                                   | 2026-06-27 |
| 0017 | [`index.md` as canonical skill file, `SKILL.md` as symlink](0017-skill-index-md-canonical-with-skill-symlink.md)                                      | 2026-06-27 |
| 0016 | [Super repo made public at github.com/allsetlabs/super](0016-super-repo-made-public.md)                                                              | 2026-06-27 |
| 0015 | [Copilot hooks live in `.copilot-code/`, following the Kimi pattern](0015-copilot-hooks-in-copilot-code-directory.md)                                | 2026-06-27 |
| 0014 | [Progress file-driven scheduler tasks](0014-progress-file-driven-scheduler-tasks.md)                                                                 | 2026-06-20 |
| 0013 | [Hooks as sole trigger for session-end skills](0013-hooks-as-sole-trigger-for-session-end-skills.md)                                                 | 2026-06-20 |
| 0012 | [Session-end tasks as skills, not agents](0012-session-end-tasks-as-skills-not-agents.md)                                                           | 2026-06-20 |
| 0011 | [Inline execution for session-end tasks (memory, decision-records, summarize-chat)](0011-inline-execution-for-session-end-tasks.md)                 | 2026-06-20 |
| 0010 | [Asymmetric stop hook implementations across Claude and Kimi](0010-asymmetric-stop-hook-implementations.md)                                        | 2026-06-20 |
| 0009 | [Rename session-end agent from `chat-summary` to `summarize-chat`](0009-rename-summarize-chat-agent.md)                                             | 2026-06-20 |
| 0008 | [Rename session-end hooks to `stop-hook`](0008-rename-stop-hooks.md)                                                                                | 2026-06-20 |
| 0007 | [All modules nested under a top-level `modules/` directory](0007-modules-top-level-directory.md)                                                    | 2026-06-16 |
| 0006 | [`how-to-organize-module.md` moved into `standards/`, referenced from AGENTS.md's Standards section](0006-how-to-organize-module-into-standards.md) | 2026-06-11 |
| 0005 | [`module-standards-to-follow.md` retired; Makefile standard moved to `standards/`](0005-retire-module-standards-to-follow.md)                       | 2026-06-11 |
| 0004 | [AGENTS.md guidance extracted into a `standards/` directory, with a repo-wide Standards section](0004-standards-directory.md)                       | 2026-06-11 |
| 0003 | [Decision-record format moved to its own reference doc, with a pre-commit check](0003-pre-commit-decision-record-check.md)                          | 2026-06-10 |
| 0002 | [Per-module decision records live in each module's own repo](0002-per-module-decision-records.md)                                                   | 2026-06-10 |
| 0001 | [Module docs and API references live in the super repo, not in modules](0001-docs-live-in-super-repo.md)                                            | 2026-06-10 |
