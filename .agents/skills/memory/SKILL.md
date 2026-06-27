---
name: memory
description: Two-tier memory system for personal journal and workplace context. Journal: dated, categorized, timestamped entries committed to git. Context: tiered lookup across hot cache, glossary, people, projects, and company context. Answers recall/filter questions by searching past entries' metadata.
---

# Memory Skill

**Role**: Memory scribe and context decoder for `modules/memory/`
**Scope**: Journal personal/work memories by date; maintain workplace context (people, projects, acronyms) so Claude decodes shorthand the way a colleague would.

## Architecture

```
modules/memory/
  AGENTS.md             ← Hot cache: top ~30 people, terms, active projects, preferences
  by_date/              ← dated journal entries (personal + work)
  context/              ← deep memory root
    glossary.md         ← full decoder ring
    people/             ← complete profiles per person
    projects/           ← project details per project
    company.md          ← teams, tools, processes
```

**Hot cache** — `modules/memory/AGENTS.md` holds the most-used subset (~100 lines max):
- Top ~30 people you interact with most
- ~30 most common acronyms/terms
- Active projects (5–15)
- Your preferences

**Deep memory** — `modules/memory/context/` holds everything else. Searched when something isn't in the hot cache. Can grow indefinitely.

---

## Tiered Lookup

When decoding shorthand, nicknames, or acronyms in user requests:

```
1. modules/memory/AGENTS.md (hot cache)  → covers ~90% of daily decoding
2. modules/memory/context/glossary.md                   → full decoder ring
3. modules/memory/context/people/ or modules/memory/context/projects/  → rich detail when needed
4. Ask user                              → unknown term? "What does X mean? I'll remember it."
```

Example:
```
User: "ask todd to do the PSR for phoenix"

modules/memory/AGENTS.md:
  "todd" → Todd Martinez, Finance ✓
  "PSR"  → Pipeline Status Report ✓
  "phoenix" → (not in hot cache)

modules/memory/context/glossary.md:
  "phoenix" → DB migration project ✓

Now act with full context.
```

---

## Journal Entry Format

Frontmatter holds the **day's union** of metadata; the body is **one timestamped section per memory**.

```markdown
---
date: 2026-06-16
people: [wife, kid]
projects: [seekr, memory]
tags: [work, personal, refactor, food]
mood: [accomplished, happy]
location: dallas
summary: Refactored Seekr auth and broadened the memory schema; family dinner out.
---

### 3:45 PM — work

Refactored the Seekr login flow and extended the memory module to capture work too.

### 8:30 PM — personal

Dinner at Madurai Thattu Kadai with wife and kid.
```

**Field conventions:**

- `people` — who was involved, using the **same identifier consistently** (e.g. always `wife`, never a first name). Grep existing entries before introducing a new person.
- `projects` — modules/projects a work memory touched. Reuse existing names. Omit for purely personal days.
- `tags` — topics/activities, and **always a category tag**: `personal`, `work`, or `automated`. Reuse existing tags; multi-word tags use kebab-case (`date-night`).
- `mood` — feelings present (`happy`, `stressed`, `accomplished`). Multiple allowed.
- `location` — optional, where the day mostly took place.
- `summary` — one sentence covering the day, for scanning without opening the file.
- All values are the **union** across the day's sections; all lowercase.

**Section conventions:**

- Each memory is a section headed `### <H:MM AM/PM> — <category>` in chronological order.
- Derive local time with: `date '+%I:%M %p' | sed 's/^0//'`
- Keep sections to **summaries, not transcripts** — what happened, why, the outcome.

---

## Capturing a Journal Entry

1. Determine date and current local time: `date '+%I:%M %p' | sed 's/^0//'` → e.g. `3:45 PM`.
2. Grep existing frontmatter across `modules/memory/by_date/**/*.md` to reuse consistent identifiers (`wife`, not a first name).
3. Draft the memory as `### <H:MM AM/PM> — <category>` with a short narrative + the frontmatter metadata it implies.
4. **Write immediately — no approval needed.** Append to `modules/memory/by_date/YYYY/MM/DD.md` (create year/month dirs as needed); union frontmatter metadata; never overwrite earlier sections.
5. After writing, stage only the files you touched this session and commit:
   ```bash
   cd modules/memory
   git add <files you wrote or modified>
   git commit -m "memory: <date> <H:MM AM/PM> — <one-line summary>"
   git push
   ```
   For a journal entry this is typically `modules/memory/by_date/YYYY/MM/DD.md`. For context updates, include the specific files written (e.g. `modules/memory/context/glossary.md modules/memory/context/people/todd-martinez.md`).

---

## Adding Context Memory

When the user says "remember this" or "X means Y":

| Type | Where to write | Also do |
|------|---------------|---------|
| Acronym / term | `modules/memory/context/glossary.md` | Promote to hot cache if used frequently |
| Person | `modules/memory/context/people/<name>.md` | Add nickname → full name in `modules/memory/context/glossary.md`; add to hot cache if top 30 |
| Project | `modules/memory/context/projects/<name>.md` | Add codename → project in `modules/memory/context/glossary.md`; add to hot cache if active |
| Preference | `modules/memory/AGENTS.md` Preferences section | — |
| Company context | `modules/memory/context/company.md` | — |

**File conventions:** lowercase, hyphens (`todd-martinez.md`, `project-phoenix.md`).

---

## modules/memory/AGENTS.md Format (Hot Cache)

Target ~50–80 lines. Use tables for compactness. Bold key terms for scannability.

```markdown
# Memory

## Me
[Name], [Role] on [Team]. [One sentence about what you do.]

## People
| Who | Role |
|-----|------|
| **Todd** | Todd Martinez, Finance lead |
| **Sarah** | Sarah Chen, Engineering (Platform) |
→ Full list: modules/memory/context/glossary.md, profiles: modules/memory/context/people/

## Terms
| Term | Meaning |
|------|---------|
| PSR | Pipeline Status Report |
| P0 | Drop everything priority |
→ Full glossary: modules/memory/context/glossary.md

## Projects
| Name | What |
|------|------|
| **Phoenix** | DB migration, Q2 launch |
→ Details: modules/memory/context/projects/

## Preferences
- Async-first, Slack over email
- 25-min meetings with buffers
```

---

## modules/memory/context/glossary.md Format (Full Decoder Ring)

```markdown
# Glossary

## Acronyms
| Term | Meaning | Context |
|------|---------|---------|
| PSR | Pipeline Status Report | Weekly sales doc |
| P0/P1/P2 | Priority levels | P0 = drop everything |

## Nicknames → Full Names
| Nickname | Person |
|----------|--------|
| Todd | Todd Martinez (Finance) |
| T | Also Todd Martinez |

## Project Codenames
| Codename | Project |
|----------|---------|
| Phoenix | Database migration |

## Internal Terms
| Term | Meaning |
|------|---------|
| the migration | Project Phoenix database work |
| ship it | Deploy to production |
```

---

## modules/memory/context/people/{name}.md Format

```markdown
# Todd Martinez

**Also known as:** Todd, T
**Role:** Finance Lead
**Team:** Finance

## Communication
- Prefers Slack DM; quick responses, very direct
- Best time: mornings

## Notes
- Key contact for deal approvals over $500k
```

---

## modules/memory/context/projects/{name}.md Format

```markdown
# Project Phoenix

**Codename:** Phoenix
**Also called:** "the migration"
**Status:** Active, launching Q2

## What It Is
Database migration from legacy Oracle to PostgreSQL.

## Key People
- Sarah — tech lead
- Todd — budget owner

## Context
$1.2M budget, 6-month timeline.
```

---

## Promotion / Demotion

**Promote to hot cache (`modules/memory/AGENTS.md`) when:** term/person used frequently, part of active work.
**Demote to `modules/memory/context/` only when:** project completed, person no longer frequent, term rarely used.

Keep the hot cache under ~100 lines at all times.

---

## Answering Recall Questions

**Journal recall** ("happy memories with wife", "my work on seekr"):
1. Grep frontmatter across `modules/memory/by_date/**/*.md` for `people:`, `projects:`, `mood:`, or `tags:` values.
2. Read matching timestamped sections for full context, then answer.

**Context recall** ("who is Todd", "what does PSR mean"):
1. Check `modules/memory/AGENTS.md` first.
2. Check `modules/memory/context/glossary.md` or the relevant `modules/memory/context/people/` or `modules/memory/context/projects/` file.
3. If not found: "I don't know what X means yet. Can you tell me? I'll remember it."

---

## Git is Always Safe for Memory

Memory commits and pushes are **always correct** regardless of broader session "don't commit" instructions. Those apply to code modules, never to memory. Always commit and push every write.

## Hard Rules

- Write autonomously — never ask for approval before writing a journal entry or context update.
- Append journal entries as timestamped sections; never overwrite or rewrite earlier sections of the day.
- Reuse existing identifiers; never invent a new `people`/`projects`/`tags` value without checking existing entries first.
- Always commit and push after every write, even if broader session says "don't commit".
- Keep hot cache (`modules/memory/AGENTS.md`) under ~100 lines — the "hot 30" rule.
