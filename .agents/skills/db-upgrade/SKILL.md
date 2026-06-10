---
name: db-upgrade
description: Apply pending Supabase migrations to the local DevBot database without resetting or losing data.
---

# DevBot Database Upgrade

Apply pending Supabase migrations to the local DevBot database **without resetting or losing existing data**.

## Instructions

### 1. Check current migration status

```bash
cd modules/devbot && supabase migration list
```

Review the output. Migrations marked as `Applied` are already in the database. Only `Not Applied` migrations will be run.

### 2. Apply pending migrations

```bash
cd modules/devbot && supabase db push
```

`supabase db push` applies **only** unapplied migrations in order. It does NOT reset the database or drop existing tables/data. This is the safe upgrade path.

### 3. Verify the upgrade

```bash
cd modules/devbot && supabase migration list
```

Confirm all migrations now show as `Applied`.

### 4. Validate schema

Connect to the database and verify the new tables/columns exist:

```bash
psql postgresql://postgres:postgres@127.0.0.1:54422/postgres -c "\dt public.*"
```

Report the results to the user: which migrations were applied and what schema changes were made.

## Important: NEVER use `supabase db reset`

`supabase db reset` **destroys all data** — it drops the entire database and recreates it from scratch by replaying all migrations. Only use this if you explicitly want a fresh database.

| Command                   | Effect                                 | Data Loss |
| ------------------------- | -------------------------------------- | --------- |
| `supabase db push`        | Apply only pending migrations          | **No**    |
| `supabase migration list` | Show applied vs pending migrations     | **No**    |
| `supabase db reset`       | Drop everything, replay all migrations | **Yes**   |
| `supabase db diff`        | Generate migration from schema changes | **No**    |

## Creating New Migrations

When adding new tables or altering existing schema:

```bash
cd modules/devbot && supabase migration new <descriptive_name>
```

This creates a new timestamped file in `modules/devbot/supabase/migrations/`. Write your SQL there, then run `supabase db push` to apply it.

### Migration naming convention

Files follow the pattern `YYYYMMDDHHMMSS_description.sql`. The Supabase CLI generates the timestamp automatically.

### Writing safe migrations

- Use `IF NOT EXISTS` for `CREATE TABLE` to make migrations idempotent
- Use `ALTER TABLE ... ADD COLUMN IF NOT EXISTS` for new columns
- Never use `DROP TABLE` without confirming with the user first
- Add `ON DELETE CASCADE` to foreign keys for cleanup
- Use `CHECK` constraints for enum-like columns

### Example: Adding a column to an existing table

```sql
ALTER TABLE interactive_chats
ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ DEFAULT NULL;
```

## Troubleshooting

### Migration fails mid-way

If a migration partially applies and fails, fix the SQL, then:

```bash
cd modules/devbot && supabase db push
```

If the migration is stuck (already marked applied but schema is wrong), you may need to manually repair:

```bash
# Check what's in the migration history table
psql postgresql://postgres:postgres@127.0.0.1:54422/postgres \
  -c "SELECT * FROM supabase_migrations.schema_migrations ORDER BY version;"
```

### Supabase is not running

```bash
cd modules/devbot && supabase start
```

Then retry the upgrade.

## Reference

- **Migrations dir:** `modules/devbot/supabase/migrations/`
- **Config:** `modules/devbot/supabase/config.toml`
- **DB port:** `54422` (PostgreSQL)
- **API port:** `54421`
- **Studio:** `http://127.0.0.1:54423`
