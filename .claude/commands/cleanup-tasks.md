---
allowed-tools: Bash, Read, Write, Glob
description: Archives or removes old task directories to manage .claude/tasks/ storage
---

# Cleanup Tasks

Manages task directory lifecycle by archiving completed tasks and removing abandoned ones.

---

## Default Behavior

```bash
/cleanup-tasks
```

- Archives completed tasks older than 7 days
- Removes incomplete tasks older than 30 days
- Shows summary of actions taken

---

## Options

```bash
/cleanup-tasks --dry-run          # Show what would be cleaned without doing it
/cleanup-tasks --archive-days=14  # Custom archive age (default: 7)
/cleanup-tasks --remove-days=60   # Custom removal age (default: 30)
/cleanup-tasks --all              # Archive all completed tasks regardless of age
```

---

## Workflow

### 1. Find Task Directories

```bash
find .claude/tasks -mindepth 1 -maxdepth 1 -type d | sort
```

### 2. Classify Each Task

For each task directory:

```bash
task_dir=".claude/tasks/task-name-20251016"

# Check if task is complete (all agents have Status: Completed)
is_complete=$(find "$task_dir" -name "output_*.md" -exec grep -l "^**Status**: Completed" {} \; | wc -l)
has_errors=$(find "$task_dir" -name "output_*.md" -exec grep -l "^**Status**: Error" {} \; | wc -l)

# Get task age (days since last modified output file)
last_modified=$(find "$task_dir" -name "output_*.md" -exec stat -f %m {} \; | sort -n | tail -1)
current_time=$(date +%s)
age_days=$(( (current_time - last_modified) / 86400 ))
```

### 3. Apply Retention Policy

```bash
# Archive completed tasks older than threshold
if [ $is_complete -gt 0 ] && [ $has_errors -eq 0 ] && [ $age_days -gt $ARCHIVE_DAYS ]; then
  archive_task "$task_dir"
fi

# Remove incomplete/abandoned tasks older than threshold
if [ $has_errors -gt 0 ] || [ $is_complete -eq 0 ]; then
  if [ $age_days -gt $REMOVE_DAYS ]; then
    remove_task "$task_dir"
  fi
fi
```

---

## Archive Function

Creates compressed archive and removes original:

```bash
archive_task() {
  task_dir=$1
  task_name=$(basename "$task_dir")
  archive_dir=".claude/tasks/.archive"

  mkdir -p "$archive_dir"

  # Create tarball
  tar -czf "$archive_dir/${task_name}.tar.gz" -C ".claude/tasks" "$task_name"

  # Verify archive created successfully
  if [ -f "$archive_dir/${task_name}.tar.gz" ]; then
    rm -rf "$task_dir"
    echo "✅ Archived: $task_name"
  else
    echo "❌ Failed to archive: $task_name"
  fi
}
```

---

## Remove Function

Permanently deletes task directory:

```bash
remove_task() {
  task_dir=$1
  task_name=$(basename "$task_dir")

  # Safety check: don't remove if modified in last day
  last_mod=$(find "$task_dir" -type f -exec stat -f %m {} \; | sort -n | tail -1)
  age=$(( ($(date +%s) - last_mod) / 86400 ))

  if [ $age -gt 1 ]; then
    rm -rf "$task_dir"
    echo "🗑️  Removed: $task_name (incomplete, $age days old)"
  else
    echo "⚠️  Skipped: $task_name (modified recently)"
  fi
}
```

---

## Restore from Archive

```bash
/cleanup-tasks --restore=task-name-20251016

# Unpack from archive
tar -xzf .claude/tasks/.archive/task-name-20251016.tar.gz -C .claude/tasks/
echo "✅ Restored: task-name-20251016"
```

---

## Summary Report

After cleanup, show summary:

```markdown
## Cleanup Summary

**Date**: 2025-10-16 14:30:00

### Actions Taken

- Archived: 3 completed tasks
- Removed: 1 incomplete task
- Skipped: 2 recent tasks

### Archived Tasks

- create-dashboard-20251010 (6 days old)
- fix-bug-20251008 (8 days old)
- refactor-api-20251005 (11 days old)

### Removed Tasks

- test-feature-20250915 (31 days old, Status: Error)

### Current Tasks (Active)

- new-feature-20251015 (1 day old, in progress)
- update-ui-20251016 (0 days old, in progress)

### Storage

- Before: 15.2 MB
- After: 3.8 MB
- Saved: 11.4 MB (75%)

### Archive Location

- .claude/tasks/.archive/ (3 files, 892 KB compressed)
```

---

## Dry Run Example

```bash
$ /cleanup-tasks --dry-run

## Cleanup Plan (Dry Run)

Would archive (older than 7 days):
  - create-dashboard-20251008
  - fix-styling-20251007

Would remove (older than 30 days):
  - abandoned-task-20250910

Would keep (recent or active):
  - new-feature-20251015
  - current-work-20251016

Run without --dry-run to execute
```

---

## Configuration

Create `.claude/tasks/.cleanup-config` to customize defaults:

```bash
# Retention policy (days)
ARCHIVE_COMPLETED_AFTER=7
REMOVE_INCOMPLETE_AFTER=30

# Archive settings
COMPRESS_ARCHIVES=true
MAX_ARCHIVE_SIZE_MB=100

# Safety settings
REQUIRE_CONFIRMATION=false
KEEP_RECENT_ERRORS=true  # Don't remove error tasks < 7 days old
```

---

## Safety Features

1. **Never remove recently modified** - Tasks modified in last 24 hours are always kept
2. **Verify before delete** - Archives verified before removing originals
3. **Compression** - Archives are compressed to save space
4. **Recoverable** - Archived tasks can be restored
5. **Dry run** - Preview changes before executing

---

## Usage Examples

### Regular maintenance (weekly)

```bash
/cleanup-tasks
```

### Conservative (keep more history)

```bash
/cleanup-tasks --archive-days=14 --remove-days=60
```

### Aggressive (free up space)

```bash
/cleanup-tasks --archive-days=3 --remove-days=7
```

### Preview only

```bash
/cleanup-tasks --dry-run
```

### Restore archived task

```bash
/cleanup-tasks --restore=task-name-20251001
```

---

## Success Criteria

✅ Completed tasks archived after threshold
✅ Abandoned tasks removed after threshold
✅ Recent/active tasks preserved
✅ Archives verified before deletion
✅ Storage space recovered
✅ Restoration possible for archived tasks

---

**Pattern**: Analyze → Classify → Archive/Remove → Report

Automate with cron: `0 2 * * 0 /cleanup-tasks` (weekly at 2 AM)
