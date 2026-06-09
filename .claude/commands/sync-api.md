# Sync DevBot Backend API Skill

Reads all backend route files and updates the `devbot-backend` skill to match the current API.

## Steps

### Step 1: Read all route files

```bash
ls modules/devbot/backend/src/routes/*.ts
```

Read every route file in `modules/devbot/backend/src/routes/` and extract:

- HTTP method + full path (including router prefix)
- Query parameters and URL parameters
- Request body fields with types
- Response body shape with all fields
- Validation rules and constraints

### Step 2: Read current skill

Read `.agents/skills/devbot-backend/skill.md`

### Step 3: Compare and update

Compare extracted endpoints against the skill file. Update the skill if any of these differ:

- **Missing endpoints** — new routes added to any file
- **Missing fields** — new request/response fields on existing endpoints
- **Changed types** — field types or constraints changed
- **DB schema drift** — columns added, types changed, constraints updated
- **Filter/query options** — new filter values or query params
- **Removed endpoints** — routes that no longer exist

Preserve the existing format and section structure. Update curl examples to use current field names.

### Step 4: Verify DB schema

Read all migration files to confirm the skill's DB schema tables match:

```bash
ls modules/devbot/supabase/migrations/*.sql
```

Cross-check column names, types, and constraints against what's documented.

## Rules

1. **Read first** — always read route files before touching the skill
2. **Minimal changes** — only update what actually differs
3. **Keep format** — preserve existing markdown structure and section ordering
4. **No hardcoded secrets** — never include API keys or env values

## Report

After completion, output:

```
## API Sync Complete

**Last synced:** [current date in YYYY-MM-DD format]

### Updated
- [section]: [what changed]

### Already in sync
- [section]
```
