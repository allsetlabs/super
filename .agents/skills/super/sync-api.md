# sync-api — API Reference Docs for Every Backend

Every module that has a backend must have a single API reference document that an AI can read to understand and call its APIs. This operation discovers all backends, extracts the real API surface from code, and updates each doc to match.

## Doc Location Rule

- **Default:** `<module-directory-path>/docs/api.md` inside the module repo (the doc must live with the code so an AI working inside the module can find it).
- **Link it:** the module's `AGENTS.md` must reference the doc (e.g. under `## Architecture`: "API reference: `docs/api.md`"). Add the link if missing.
- **Existing doc wins:** if the module already has a canonical API reference elsewhere (referenced from its `AGENTS.md`, or maintained as a module skill file under `.agents/skills/<module>/`), update that file instead of creating a duplicate.

## Steps

### Step 1: Discover backends

```bash
git submodule status            # canonical module list — never use a hardcoded list
find <category-dirs> -maxdepth 3 -type d \( -name backend -o -name api -o -name server \) -not -path "*/node_modules/*"
```

Also treat a module as having a backend if it contains route definitions (Express/Fastify routers, FastAPI/Flask apps, Next.js `app/api/` or `pages/api/` handlers, Supabase edge functions). Always re-discover — never assume a previous run's backend list.

### Step 2: Extract the API surface (per backend)

Read every route/handler file and extract:

- HTTP method + full path (including router prefix / mount point)
- Query parameters and URL parameters
- Request body fields with types
- Response body shape with all fields
- Validation rules and constraints
- Auth requirements (which routes need a token/session, how it's passed)

If the backend has a database, read migration/schema files and document tables, columns, types, and constraints.

### Step 3: Compare and update the doc

Read the module's existing API doc (or create it if missing). Update if any of these differ:

- **Missing endpoints** — new routes added to any file
- **Missing fields** — new request/response fields on existing endpoints
- **Changed types** — field types or constraints changed
- **DB schema drift** — columns added, types changed, constraints updated
- **Filter/query options** — new filter values or query params
- **Removed endpoints** — routes that no longer exist

For a **new** doc, use this structure:

```markdown
# <Module> API Reference

Base URL, auth, and conventions up top.

## <Resource group>
### METHOD /path
Params / request body / response shape / constraints + one curl example
```

For an **existing** doc, preserve its format and section ordering; update curl examples to use current field names.

### Step 4: Link from AGENTS.md

Verify the module's `AGENTS.md` references the API doc. Add the reference if missing.

## Rules

1. **Read first** — always read route files before touching any doc
2. **Keep format** — preserve existing markdown structure and section ordering
3. **No hardcoded secrets** — never include API keys or env values; use placeholders in curl examples

## Report

```
## API Sync Complete

**Last synced:** [current date in YYYY-MM-DD format]

### Backends found
- [module]: [doc path] (updated | already in sync | created)

### Updated
- [module] → [section]: [what changed]

### Modules without backends (skipped)
- [module]
```
