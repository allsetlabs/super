# Agent Task I/O Directory

This directory contains input/output files for agent task executions.

## Structure

```
.claude/tasks/
├── {task_name}/
│   ├── code-analyzer/
│   │   ├── input_1.md
│   │   └── output_1.md
│   ├── implementation-planner/
│   │   ├── input_1.md
│   │   └── output_1.md
│   └── frontend-developer/
│       ├── input_1.md
│       ├── output_1.md
│       ├── input_2.md    # Multiple executions
│       └── output_2.md
```

## Task Naming Convention

- **User-provided**: Use sanitized task name (e.g., "create-user-dashboard")
- **Auto-generated**: Use timestamp-UUID format (e.g., "20251016-abc123")

## File Formats

### Input Files (`{agent_name}/input_{N}.md`)

Contains the task request and context for the agent.

- `N` = execution number (starts at 1)
- Includes paths to previous agent outputs

### Output Files (`{agent_name}/output_{N}.md`)

Contains the agent's results, findings, and recommendations.

- `N` = execution number (matches input)
- Always created, even on errors

## Lifecycle

1. **Creation**: Orchestrator creates task directory and input files
2. **Execution**: Agents read input, perform work, write output
3. **Handoff**: Next agent reads previous agent's output
4. **Retention**: Tasks older than 7 days are archived (see /cleanup-tasks)

## Example Task Flow

```
tasks/create-dashboard-20251016/
├── code-analyzer/
│   ├── input_1.md              # Created by orchestrator
│   └── output_1.md             # Written by code-analyzer
├── implementation-planner/
│   ├── input_1.md
│   └── output_1.md
└── frontend/
    ├── input_1.md
    ├── output_1.md
    ├── input_2.md              # Re-run for corrections
    └── output_2.md
```

## Cleanup

Use `/cleanup-tasks` command to:

- Archive completed tasks older than 7 days
- Remove incomplete tasks older than 30 days
- Maintain task history

---

**Note**: This directory is managed by the orchestration system. Manual edits may be overwritten.
