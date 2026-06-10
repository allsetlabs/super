# iOS-Specific Patterns

Patterns and workarounds for iOS Safari / Capacitor WebView quirks.

## Date & Time Input Pickers

iOS renders native date and time pickers that are wider than their Android/desktop counterparts. When placing `type="date"` and `type="time"` inputs **side-by-side**, they collide on iOS.

### Rules

1. **Never put two `flex-1` date/time inputs side-by-side** — iOS pickers will overlap.
2. **Preferred: Constrain date width** — Use `w-2/5 shrink-0` on date and `flex-1` on time. Keeps both fields on one row without collision.
3. **Alternative: Use `datetime-local`** — A single input avoids the issue entirely. Best for edit forms where a combined picker is acceptable.

### Examples

**Constrained width (preferred):**

```tsx
<div className="flex items-center gap-2">
  <Input type="date" className="w-2/5 shrink-0" ... />
  <Input type="time" className="flex-1" ... />
</div>
```

**Single datetime-local (edit forms):**

```tsx
<Input type="datetime-local" value={editLoggedAt} onChange={...}
  onClick={(e) => (e.target as HTMLInputElement).showPicker?.()} />
```

### Reference implementations

| Pattern           | File                                                      | Lines      |
| ----------------- | --------------------------------------------------------- | ---------- |
| Constrained width | `forge-modules/devbot/app/src/components/BabyProfileDrawer.tsx` | ~170-185   |
| Constrained width | `forge-modules/devbot/app/src/pages/BabyLogs.tsx`               | ~1614-1629 |
| datetime-local    | `forge-modules/devbot/app/src/pages/BabyLogs.tsx`               | ~1917-1922 |
