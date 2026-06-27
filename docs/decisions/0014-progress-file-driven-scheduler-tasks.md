# 0014 — Progress File-Driven Scheduler Tasks

**Date**: 2026-06-20
**Status**: Accepted

## Context

When building the family tree visualization website, the work was too large to fit in a single devbot scheduler run. The work needed to be broken into ~20 sequential tasks executed one per scheduled run (every 60 minutes, up to 20 runs).

Options considered for tracking which task to run next:
1. **Devbot scheduler prompt alone** — encode the full task list in the prompt and have Claude decide what's done based on filesystem state each run.
2. **Separate API state** — use the devbot plans API or a custom DB record to track task completion.
3. **Markdown progress file in the project repo** — a `PROGRESS.md` file in the project directory where each task is listed as `[PENDING]` or `[COMPLETED YYYY-MM-DD HH:MM]`, read and updated by each scheduler run.

## Decision

Use a **PROGRESS.md file in the project repository** as the state machine. Each scheduler run:
1. Reads PROGRESS.md
2. Finds the first `[PENDING]` task
3. Executes exactly that one task
4. Marks it `[COMPLETED timestamp]`
5. Stops

The file lives at `.tmp/family-tree/PROGRESS.md` and becomes part of the project's git history once the repo is pushed to GitHub.

## Rationale

- **Human-readable**: The file doubles as progress documentation viewable without API calls or DB queries.
- **Git-tracked**: Task completion history is recorded in git commits, making progress auditable.
- **Self-contained**: The scheduler prompt is stable (never changes); only the PROGRESS.md file changes. This means the scheduler needs no updates as tasks complete.
- **Debuggable**: If a run fails mid-task, the `[PENDING]` marker remains and the next run retries cleanly.
- **Decoupled from devbot DB**: The family tree project is a standalone repo; tying its progress to the devbot scheduler DB would create an external dependency on a local service.

The alternative of encoding state in filesystem presence (e.g., "check if family.json exists") was rejected because it makes the prompt fragile — it must know each task's exact output artifact, and partial completions are ambiguous.

## Consequences

- Each scheduler run must read and write PROGRESS.md reliably; if a run crashes after doing work but before updating the file, the task will be re-run on the next schedule (idempotency matters for each task).
- The progress file becomes the authoritative source of truth for task state — the devbot scheduler's `runCount` / `lastRunAt` only tells how many times it fired, not what was actually accomplished.
- This pattern is reusable: any long-running project managed by devbot schedulers can adopt a PROGRESS.md state machine with the same `[PENDING]` / `[COMPLETED]` conventions.
