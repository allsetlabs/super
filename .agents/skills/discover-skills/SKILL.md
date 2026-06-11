---
name: discover-skills
description: Discover public Claude Code skills and improvements for code quality, TypeScript, React, and backend patterns
model: opus
---

# Discover Skills & Improvements

Analyze a module's codebase — routes, apps, components, workers, and utilities — for coding standard improvements, CSS/styling standard improvements, and reusability improvements. Search the web for public Claude Code skills. Report findings and install approved skills.

## CRITICAL RULES

1. **No breaking changes** - Never modify existing code during discovery
2. **Skills go to `.agents/skills/`** - Follow existing skill structure with `SKILL.md`
3. **Report before installing** - Always present findings before adding anything
4. **Web search is required** - This command MUST search the web for public skills
5. **Be specific** - Cite files, line numbers, and exact patterns. No generic advice.

---

## Phase 0: Pick the Target Module

Check `$ARGUMENTS` for `--module <name>`. If not given, ask which module to audit (list valid modules via `git submodule status`). Set `$MODULE` to the module's directory path.

Build context before auditing — do not guess the architecture:

1. Read the module's `AGENTS.md`/`CLAUDE.md` and its docs (`docs/$MODULE/index.md` if synced).
2. Load the module's own skill from `.agents/skills/` if one exists.
3. Glob the module's workspaces (`backend/`, `app/`, `web/`, etc.) to map routes, pages, components, hooks, and libs. Note file sizes — flag any `.tsx` page/component over the 200-line limit.

---

## Phase 1: Deep Codebase Audit

Audit the module across 4 dimensions: coding standards, CSS/styling standards, reusability, and route/app quality. Run the detection checks from the `coding-standards` skill; the greps below are the core set (scope them to `$MODULE/`, exclude `node_modules`).

### 1.1 Coding Standards Audit

```bash
# TypeScript: `any` types and `as any` casts
Grep: ": any\b|as any" in $MODULE/ --include="*.ts" --include="*.tsx"

# TypeScript: non-null assertions (!)
Grep: "\w+!" in $MODULE/ --include="*.ts" --include="*.tsx"

# Console.log left in code
Grep: "console\.log" in $MODULE/*/src/ --include="*.ts" --include="*.tsx"

# TODO/FIXME/HACK
Grep: "TODO|FIXME|HACK|XXX" in $MODULE/*/src/

# Error handling: bare catch blocks (check if they log or swallow errors)
Grep: "catch\s*\(" in $MODULE/ --include="*.ts" --include="*.tsx"

# Magic numbers (hardcoded timeouts, ports, size limits that should be constants)

# Unused imports
# Run: cd $MODULE/<workspace> && npm run lint 2>&1 | grep "unused"

# Backend: every route file has try/catch + proper status codes,
# and every DB query checks for errors
```

### 1.2 CSS & Styling Standards Audit

(Applies when the project defines a palette / component library — see `coding-standards` and `forge` skills.)

```bash
# Default Tailwind colors (FORBIDDEN when a palette exists)
Grep: "bg-blue|bg-red|bg-green|bg-yellow|bg-gray|bg-slate|bg-zinc|text-blue|text-red|text-gray|border-blue|border-red|border-gray" in $MODULE/ --include="*.tsx"

# Arbitrary color values (FORBIDDEN)
Grep: "\[#[0-9a-fA-F]" in $MODULE/ --include="*.tsx"

# Raw HTML elements (FORBIDDEN - must use component library)
Grep: "<button |<input |<select |<textarea |<dialog " in $MODULE/ --include="*.tsx"

# Inline styles (should use Tailwind)
Grep: "style=\{" in $MODULE/ --include="*.tsx"

# dark: prefixes (theme belongs in the component library)
Grep: "dark:" in $MODULE/ --include="*.tsx"

# Repeated className combinations that should be extracted
```

### 1.3 Reusability Audit

This is the most important audit. Look for patterns duplicated across the module's routes and apps.

```bash
# Backend: read ALL route files and identify repeated error handling,
# query, validation, and response-formatting patterns — candidates for
# a reusable CRUD factory/helper

# Backend: compare worker/job files for duplicated spawn/parse/persist logic

# Frontend: find pages that follow the same useQuery + list + modal + CRUD
# shape — could they share a generic list page component?

# Frontend: compare forms for shared validation/layout/state patterns

# Query/mutation consistency
Grep: "queryKey|useMutation|refetchInterval" in $MODULE/ --include="*.tsx" --include="*.ts"

# Component library usage: which shared components are used, which are
# reimplemented locally instead of imported?
```

### 1.4 Route & App Quality Audit

```bash
# Backend: consistent status codes, error response format, parameter
# validation, auth middleware applied consistently, retry/cleanup in workers

# Frontend: every useQuery has loading, error, and empty states
Grep: "isLoading|isPending|isError" in $MODULE/ --include="*.tsx"

# Pages over the 200-line limit (from Phase 0 file-size map):
# suggest specific extraction targets for each
```

### 1.5 Audit Summary Format

After running all checks, produce:

```markdown
## $MODULE Audit Results

### Coding Standards

| Issue       | Severity | Count | Files        | Example       |
| ----------- | -------- | ----- | ------------ | ------------- |
| `any` types | High     | N     | file1, file2 | line:N `code` |

### CSS/Styling Standards

| Issue                   | Severity | Count | Files | Example                    |
| ----------------------- | -------- | ----- | ----- | -------------------------- |
| Default Tailwind colors | Critical | N     | ...   | `bg-blue-500` in file:line |

### Reusability

| Pattern            | Occurrences | Files        | Extraction Target           |
| ------------------ | ----------- | ------------ | --------------------------- |
| CRUD route handler | N           | routes/\*.ts | `createCrudRouter()` helper |

### Route/App Quality

| Issue                  | Severity | Scope    | Fix           |
| ---------------------- | -------- | -------- | ------------- |
| Missing error handling | High     | 3 routes | Add try/catch |

### Pages Over 200-Line Limit

| Page   | Lines | Suggested Extractions |
| ------ | ----- | --------------------- |
| [page] | N     | [component list]      |
```

---

## Phase 2: Search for Public Skills

### 2.1 Claude Code Skills (General)

Use WebSearch for ALL of these:

```
1. "claude code" skills repository github <current year>
2. "claude code" ".claude/commands" OR ".claude/skills" github
3. site:github.com ".claude" skills "SKILL.md"
4. "claude code" custom commands examples community
5. awesome claude code skills github
6. npx skills add claude code
7. anthropic claude code community skills registry
```

### 2.2 Stack-Specific Skills

Derive queries from the module's tech stack mapped in Phase 0. Pattern: `"claude code" <framework/tool> <concern> skill`. Cover each layer:

- Backend framework (route generation, middleware/security audit, error handling)
- Database/ORM (migrations, query optimization)
- Frontend framework (component splitting, performance, data-fetching best practices)
- TypeScript (strict mode, type narrowing, validation)
- Styling (CSS audit, component extraction, design system consistency)
- Platform (mobile/extension/desktop testing and performance, if applicable)
- Code quality (review checklists, lint rules, bundle analysis)

### 2.3 Reusability & Architecture Skills

```
1. "claude code" refactor extract component skill
2. "claude code" dry principle automation skill
3. "claude code" crud factory pattern
4. "claude code" generic list page pattern
5. "claude code" api client generator typescript
```

### 2.4 Check Known Skill Registries

Use WebFetch on:

```
- https://github.com/anthropics/claude-code
- https://github.com/topics/claude-code-skills
- https://github.com/topics/claude-code
- https://www.npmjs.com/search?q=claude-code-skills
```

---

## Phase 3: Evaluate & Categorize

### 3.1 Categories

| Category                  | Description                                                          |
| ------------------------- | -------------------------------------------------------------------- |
| **Installable Skill**     | Public `.claude/skills/` that can be added directly                  |
| **New Command**           | A slash command to create for recurring improvements                 |
| **Coding Standard Skill** | Auto-triggered skill to enforce TypeScript/React standards           |
| **CSS/Styling Skill**     | Auto-triggered skill to enforce Tailwind/component library standards |
| **Reusability Skill**     | Auto-triggered skill to prevent duplication                          |
| **Backend Pattern**       | Reusable backend pattern to extract                                  |
| **Tool/Dependency**       | npm package or CLI tool                                              |

### 3.2 Score (1-5)

| Score | Meaning                                                |
| ----- | ------------------------------------------------------ |
| 5     | **Critical** - Fixes a real problem found in the audit |
| 4     | **High** - Significant daily workflow improvement      |
| 3     | **Medium** - Nice to have, improves quality            |
| 2     | **Low** - Marginal benefit                             |
| 1     | **Skip** - Not relevant                                |

**Only present 3+**

### 3.3 Deduplicate

```bash
ls .claude/commands/
ls .agents/skills/
```

Skip anything we already have.

---

## Phase 4: Present Report

```markdown
## $MODULE Skill Discovery Report

**Date**: [date]
**Workspaces Audited**: [list]
**Web Sources Checked**: [count]

---

### Audit Findings (from Phase 1)

[Full audit summary tables from Phase 1.5]

---

### Installable Skills Found

#### 1. [Name] - [score]/5

- **Source**: [URL]
- **What it does**: [description]
- **Module benefit**: [specific files/routes it helps]
- **Install**: [command]

---

### New Skills to Create

#### 1. [name] - [score]/5

- **Trigger**: [when Claude should auto-use this]
- **What it enforces**: [specific rules]
- **Files it covers**: [scope]

---

### Reusability Extractions

#### 1. [pattern-name] - [score]/5

- **Current duplication**: [N files, N lines]
- **Extraction target**: [new file path]
- **Affected files**: [list]

---

### Code Quality / CSS Fixes

#### 1. [fix-name] - [score]/5

- **Issue**: [from audit]
- **Files**: [count + examples]
- **Fix**: [specific approach]

---

### Summary

| Category           | Count | Top Pick |
| ------------------ | ----- | -------- |
| Installable Skills | N     | [name]   |
| New Skills         | N     | [name]   |
| Reusability        | N     | [name]   |
| Code Quality       | N     | [name]   |
| CSS/Styling        | N     | [name]   |

**Proceed? (yes/no/pick numbers)**
```

**WAIT for user approval before Phase 5.** If running as scheduled task (autonomous), auto-approve items scored 4+ and save report to plans route via `POST /api/plans`.

---

## Phase 5: Install Approved Items

### 5.1 Install External Skills

```bash
# npx installable
npx skills add [skill-name]

# Manual: create in .agents/skills/
mkdir -p .agents/skills/[skill-name]
# Write SKILL.md
```

### 5.2 Create Module-Specific Skills

Module-specific knowledge goes into the module's own skill (`.agents/skills/<module>/`) as a topic file, indexed from its `SKILL.md`. Only create a new standalone skill for cross-module concerns.

### 5.3 Create New Commands

Write to `.claude/commands/[name].md` with YAML frontmatter (`description`, `model`) and a phased structure — only for Claude-mechanics-dependent workflows; otherwise prefer a skill.

### 5.4 Save Findings as Plans

For items that need code changes (reusability extractions, code quality fixes), save each as a plan via the DevBot Plans API:

```bash
curl -X POST http://0.0.0.0:3100/api/plans \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{
    "title": "[fix/extraction name]",
    "description": "[detailed description with files and approach]",
    "route": "[module name]",
    "priority": "high|medium|low",
    "status": "pending"
  }'
```

### 5.5 Update Documentation

- Run: `npm run lint && npm run type-check` if any code changed

---

## Phase 6: Report

```markdown
## Discovery Complete

### Skills Added

| Type    | Name    | Location                     |
| ------- | ------- | ---------------------------- |
| Skill   | [name]  | `.agents/skills/[name]/`     |
| Command | /[name] | `.claude/commands/[name].md` |

### Plans Created (for code changes)

| Plan   | Priority | Route    | Description |
| ------ | -------- | -------- | ----------- |
| [name] | high     | [module] | [summary]   |

### Skipped

- [name]: [reason]

### Next Run

Scheduled runs compare new discoveries against existing plans to avoid duplicates.
```

---

## Options

```bash
/discover-skills --module <name>        # Target module (asked if omitted)
/discover-skills --audit-only           # Only run codebase audit (Phase 1)
/discover-skills --search-only          # Only search web for skills (Phase 2)
/discover-skills --install [name]       # Install a specific previously-found skill
/discover-skills --coding-standards     # Only audit coding standards
/discover-skills --css-standards        # Only audit CSS/styling standards
/discover-skills --reusability          # Only audit reusability
/discover-skills --routes               # Only audit backend routes
```
