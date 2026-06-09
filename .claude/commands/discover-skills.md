---
description: Discover public Claude Code skills and improvements for code quality, TypeScript, React, and backend patterns
model: opus
---

# Discover Skills & Improvements

Analyze the DevBot codebase — all routes, apps, components, workers, and utilities — for coding standard improvements, CSS/styling standard improvements, and reusability improvements. Search the web for public Claude Code skills. Report findings and install approved skills.

## CRITICAL RULES

1. **No breaking changes** - Never modify existing code during discovery
2. **Skills go to `.agents/skills/`** - Follow existing skill structure with `SKILL.md`
3. **Report before installing** - Always present findings before adding anything
4. **Web search is required** - This command MUST search the web for public skills
5. **Be specific** - Cite files, line numbers, and exact patterns. No generic advice.

---

## DevBot Architecture Reference

Use this as context when auditing. Do NOT re-discover this — it's already known.

### Backend (`modules/devbot/backend/`)

**Tech:** Express 4.21 + TypeScript + Supabase + node-pty + ws + multer
**Build:** vite-node --watch

| Route File            | Base Path                | Endpoints                                                                                                                                                                       | Purpose                                    |
| --------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `sessions.ts`         | `/api/sessions`          | GET / GET :id / POST / DELETE :id / POST :id/rename                                                                                                                             | Terminal sessions (tmux + xterm WebSocket) |
| `schedulers.ts`       | `/api/schedulers`        | GET / GET :id / POST / PUT :id / DELETE :id / GET :id/runs / GET :id/latest-run / GET :id/runs/:runId / GET :id/runs/:runId/messages                                            | Recurring Claude Code task scheduler       |
| `interactive-chat.ts` | `/api/interactive-chats` | GET / GET /archived / GET :id / POST / DELETE :id / POST :id/send / POST :id/stop / GET :id/status / GET :id/messages / POST :id/rename / POST :id/archive / POST :id/unarchive | Interactive Claude chat                    |
| `plans.ts`            | `/api/plans`             | GET / GET /count / GET :id / POST / PUT :id / DELETE :id                                                                                                                        | Module improvement plans                   |
| `baby-profiles.ts`    | `/api/baby-profiles`     | GET / GET :id / POST / PATCH :id / DELETE :id                                                                                                                                   | Baby profile CRUD                          |
| `baby-logs.ts`        | `/api/baby-logs`         | GET (paginated, type filter) / GET :id / POST / PATCH :id / DELETE :id                                                                                                          | Baby log tracking                          |
| `birth-times.ts`      | `/api/birth-times`       | GET / POST / PATCH :id / DELETE :id                                                                                                                                             | Birth time entries                         |
| `lawn-profiles.ts`    | `/api/lawn-profiles`     | GET / GET :id / POST / PATCH :id / DELETE :id                                                                                                                                   | Lawn profile CRUD                          |
| `lawn-plans.ts`       | `/api/lawn-plans`        | GET / GET :id / GET :id/status / POST /generate / DELETE :id                                                                                                                    | Lawn care plan generation                  |
| `remotion-videos.ts`  | `/api/remotion-videos`   | GET / GET :id / POST / PATCH :id / DELETE :id / GET :id/stream                                                                                                                  | Remotion video records                     |
| `upload.ts`           | `/api/upload`            | POST /                                                                                                                                                                          | File upload (multer, 20MB)                 |
| `logs.ts`             | `/api/logs`              | GET / DELETE /                                                                                                                                                                  | Tail/clear backend/frontend logs           |

**Workers (lib/):**

| File                         | Lines | Purpose                                                                |
| ---------------------------- | ----- | ---------------------------------------------------------------------- |
| `scheduler-worker.ts`        | 417   | FCFS queue, spawns Claude CLI for scheduled tasks, stream-json parsing |
| `interactive-chat-worker.ts` | 395   | Spawns Claude CLI for interactive chats, auto-names chats              |
| `lawn-plan-worker.ts`        | 290   | Generates lawn plans via interactive chat + JSON extraction            |
| `stream-parser.ts`           | 106   | Parses Claude stream-json output into DB messages                      |
| `supabase.ts`                | 186   | Client + 13 TypeScript interfaces for all DB row types                 |
| `tmux.ts`                    | 75    | Create/kill/list tmux sessions                                         |
| `xterm-ws.ts`                | 144   | WebSocket server for xterm terminal emulation                          |
| `session-recovery.ts`        | 76    | Restarts xterm WS servers on backend startup                           |

### Mobile (`modules/devbot/app/`)

**Tech:** React 19 + Vite + TypeScript + TanStack Query + TanStack Virtual + Tailwind 3.4 + Capacitor 6 + xterm.js 5.5
**UI:** `@subbiah/reusable` shared component library (custom colors, no default Tailwind)

**Pages (13 files, ~7,375 lines):**

| Page                      | Lines | Purpose                         | Known Issues            |
| ------------------------- | ----- | ------------------------------- | ----------------------- |
| `BabyLogs.tsx`            | 2,323 | Baby log tracking + CRUD        | WAY over 200-line limit |
| `BabyAnalytics.tsx`       | 1,203 | Baby metrics dashboards         | WAY over 200-line limit |
| `LawnCare.tsx`            | 821   | Lawn profiles + plan generation | WAY over 200-line limit |
| `EventsTimer.tsx`         | 500   | Events/timers                   | Over 200-line limit     |
| `InteractiveChatView.tsx` | 497   | Chat with Claude                | Over 200-line limit     |
| `PlansPage.tsx`           | 419   | Module plans management         | Over 200-line limit     |
| `InteractiveChatList.tsx` | 341   | Active/archived chat list       | Over 200-line limit     |
| `RemotionVideos.tsx`      | 324   | Video records + streaming       | Over 200-line limit     |
| `SchedulerView.tsx`       | 263   | Task detail + run messages      | Over 200-line limit     |
| `ChatView.tsx`            | 243   | Terminal session view           | Over 200-line limit     |
| `SchedulerList.tsx`       | 180   | Task list                       | OK                      |
| `LogsPage.tsx`            | 135   | Log viewer                      | OK                      |
| `ChatList.tsx`            | 126   | Session list                    | OK                      |

**Components (14 files, ~2,025 lines):**

| Component                     | Lines | Purpose                                |
| ----------------------------- | ----- | -------------------------------------- |
| `BabyProfileDrawer.tsx`       | 333   | Baby profile form                      |
| `ChatMessage.tsx`             | 251   | Message renderer (user/assistant/tool) |
| `SchedulerSettingsDrawer.tsx` | 203   | Edit task settings                     |
| `SchedulerForm.tsx`           | 191   | Create task modal                      |
| `MarkdownRenderer.tsx`        | 143   | Markdown with syntax highlighting      |
| `SchedulerItem.tsx`           | 139   | Task list item                         |
| `XtermTerminal.tsx`           | 118   | Terminal emulator                      |
| `SlideNav.tsx`                | 115   | Sidebar navigation                     |
| `TextSelectionProvider.tsx`   | 104   | Text selection context                 |
| `MessageList.tsx`             | 100   | Virtual scrolling messages             |
| `RunSelector.tsx`             | 94    | Run dropdown selector                  |
| `ScrollControl.tsx`           | 88    | Terminal scroll buttons                |
| `KeyBar.tsx`                  | 85    | Keyboard shortcut buttons              |
| `ChatItem.tsx`                | 61    | Chat list item                         |

**Hooks (2 files):** `useXtermWs.ts` (275 lines), `useDragAndDrop.ts` (45 lines)
**Libs (4 files):** `api.ts` (459 lines), `clipboard.ts` (18 lines), `format.ts` (10 lines), `constants.ts` (7 lines)

---

## Phase 1: Deep Codebase Audit

Audit the DevBot module across 4 dimensions: coding standards, CSS/styling standards, reusability, and route/app quality.

### 1.1 Coding Standards Audit

```bash
# TypeScript: Find `any` types
Grep: ": any\b" in modules/devbot/ --include="*.ts" --include="*.tsx" (exclude node_modules)

# TypeScript: Find `as any` casts
Grep: "as any" in modules/devbot/ --include="*.ts" --include="*.tsx"

# TypeScript: Find non-null assertions (!)
Grep: "\w+!" in modules/devbot/ --include="*.ts" --include="*.tsx"

# TypeScript: Find missing return types on exported functions
Grep: "export (const|function) \w+ = " in modules/devbot/ --include="*.ts"

# Console.log left in code
Grep: "console\.log" in modules/devbot/*/src/ --include="*.ts" --include="*.tsx"

# TODO/FIXME/HACK
Grep: "TODO|FIXME|HACK|XXX" in modules/devbot/*/src/

# Error handling: bare catch blocks
Grep: "catch\s*\(" in modules/devbot/ --include="*.ts" --include="*.tsx"
# Then check if they log or swallow errors

# Magic numbers/strings (hardcoded values that should be constants)
Grep: "1500|5000|30000|7750|7799|20971520" in modules/devbot/ --include="*.ts"

# Unused imports (check after reading files)
# Run: cd modules/devbot/app && npm run lint 2>&1 | grep "unused"

# Backend: Check if all routes have consistent error handling
# Read each route file and verify try/catch + proper status codes

# Backend: Check if all Supabase queries check for errors
Grep: "\.from\(" in modules/devbot/backend/src/ --include="*.ts"
# Then verify each has error checking
```

### 1.2 CSS & Styling Standards Audit

```bash
# Find any default Tailwind colors (FORBIDDEN)
Grep: "bg-blue|bg-red|bg-green|bg-yellow|bg-gray|bg-slate|bg-zinc|bg-stone|bg-orange|bg-amber|bg-lime|bg-emerald|bg-teal|bg-cyan|bg-sky|bg-indigo|bg-violet|bg-purple|bg-fuchsia|bg-pink|bg-rose" in modules/devbot/app/src/ --include="*.tsx"

Grep: "text-blue|text-red|text-green|text-yellow|text-gray|text-slate|text-zinc" in modules/devbot/app/src/ --include="*.tsx"

Grep: "border-blue|border-red|border-green|border-gray|border-slate" in modules/devbot/app/src/ --include="*.tsx"

# Find arbitrary color values (FORBIDDEN)
Grep: "\[#[0-9a-fA-F]" in modules/devbot/app/src/ --include="*.tsx"

# Find raw HTML elements (FORBIDDEN - must use component library)
Grep: "<button |<input |<select |<textarea |<dialog " in modules/devbot/app/src/ --include="*.tsx"

# Find inline styles (should use Tailwind)
Grep: "style=\{" in modules/devbot/app/src/ --include="*.tsx"

# Find inconsistent spacing patterns
Grep: "p-[0-9]|px-[0-9]|py-[0-9]|m-[0-9]|mx-[0-9]|my-[0-9]|gap-[0-9]" in modules/devbot/app/src/ --include="*.tsx"
# Check for consistency: are similar components using similar spacing?

# Find duplicate className strings across files
Grep: "className=\"" in modules/devbot/app/src/ --include="*.tsx"
# Look for repeated class combinations that should be extracted

# Find dark: prefixes (theme should be handled by component library)
Grep: "dark:" in modules/devbot/app/src/ --include="*.tsx"

# Check if Tailwind config extends shared config correctly
Read: modules/devbot/app/tailwind.config.js
```

### 1.3 Reusability Audit

This is the most important audit. Look for patterns duplicated across DevBot's routes and apps.

```bash
# Backend: Find repeated CRUD patterns across routes
# Read ALL 12 route files and identify:
# - Identical error handling patterns
# - Repeated Supabase query patterns (select/insert/update/delete)
# - Repeated request validation patterns
# - Repeated response formatting

# Specifically check for a reusable CRUD factory:
# Many routes do: router.get('/', ...) -> supabase.from(table).select() -> res.json()
# This pattern repeats across baby-profiles, baby-logs, birth-times, lawn-profiles, lawn-plans, remotion-videos, plans

# Backend: Find repeated worker patterns
# scheduler-worker.ts and interactive-chat-worker.ts both:
# - Spawn Claude CLI processes
# - Parse stream-json output
# - Save messages to DB
# - Track execution state
# Check how much is shared vs duplicated

# Mobile: Find repeated page patterns
# Many pages follow: useQuery + list + create modal + delete + edit
# Check: InteractiveChatList, SchedulerList, ChatList, PlansPage
# Could these share a generic list page component?

# Mobile: Find repeated form patterns
# SchedulerForm, BabyProfileDrawer, SchedulerSettingsDrawer
# Do they share validation, layout, or state management patterns?

# Mobile: Find repeated API patterns
# Read api.ts - are there repeated fetch/error/parse patterns?
# Could a generic API helper reduce the 459-line api.ts?

# Mobile: Find repeated query key patterns
Grep: "queryKey" in modules/devbot/app/src/ --include="*.tsx" --include="*.ts"

# Mobile: Find repeated polling patterns
Grep: "refetchInterval" in modules/devbot/app/src/ --include="*.tsx"
# Are all polling intervals consistent? Are they configurable?

# Mobile: Find repeated mutation patterns
Grep: "useMutation" in modules/devbot/app/src/ --include="*.tsx"
# How many mutations? Are invalidation patterns consistent?

# Cross-module: Check component library usage
Grep: "from '@subbiah/reusable'" in modules/devbot/app/src/ --include="*.tsx"
# Which components are used? Which are available but not used?

# Check for components that exist in component library but are reimplemented locally
Grep: "import.*Button|import.*Dialog|import.*Input|import.*Select|import.*Textarea|import.*Drawer" in modules/devbot/app/src/ --include="*.tsx"
```

### 1.4 Route & App Quality Audit

```bash
# Backend: Check API consistency
# For each route file, verify:
# - Consistent HTTP status codes (201 for create, 200 for update, etc.)
# - Consistent error response format ({ error: string })
# - Consistent use of try/catch
# - Consistent parameter validation
# - Consistent naming (camelCase vs snake_case in responses)

# Backend: Check for missing middleware
# - Is there rate limiting?
# - Is there request logging?
# - Is there input sanitization?
# - Is auth (X-API-Key) applied consistently?

# Backend: Check worker robustness
# - Do workers handle crashes gracefully?
# - Is there retry logic?
# - Are there memory leaks (event listener cleanup)?
# - Do workers log errors consistently?

# Mobile: Check for missing loading states
Grep: "isLoading|isPending" in modules/devbot/app/src/pages/ --include="*.tsx"
# Every useQuery should have a loading state

# Mobile: Check for missing error states
Grep: "isError|error" in modules/devbot/app/src/pages/ --include="*.tsx"
# Every useQuery should have an error state

# Mobile: Check for missing empty states
# When a list is empty, is there a user-friendly message?

# Mobile: Check for oversized pages (200-line rule)
# Already known from architecture reference above - flag all pages > 200 lines
# Suggest specific extraction targets for each

# Mobile: Check for missing TypeScript interfaces
# Are API response types defined? Or using `any`?
Grep: "as \w+\[\]|as \w+Row" in modules/devbot/app/src/ --include="*.tsx"
```

### 1.5 Audit Summary Format

After running all checks, produce:

```markdown
## DevBot Audit Results

### Coding Standards

| Issue       | Severity | Count | Files        | Example       |
| ----------- | -------- | ----- | ------------ | ------------- |
| `any` types | High     | N     | file1, file2 | line:N `code` |
| console.log | Medium   | N     | ...          | ...           |
| ...         | ...      | ...   | ...          | ...           |

### CSS/Styling Standards

| Issue                   | Severity | Count | Files | Example                    |
| ----------------------- | -------- | ----- | ----- | -------------------------- |
| Default Tailwind colors | Critical | N     | ...   | `bg-blue-500` in file:line |
| Raw HTML elements       | Critical | N     | ...   | `<button>` in file:line    |
| ...                     | ...      | ...   | ...   | ...                        |

### Reusability

| Pattern            | Occurrences | Files        | Extraction Target           |
| ------------------ | ----------- | ------------ | --------------------------- |
| CRUD route handler | N           | routes/\*.ts | `createCrudRouter()` helper |
| Polling useQuery   | N           | pages/\*.tsx | `usePollingQuery()` hook    |
| ...                | ...         | ...          | ...                         |

### Route/App Quality

| Issue                     | Severity | Scope    | Fix           |
| ------------------------- | -------- | -------- | ------------- |
| Missing error handling    | High     | 3 routes | Add try/catch |
| Inconsistent status codes | Medium   | ...      | Standardize   |
| ...                       | ...      | ...      | ...           |

### Pages Over 200-Line Limit

| Page              | Lines | Suggested Extractions                                                                             |
| ----------------- | ----- | ------------------------------------------------------------------------------------------------- |
| BabyLogs.tsx      | 2,323 | Split into BabyLogList, BabyLogForm, BabyLogFilters, BabyDiaperLog, BabyFeedingLog, BabyGrowthLog |
| BabyAnalytics.tsx | 1,203 | Split into FeedingAnalytics, DiaperAnalytics, GrowthAnalytics, AnalyticsSummary                   |
| LawnCare.tsx      | 821   | Split into LawnProfileList, LawnPlanView, LawnPlanGenerator                                       |
| ...               | ...   | ...                                                                                               |
```

---

## Phase 2: Search for Public Skills

### 2.1 Claude Code Skills (General)

Use WebSearch for ALL of these:

```
1. "claude code" skills repository github 2025 2026
2. "claude code" ".claude/commands" OR ".claude/skills" github
3. site:github.com ".claude" skills "SKILL.md"
4. "claude code" custom commands examples community
5. awesome claude code skills github
6. npx skills add claude code
7. anthropic claude code community skills registry
```

### 2.2 DevBot Stack-Specific Skills

```
# Express backend
1. "claude code" express api route generator skill
2. "claude code" express middleware security audit
3. "claude code" node.js error handling best practices skill
4. "claude code" supabase migration skill
5. "claude code" supabase query optimization

# React mobile
6. "claude code" react component splitting refactor skill
7. "claude code" react performance optimization virtual scroll
8. "claude code" tanstack query best practices skill
9. "claude code" react hook extraction skill

# TypeScript
10. "claude code" typescript strict mode skill
11. "claude code" typescript type narrowing skill
12. "claude code" zod validation express typescript

# Tailwind CSS
13. "claude code" tailwind css audit duplicate classes skill
14. "claude code" tailwind component extraction reusable
15. "claude code" tailwind design system consistency

# Capacitor mobile
16. "claude code" capacitor ios android testing skill
17. "claude code" capacitor performance optimization

# Code quality
18. "claude code" code review checklist skill automated
19. "claude code" eslint custom rules skill
20. "claude code" bundle size analysis skill
```

### 2.3 Reusability & Architecture Skills

```
1. "claude code" refactor extract component skill
2. "claude code" dry principle automation skill
3. "claude code" express crud factory pattern
4. "claude code" react generic list page pattern
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
| **Backend Pattern**       | Reusable Express/Supabase pattern to extract                         |
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
ls .claude/skills/
```

Skip anything we already have.

---

## Phase 4: Present Report

```markdown
## DevBot Skill Discovery Report

**Date**: [date]
**Backend Routes Audited**: 12
**Mobile Pages Audited**: 13
**Mobile Components Audited**: 14
**Web Sources Checked**: [count]

---

### Audit Findings (from Phase 1)

[Full audit summary tables from Phase 1.5]

---

### Installable Skills Found

#### 1. [Name] - [score]/5

- **Source**: [URL]
- **What it does**: [description]
- **DevBot benefit**: [specific files/routes it helps]
- **Install**: [command]

---

### New Skills to Create (for DevBot)

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

### Code Quality Fixes

#### 1. [fix-name] - [score]/5

- **Issue**: [from audit]
- **Files**: [count + examples]
- **Fix**: [specific approach]

---

### CSS/Styling Fixes

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

### 5.2 Create DevBot-Specific Skills

Write auto-triggered skills to `.agents/skills/[name]/SKILL.md`:

```yaml
---
name: devbot-[name]
description: [description for auto-discovery]
---
```

### 5.3 Create New Commands

Write to `.claude/commands/[name].md` with:

- YAML frontmatter (`description`, `model`)
- Phased structure
- DevBot-specific context

### 5.4 Save Findings as Plans

For items that need code changes (reusability extractions, code quality fixes):

```bash
# Save each as a plan via DevBot API
curl -X POST http://0.0.0.0:3100/api/plans \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{
    "title": "[fix/extraction name]",
    "description": "[detailed description with files and approach]",
    "route": "devbot",
    "priority": "high|medium|low",
    "status": "pending"
  }'
```

### 5.5 Update Documentation

- Update `.claude/README.md` with new skills/commands
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

| Plan   | Priority | Route  | Description |
| ------ | -------- | ------ | ----------- |
| [name] | high     | devbot | [summary]   |

### Skipped

- [name]: [reason]

### Next Run

Scheduled every 12 hours. New discoveries will be compared against existing plans to avoid duplicates.
```

---

## Options

```bash
/discover-skills                        # Full discovery (audit + web search + report)
/discover-skills --audit-only           # Only run codebase audit (Phase 1)
/discover-skills --search-only          # Only search web for skills (Phase 2)
/discover-skills --install [name]       # Install a specific previously-found skill
/discover-skills --module devbot        # Focus on DevBot module (default)
/discover-skills --coding-standards     # Only audit coding standards
/discover-skills --css-standards        # Only audit CSS/styling standards
/discover-skills --reusability          # Only audit reusability
/discover-skills --routes               # Only audit backend routes
```
