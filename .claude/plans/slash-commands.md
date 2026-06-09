# Plan: Slash Command Dropdown in DevBot

## Goal

When user types `/` at the start of a chat input, show a dropdown with all available skills/commands. Selecting one inserts it into the input.

## Architecture Decision

- **Single node only** — no multi-node support
- **Backend reads local FS** on startup → saves to Supabase `commands` table
- **Mobile fetches** from Supabase via backend API
- Forward-compatible: when backend moves to cloud, local agent takes over the FS reading step

---

## Phase 1: Supabase — `commands` Table

Migration in `modules/devbot/supabase/migrations/`:

```sql
create table commands (
  id text primary key,
  name text not null,
  description text not null,
  type text not null,  -- "skill" | "builtin"
  updated_at timestamptz default now()
);
```

---

## Phase 2: Backend — Read Skills on Startup

Create `backend/src/lib/commands-sync.ts`:

- Read `.claude/skills/` directory via `fs`
- Parse each skill's `SKILL.md` — extract name + description
- Merge with hardcoded built-in commands
- Upsert all into Supabase `commands` table
- Call once in `index.ts` on startup

Built-ins to hardcode: `/help /clear /compact /cost /doctor /exit /init /login /logout /model /pr_comments /release-notes /review /status /terminal /vim`

---

## Phase 3: Backend — API Route

`GET /api/commands` in `backend/src/routes/commands.ts`:

- Read all rows from `commands` table
- Return `{ id, name, description, type }[]`

---

## Phase 4: Mobile — `useCommands` Hook

`mobile/src/hooks/useCommands.ts`:

- `useQuery` on `GET /api/commands`
- `staleTime: 5 * 60 * 1000`

---

## Phase 5: Mobile — Slash Command Dropdown UI

**Component: `CommandPicker`** (`mobile/src/components/CommandPicker.tsx`):

- Props: `commands`, `filter`, `onSelect`
- Filters by prefix match on typed text after `/`
- Shows command name + description, max 5 visible rows
- Positioned above textarea

**Wire into chat input** (InteractiveChatView / useChat):

- Detect `/` at start of input → show picker
- On select → replace input with command id
- Dismiss on Escape or when input no longer starts with `/`

---

## File Checklist

| File                                       | Action                                   |
| ------------------------------------------ | ---------------------------------------- |
| `supabase/migrations/XXXXXX_commands.sql`  | Create                                   |
| `backend/src/lib/commands-sync.ts`         | Create                                   |
| `backend/src/routes/commands.ts`           | Create                                   |
| `backend/src/index.ts`                     | Edit — startup sync + route registration |
| `mobile/src/hooks/useCommands.ts`          | Create                                   |
| `mobile/src/components/CommandPicker.tsx`  | Create                                   |
| `mobile/src/pages/InteractiveChatView.tsx` | Edit — integrate CommandPicker           |

---

## Out of Scope

- Multi-node support
- Real-time fs.watch for skill changes
- Command argument/parameter hints
