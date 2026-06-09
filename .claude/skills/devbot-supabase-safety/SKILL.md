---
name: devbot-supabase-safety
description: Enforces Supabase query error checking in DevBot backend. All .from() queries must destructure and check the error result. Auto-triggers when editing .ts files in modules/devbot/backend/.
---

# DevBot Supabase Safety

## When This Skill Activates

Auto-trigger when editing any `.ts` file in `modules/devbot/backend/src/` that contains Supabase queries.

## Rules

### 1. Always Destructure Error from Supabase Queries

Every Supabase query MUST destructure and check the `error` field.

```typescript
// FORBIDDEN - silently fails
await supabase.from('table').update({ status: 'done' }).eq('id', id);

// FORBIDDEN - no error check
const result = await supabase.from('table').select('*');

// CORRECT - destructure and check
const { data, error } = await supabase.from('table').select('*');
if (error) {
  console.error('Failed to fetch:', error.message);
  // handle error appropriately
}

// CORRECT - in route handlers, return error response
const { data, error } = await supabase.from('table').insert(row).select().single();
if (error) {
  console.error('Insert failed:', error.message);
  return res.status(500).json({ error: 'Failed to create record', message: error.message });
}
```

### 2. Error Handling Context

**In route handlers** (routes/\*.ts): Return HTTP error response with consistent format:

```typescript
res.status(500).json({ error: 'Human-readable message', message: error.message });
```

**In workers** (lib/\*.ts): Log the error and update the relevant record's status:

```typescript
const { error } = await supabase.from('table').update({ status: 'failed' }).eq('id', id);
if (error) {
  console.error(`Failed to update status for ${id}:`, error.message);
}
```

**In utilities** (lib/\*.ts): Log and propagate or handle gracefully:

```typescript
const { error } = await supabase.from('sessions').update({ status: 'inactive' }).eq('id', row.id);
if (error) {
  console.error(`Failed to deactivate session ${row.id}:`, error.message);
}
```

### 3. Known Violations to Fix

These existing queries lack proper error checking:

| File                         | Line    | Query                | Fix                               |
| ---------------------------- | ------- | -------------------- | --------------------------------- |
| `session-recovery.ts`        | ~63     | `update sessions`    | Add `{ error }` destructure + log |
| `lawn-plan-worker.ts`        | ~128    | `update lawn_plans`  | Add `{ error }` destructure + log |
| `lawn-plan-worker.ts`        | ~240    | `update in polling`  | Add `{ error }` destructure + log |
| `scheduler-worker.ts`        | ~153    | `update task status` | Add `{ error }` destructure + log |
| `interactive-chat-worker.ts` | ~110    | `update chat status` | Add `{ error }` destructure + log |
| `stream-parser.ts`           | various | `insert messages`    | Verify error handling             |

### 4. Wrap in Try/Catch When Outside Route Handlers

Background operations (workers, recovery scripts) should wrap Supabase calls in try/catch:

```typescript
try {
  const { error } = await supabase.from('table').update(data).eq('id', id);
  if (error) throw error;
} catch (err) {
  console.error(`Operation failed for ${id}:`, err);
  // Don't crash the worker - log and continue
}
```

## Verification Checklist

Before completing any edit that includes Supabase queries:

- [ ] Every `.from()` call destructures `{ data, error }` or `{ error }`
- [ ] Every `error` is checked with `if (error)`
- [ ] Route handlers return proper HTTP error responses
- [ ] Workers log errors and update status fields
- [ ] Background operations are wrapped in try/catch
