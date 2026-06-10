---
name: page-size-guard
description: Enforces the 200-line limit for React components and pages in every module. Guides extraction of oversized files into smaller, focused components. Auto-triggers when editing .tsx page or component files in any forge-modules project.
---

# Page Size Guard

## When This Skill Activates

Auto-trigger when editing any `.tsx` file in a module's `src/pages/` or `src/components/` directory.

## Rule

**All React components and pages must be under 200 lines.** This is a non-negotiable project standard.

## Extraction Strategy

When a file exceeds 200 lines, extract in this priority order:

### 1. Extract Sub-Components (Most Common)

Move distinct UI sections into their own files:

```
pages/BabyLogs.tsx (2,323 lines)
  -> components/baby/BabyLogList.tsx
  -> components/baby/BabyLogForm.tsx
  -> components/baby/BabyLogFilters.tsx
  -> components/baby/BabyDiaperLog.tsx
  -> components/baby/BabyFeedingLog.tsx
  -> components/baby/BabyGrowthLog.tsx
```

### 2. Extract Hooks (Data Logic)

Move query/mutation logic into custom hooks:

```
pages/InteractiveChatList.tsx
  -> hooks/useInteractiveChats.ts  (queries + mutations)
  -> pages/InteractiveChatList.tsx  (just UI)
```

### 3. Extract Constants & Types

Move to dedicated files:

```
pages/BabyAnalytics.tsx
  -> types/baby-analytics.ts     (interfaces, chart configs)
  -> constants/baby-analytics.ts (color maps, labels)
```

### 4. Extract Utility Functions

Move pure functions out of components:

```
pages/EventsTimer.tsx
  -> lib/timer-utils.ts  (formatTime, calculateDuration)
```

## When Adding New Code

If your edit would push a file over 200 lines:

1. **Stop** - Do not continue adding to the file
2. **Extract first** - Move existing code into sub-components/hooks
3. **Then add** - Add your new code to the now-smaller file
4. **Verify** - Ensure the file stays under 200 lines

## Verification Checklist

Before completing edits to page/component files:

- [ ] File is under 200 lines (or extraction plan documented)
- [ ] Each extracted component has a single responsibility
- [ ] Extracted hooks handle all data fetching for their domain
- [ ] Types and constants are in separate files if reused
- [ ] Imports are direct (no barrel exports / double exports)
