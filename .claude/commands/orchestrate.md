---
allowed-tools: Read, Write, Bash, Grep, Glob, Task
description: Orchestrates feature development through phased workflow. Each phase writes output, clears context, and passes file to next phase.
---

# Orchestrate Feature Development

Each phase writes to `.claude/tasks/{task_name}/{index}.{phase_name}.md`, clears context, and the next phase reads only the previous output.

```
Standard Flow:
Phase 0: Module Select → Phase 1: Request → Phase 2: Analysis → Phase 3: Plan → ⚠️ CONFIRM → Phase 4: Execute → Phase 5: Complete

Fast-Track (with .claude/plans/{plan}.md):
Pre-Check → Phase 4: Execute → Phase 5: Complete (+ cleanup plan file)
```

**Output Directory**: `./.claude/tasks/{task_name}/`

**File Naming**:

- Single run: `{phase_index}.{phase_name}.md`
- Multiple runs: `{phase_index}-{n}.{phase_name}.md`

---

## Pre-Check: Detect Pre-Approved Plan File

**BEFORE starting Phase 0**, check if the user provided a `.claude/plans/{plan}.md` file path.

### Detection Rules

```
Examples that trigger fast-track:
- "/orchestrate .claude/plans/add-dark-mode.md" → $PLAN_FILE = ".claude/plans/add-dark-mode.md"
- "/orchestrate with .claude/plans/feature-x.md" → $PLAN_FILE = ".claude/plans/feature-x.md"
- Any argument matching ".claude/plans/*.md"
```

### If Pre-Approved Plan Detected

1. **Read the plan file** to extract module and task information
2. **Generate task_name** from plan filename or content
3. **Create task directory**: `.claude/tasks/{task_name}/`
4. **Copy plan to task directory** as `3.plan.md`
5. **Set flag**: `$PRE_APPROVED = true`
6. **Skip directly to Phase 4: Execute** (no confirmation needed)
7. **Store plan file path**: `$PLAN_FILE_TO_DELETE` for cleanup after completion

```bash
# Example: Extract task_name from plan filename
plan_filename=$(basename "$PLAN_FILE" .md)
task_name="${plan_filename}-$(date +%Y%m%d)"

# Create task directory
mkdir -p ./.claude/tasks/$task_name

# Copy plan as 3.plan.md (the expected input for Phase 4)
cp "$PLAN_FILE" ./.claude/tasks/$task_name/3.plan.md

# Store for cleanup
PLAN_FILE_TO_DELETE="$PLAN_FILE"
```

### If No Pre-Approved Plan

Continue with normal flow starting at Phase 0.

---

## Phase 0: Module Select

**Output**: `.claude/tasks/{task_name}/0.module-select.md`

### Step 0: Check if Module Already Specified

Check if user's prompt already mentions a module:

```
Examples that auto-detect:
- "/orchestrate add button to portfolio" → $MODULE = "portfolio"
- "/orchestrate implement TTS for seekr/web" → $MODULE = "seekr/web"
- "/orchestrate backend API for auth" → $MODULE = "seekr/backend"
```

**If detected**: Set `$MODULE`, skip to generating task_name

**If NOT detected**: Continue to Step 1

### Step 1: Discover Available Modules

```bash
find ./modules -maxdepth 3 -type f \( -name "package.json" -o -name "pyproject.toml" -o -name "requirements.txt" \) | xargs -I {} dirname {} | sort -u
```

### Step 2: Ask User

Use AskUserQuestion with discovered modules.

### Step 3: Generate task_name and write output

```bash
# Generate task_name
task_name=$(echo "$USER_REQUEST" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | head -c 30)-$(date +%Y%m%d)

# Create directory
mkdir -p ./.claude/tasks/$task_name
```

### Write Phase 0 Output

```bash
cat > ./.claude/tasks/$task_name/0.module-select.md <<EOF
# Phase 0: Module Selection

**Task**: $task_name
**Module**: $MODULE
**Module Path**: modules/$MODULE
**Timestamp**: $(date -Iseconds)

## User Request
$USER_REQUEST

## Next Phase
Read this file and proceed to Phase 1: Request parsing
EOF
```

**CLEAR CONTEXT** → Spawn Phase 1

---

## Phase 1: Request

**Input**: `.claude/tasks/{task_name}/0.module-select.md`
**Output**: `.claude/tasks/{task_name}/1.request.md`

### Spawn Request Parser Agent

```
@agent (new context)

Read: ./.claude/tasks/$task_name/0.module-select.md

Parse the user request and extract:
1. Feature/component to build
2. Core functionality required
3. Integrations needed
4. Constraints mentioned

Write output to: ./.claude/tasks/$task_name/1.request.md

Output format:
# Phase 1: Request Analysis

**Task**: {from input}
**Module**: {from input}

## Parsed Request
- **Feature**: [name]
- **Description**: [what it does]
- **Functionality**: [list]
- **Integrations**: [list]
- **Constraints**: [list]

## Next Phase
Proceed to Phase 2: Code Analysis
```

**CLEAR CONTEXT** → Spawn Phase 2

---

## Phase 2: Analysis

**Input**: `.claude/tasks/{task_name}/1.request.md`
**Output**: `.claude/tasks/{task_name}/2.analysis.md` (or `2-{n}.analysis.md` if re-run)

### Spawn Code Analyzer Agent

```
@agent-code-analyzer (new context)

Read: ./.claude/tasks/$task_name/1.request.md

Analyze within the target module (modules/$MODULE):
1. Similar components for reuse
2. Established patterns (API, styling, state)
3. Code examples/conventions
4. Reuse vs create recommendations
5. Potential conflicts

Write output to: ./.claude/tasks/$task_name/2.analysis.md

Output format:
# Phase 2: Code Analysis

**Task**: {from input}
**Module**: {from input}

## Reusable Components
[list with file paths]

## Patterns Found
- **API**: [patterns]
- **Styling**: [patterns]
- **State**: [patterns]

## Recommendations
- Reuse: [list]
- Create new: [list]

## Potential Conflicts
[list]

## Next Phase
Proceed to Phase 3: Implementation Plan
```

**CLEAR CONTEXT** → Spawn Phase 3

---

## Phase 3: Plan

**Input**: `.claude/tasks/{task_name}/2.analysis.md`
**Output**: `.claude/tasks/{task_name}/3.plan.md` (or `3-{n}.plan.md` if re-run)

### Spawn Implementation Planner Agent

```
@agent-implementation-planner (new context)

Read: ./.claude/tasks/$task_name/2.analysis.md

Create implementation plan:
1. Task breakdown with phases
2. Agent assignments per task (frontend, backend, test-dev, etc.)
3. Execution order (parallel/sequential)
4. Reuse strategy from analysis
5. Files to create/modify

Write output to: ./.claude/tasks/$task_name/3.plan.md

Output format:
# Phase 3: Implementation Plan

**Task**: {from input}
**Module**: {from input}

## Overview
[brief summary]

## Tasks

### Task 1: [name]
- **Agent**: [agent-type]
- **Description**: [what to do]
- **Files**: [list]
- **Dependencies**: [none or task numbers]

### Task 2: [name]
...

## Execution Order
1. [task] - sequential/parallel
2. [task] - sequential/parallel

## Reuse Strategy
[from analysis]
```

**CLEAR CONTEXT** → **⚠️ CONFIRMATION REQUIRED**

---

## ⚠️ Confirmation Gate (Between Phase 3 and Phase 4)

**This is NOT a phase - it's a checkpoint before execution.**

**SKIP THIS GATE if `$PRE_APPROVED = true`** (user provided `.claude/plans/{plan}.md`)

### Present Plan to User

Read `.claude/tasks/{task_name}/3.plan.md` and display summary:

```markdown
## Implementation Plan Ready

**Task**: $task_name
**Module**: $MODULE
**Plan File**: ./.claude/tasks/$task_name/3.plan.md

### Tasks Summary

[Read and display task list from plan]

---

⚠️ **TYPE "yes" TO PROCEED TO EXECUTION** ⚠️
Type "no" to cancel | "modify: [changes]" to re-plan
```

### Wait for User Response

- **"yes"** → Proceed to Phase 4: Execute
- **"no"** → Stop orchestration
- **"modify: X"** → Go back to Phase 3 with modifications (creates `3-2.plan.md`)

**DO NOT proceed to Phase 4 without explicit "yes"**

---

## Phase 4: Execute

**Input**: `.claude/tasks/{task_name}/3.plan.md`
**Output**: `.claude/tasks/{task_name}/4.execute.md`

### For Each Task in Plan

Read `3.plan.md`, extract tasks, and for each:

#### Spawn Task Agent

```
@agent-{agent_type} (new context)

Read: ./.claude/tasks/$task_name/3.plan.md

Execute Task: [task description]
Module: modules/$MODULE

Requirements:
[from plan]

Write your work output to: ./.claude/tasks/$task_name/4-{task_num}.{agent_type}.md

Output format:
# Task Execution: [task name]

**Agent**: [agent_type]
**Task Number**: [n]
**Status**: Complete/Error

## Changes Made
- [file]: [description]
- [file]: [description]

## Code Written
[summary or snippets]

## Issues Encountered
[if any]
```

### After All Tasks Complete

Aggregate into `4.execute.md`:

```bash
cat > ./.claude/tasks/$task_name/4.execute.md <<EOF
# Phase 4: Execution Summary

**Task**: $task_name
**Module**: $MODULE
**Timestamp**: $(date -Iseconds)

## Tasks Executed
$(find ./.claude/tasks/$task_name -name "4-*.md" | sort)

## Files Modified
[aggregate from all task outputs]

## Status
[Complete/Partial/Error]

## Next Phase
Proceed to Phase 5: Complete
EOF
```

**CLEAR CONTEXT** → Spawn Phase 5

---

## Phase 5: Complete

**Input**: `.claude/tasks/{task_name}/4.execute.md`
**Output**: `.claude/tasks/{task_name}/5.complete.md`

### Generate Final Summary

```
@agent (new context)

Read: ./.claude/tasks/$task_name/4.execute.md
Also read all: ./.claude/tasks/$task_name/4-*.md

Generate completion summary.

Write output to: ./.claude/tasks/$task_name/5.complete.md
```

### Cleanup Pre-Approved Plan File

**If `$PRE_APPROVED = true` and `$PLAN_FILE_TO_DELETE` is set:**

```bash
# Remove the plan file after successful implementation
rm "$PLAN_FILE_TO_DELETE"
echo "Cleaned up pre-approved plan file: $PLAN_FILE_TO_DELETE"
```

### Final Output Format

```markdown
# Phase 5: Complete

**Task**: $task_name
**Module**: $MODULE
**Completed**: $(date -Iseconds)

## Summary

[what was built]

## Files Created/Modified

- [file path]: [description]

## Phase Files

\`\`\`
./.claude/tasks/$task_name/
├── 0.module-select.md
├── 1.request.md
├── 2.analysis.md
├── 3.plan.md
├── 4.execute.md
├── 4-1.frontend.md
├── 4-2.backend.md
└── 5.complete.md
\`\`\`

## Next Steps

- Review changes in modules/$MODULE
- Run tests: `npm run test`
- Run lint: `npm run lint`
- **User should manually run `git push` when ready**
```

---

## Critical Rules

1. **ORCHESTRATOR STAYS EMPTY** - Master session only spawns agents and tracks phase progress
2. **SPAWN FRESH AGENTS** - Each phase runs in a NEW agent via Task tool (context cleared)
3. **FILE IS THE ONLY HANDOFF** - Agents read previous file, write current file, terminate
4. **READ PREVIOUS ONLY** - Each phase agent reads ONLY the previous phase's output file
5. **PHASE FILES ONLY** - Each phase writes to `.claude/tasks/{task_name}/{index}.{phase_name}.md`
6. **MULTIPLE RUNS** - If phase re-runs, use `{index}-{n}.{phase_name}.md`
7. **CONFIRM BEFORE EXECUTE** - User must type "yes" between Phase 3 and Phase 4 (unless pre-approved plan provided)
8. **DO NOT PUSH** - Never run `git push`
9. **PRE-APPROVED PLANS SKIP CONFIRMATION** - If `.claude/plans/{plan}.md` provided, skip Phases 0-3 and confirmation gate
10. **CLEANUP PLAN FILES** - Delete `.claude/plans/{plan}.md` after successful Phase 5 completion

---

## File Naming Examples

| Scenario           | File Name         |
| ------------------ | ----------------- |
| First analysis     | `2.analysis.md`   |
| Re-run analysis    | `2-2.analysis.md` |
| Third plan attempt | `3-3.plan.md`     |
| Frontend task 1    | `4-1.frontend.md` |
| Backend task 2     | `4-2.backend.md`  |

---

## Directory Structure

```
./.claude/tasks/{task_name}/
├── 0.module-select.md    # Module + request
├── 1.request.md          # Parsed requirements
├── 2.analysis.md         # Code analysis
├── 3.plan.md             # Implementation plan
├── 4.execute.md          # Execution summary
├── 4-1.{agent}.md        # Task 1 output
├── 4-2.{agent}.md        # Task 2 output
└── 5.complete.md         # Final summary
```

---

## Context Clearing Pattern

**CRITICAL: The master/orchestrator session stays EMPTY. It only spawns agents and reads phase files.**

```
Orchestrator (empty context)
    ↓
Spawn Agent for Phase N → Agent reads previous file → Agent works → Agent writes output
    ↓
Agent terminates (context cleared)
    ↓
Orchestrator reads output file (minimal context)
    ↓
Spawn Agent for Phase N+1 → ...
```

### How It Works

1. **Orchestrator stays lightweight** - Only tracks: task_name, current phase, file paths
2. **Each phase agent is independent** - Spawned fresh, reads only the previous phase file
3. **No context accumulation** - Agent completes, writes file, terminates
4. **File is the only handoff** - Next agent reads file, has zero knowledge of prior agents

### Spawning Pattern

```
# Orchestrator does this for each phase:

1. Determine next phase file to create
2. Spawn agent with Task tool:
   - subagent reads: ./.claude/tasks/$task_name/{previous}.md
   - subagent writes: ./.claude/tasks/$task_name/{current}.md
3. Wait for agent to complete (file exists)
4. (Optional) Read file to show user summary
5. Spawn next phase agent
```

### Why This Matters

- **Unlimited task complexity** - No context overflow regardless of task size
- **Each phase gets full context window** - Fresh agent = full capacity
- **Debuggable** - Each phase file is a complete snapshot
- **Resumable** - Can restart from any phase by reading its input file

**Exception**: Confirmation gate is handled by orchestrator directly (user interaction), not a spawned agent.
