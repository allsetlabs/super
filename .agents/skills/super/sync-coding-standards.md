# sync-coding-standards — Audit and Auto-Fix Standards Across All Modules

Scans every module for violations of the standards defined in the `coding-standards` skill (plus per-module overrides), **auto-fixes every violation it finds**, then reports what was changed per module.

## Steps

### Step 1: Load Standards

1. Load the `coding-standards` skill — it contains the Non-Negotiable Rules, Forbidden Patterns, and the detection/auto-fix instructions for each rule.
2. Read [module-standards-to-follow.md](module-standards-to-follow.md) for the repo-wide module requirements (Makefile targets, AGENTS.md headings, CLAUDE.md symlink).
3. Per module, read its `AGENTS.md`/`CLAUDE.md` for project-specific overrides — module overrides win over the generic skill.

### Step 2: Discover Modules and Workspaces

1. List modules: `git submodule status` from the super repo root — never use a hardcoded list. Skip untracked directories that are not submodules.
2. Within each module, expand workspaces: if its root `package.json` declares `"workspaces"`, expand the globs; otherwise treat subdirectories containing a `package.json` / `pyproject.toml` (e.g. `backend/`, `web/`) as workspaces.
3. Skip `node_modules/`, `dist/`, `build/`, `.git/`, `venv/`, `.next/`, `.turbo/`.

### Step 3: Scan and Fix Each Workspace

For each workspace:

1. Run all detection checks from the `coding-standards` skill.
2. **For every violation found, fix it immediately** — edit the file, update imports, delete barrel files, pin versions, etc.
3. Run `npm run lint -- --fix` and `npm run type-check` for workspaces that have them.
4. Collect a log of what was fixed.

Also verify each module meets [module-standards-to-follow.md](module-standards-to-follow.md): Makefile with `setup`/`install`/`start` targets, `AGENTS.md` with the required headings, `CLAUDE.md` symlink. Fix what's auto-fixable; report the rest.

### Step 4: Report

```
## Coding Standards Audit

**Last audited:** [current date in YYYY-MM-DD format]

### Fixes Applied

#### [module]/[workspace]
- [rule]: [file:line] — [what was changed]

### Clean Modules (no violations found)
- [module]

### Remaining Issues (could not auto-fix)
- [module]: [rule] — [why it needs manual intervention]

### Lint/Type Check Results
- [module]/[workspace]: PASS / FAIL ([error count] errors)
```

## Rules

1. **Scan only source files** — skip the dirs listed in Step 2
2. **Skip component library internals** — the "No native HTML for UI" rule does not apply inside the component library module's own source (that's where the primitives are defined)
3. **Auto-fix everything possible** — only report without fixing if the change is ambiguous and could break functionality; explain why in "Remaining Issues"
4. **Count matters** — report total violation count per rule so severity is clear
5. **Module overrides win** — if a module's `AGENTS.md`/`CLAUDE.md` contradicts a generic rule, follow the module
6. **Fixes are code changes inside module repos** — branch + PR per module (see Shared Rules in SKILL.md); never commit to a module's main
