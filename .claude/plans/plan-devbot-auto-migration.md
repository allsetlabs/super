# Plan: DevBot Auto-Migration on Startup

## Problem

When a user pulls many commits containing new Supabase migration files, `supabase start` (via `make run-d`) does NOT apply pending migrations to an already-running database. The user must manually run `supabase db reset` or `supabase db push` — which they likely won't know to do.

## Research: How Other Projects Handle This

### MoltBot / OpenClaw

- **`doctor` command** — a "safe boring" command that runs on demand to repair services, apply config migrations, and warn about mismatches
- **Auto-migrates legacy state/config paths** on startup — keeps config resolution consistent across legacy filenames
- **Cron store migration hardening** — handles legacy field migration, parse error handling, and explicit delivery mode persistence
- **Hard-migrate strategy** — for isolated jobs, forcefully migrates deprecated fields and drops legacy ones
- **File-based state migrations** — detects legacy JSON files, migrates data into new store, renames originals with `.migrated` suffix
- **Key takeaway**: Migration is semi-automatic via the `doctor` command after updates, NOT fully automatic on every startup

Sources:

- [MoltBot Migrating Docs](https://docs.openclaw.ai/install/migrating)
- [MoltBot Changelog](https://github.com/moltbot/moltbot/blob/main/CHANGELOG.md)

### NanoClaw

- Uses **SQLite** with `better-sqlite3`
- **`initDatabase()` runs on every startup** — creates tables with `CREATE TABLE IF NOT EXISTS`
- **Inline column migrations** — checks if columns exist, adds missing ones (e.g., `sender_name`, `context_mode`, `requires_trigger`)
- **JSON-to-DB migration** — detects legacy `.json` files, imports data into SQLite tables, renames source files to `.migrated`
- **No versioning table** — relies on idempotent `IF NOT EXISTS` and `ALTER TABLE ADD COLUMN` checks
- **Key takeaway**: Fully automatic on every startup — dead simple, works because SQLite is embedded and schema is small

Sources:

- [NanoClaw Repository](https://github.com/gavrielc/nanoclaw)
- [NanoClaw DeepWiki](https://deepwiki.com/gavrielc/nanoclaw/10-reference)

### NanoBot (HKUDS)

- **No database at all** — uses file-based persistence (JSONL for sessions, Markdown for memory)
- Config in `~/.nanobot/config.json`, memory in `memory/` directory
- Sessions are in-memory only, conversation history persisted to markdown files
- **No migration system needed** — schema-less by design
- **Key takeaway**: Avoids the problem entirely by not using a database

Sources:

- [NanoBot Repository](https://github.com/HKUDS/nanobot)

---

## Comparison Matrix

| Feature                 | MoltBot              | NanoClaw           | NanoBot     | DevBot (Current)          |
| ----------------------- | -------------------- | ------------------ | ----------- | ------------------------- |
| Database                | Varies (stores)      | SQLite             | File-based  | PostgreSQL (Supabase)     |
| Auto-migrate on startup | No (manual `doctor`) | Yes (initDatabase) | N/A         | No                        |
| Migration approach      | Doctor command       | Inline DDL checks  | None needed | Supabase CLI (manual)     |
| Version tracking        | Internal             | None (idempotent)  | None        | supabase_migrations table |
| Legacy data migration   | `.migrated` suffix   | `.migrated` suffix | N/A         | None                      |

---

## Recommended Approach for DevBot

### Strategy: Hybrid (NanoClaw's auto-detect + MoltBot's safety)

Add a **migration check on backend startup** that detects pending Supabase migrations and either auto-applies them or warns the user.

### Implementation Plan

#### Phase 1: Migration Detection Script

Create a startup utility in the backend that:

1. **Reads the `migrations/` directory** — gets all `.sql` filenames
2. **Queries `supabase_migrations.schema_migrations`** — gets already-applied migrations
3. **Compares** — identifies pending migrations
4. **Takes action**:
   - If 0 pending: proceed normally
   - If pending migrations found: auto-apply via `supabase db push` (or warn + exit)

```
File: modules/devbot/backend/src/lib/migration-check.ts
```

#### Phase 2: Integrate into Backend Startup

In `modules/devbot/backend/src/index.ts`, add migration check as the **first thing** before route setup:

```typescript
// Before anything else
const pending = await checkPendingMigrations();
if (pending.length > 0) {
  console.log(`Found ${pending.length} pending migrations. Applying...`);
  await applyMigrations(); // runs: supabase db push
  console.log('Migrations applied successfully.');
}

// Then continue with normal startup...
```

#### Phase 3: Makefile Integration

Update `make run-d` to run migration check before starting the backend:

```makefile
run-d:
	cd modules/devbot && supabase start
	cd modules/devbot && supabase db push  # <-- NEW: apply pending migrations
	# ... start backend and mobile
```

This is the simpler, more reliable approach — doesn't require Node.js code, just a Makefile change.

#### Phase 4 (Optional): Doctor-Style Command

Add a `make doctor-d` command inspired by MoltBot:

```makefile
doctor-d:
	@echo "Running DevBot doctor..."
	cd modules/devbot && supabase db push
	@echo "Checking backend health..."
	curl -s http://0.0.0.0:3100/api/health || echo "Backend not running"
	@echo "Doctor complete."
```

---

## Simplest Solution (Recommended)

**Just add `supabase db push` to `make run-d` after `supabase start`.**

This is what NanoClaw effectively does (run migrations every startup), but using Supabase's built-in tooling. It's:

- **Idempotent** — `db push` only applies pending migrations, does nothing if up-to-date
- **Zero code changes** — only a Makefile edit
- **Safe** — won't drop data, only applies forward migrations
- **Solves the 100-commit pull problem** — user just runs `make run-d` as usual

### One-Line Fix

```makefile
# In the run-dsb or run-d target, after supabase start:
cd modules/devbot && supabase start && supabase db push
```

---

## Decision Needed

| Option                         | Effort       | Safety            | Covers the Problem     |
| ------------------------------ | ------------ | ----------------- | ---------------------- |
| **A: Makefile `db push`**      | 1 line       | High (idempotent) | Yes                    |
| **B: Backend migration check** | ~50 lines TS | Medium            | Yes + logging          |
| **C: `make doctor-d` command** | ~10 lines    | High              | Only if user remembers |
| **D: A + C combined**          | ~11 lines    | High              | Full coverage          |

**Recommendation: Option D** — auto-apply in `make run-d` + a `doctor-d` escape hatch.
