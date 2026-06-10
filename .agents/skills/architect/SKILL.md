---
name: architect
description: Analyze code and propose architecture for user approval. Planning only — no code is written.
---

# Architecture Planning Command

You are helping the user review and approve a system design before any implementation begins. Your role is to **analyze the existing codebase**, **propose a system design**, and **get user approval or feedback**. The user has full control over architectural decisions.

## CRITICAL RULES - READ FIRST

1. **NEVER WRITE CODE** - This command is for planning only. Do not write, generate, or create any code files.
2. **NEVER IMPLEMENT** - Do not use Write, Edit, or any tool that modifies code files.
3. **USER CONTROLS DESIGN** - You propose, user decides. Accept their feedback completely.
4. **ANALYSIS ONLY** - Your job is to read, analyze, and present options.

## Output Directory

- Plan files: `./.claude/plans/{feature-name}.md`

---

## Phase 0: Module Selection

**Determine which module the user is working on BEFORE proceeding.**

### Step 0: Check if Module Already Specified

First, check if the user's prompt already mentions a module name:

```
User prompt examples that SKIP this phase:
- "/design add dark mode to <module>" → $MODULE = "<module>"
- "/design implement TTS for <module>/web" → $MODULE = "<module>/web"
- "/design backend API for user auth in <module>" → $MODULE = "<module>/backend"
```

**If module is clearly identified in the user's prompt:**

1. Set `$MODULE` to the detected module (discover valid modules via `git submodule status`)
2. Confirm: "Detected module: **{$MODULE}**"
3. **SKIP to Phase 1**

**If module is NOT clear from the prompt:** Continue to Step 1.

---

### Step 1: Discover Available Modules

**ALWAYS fetch the current module list dynamically** - projects are continuously growing.

```bash
# Scan for modules in the modules/ directory
find ./modules -maxdepth 3 -type f \( -name "package.json" -o -name "pyproject.toml" -o -name "requirements.txt" \) | xargs -I {} dirname {} | sort -u
```

**Module Directory**: `./modules/`

### Step 2: Present Module Options

Use AskUserQuestion tool with dynamically discovered modules.

Store the selected module as `$MODULE` for use throughout the planning process.

**DO NOT proceed to Phase 1 until module is selected or detected.**

---

## Phase 1: Understand the Feature Request

Parse the user's feature request from `$ARGUMENTS`.

If no arguments provided, ask: "What feature would you like me to design for **{$MODULE}**? Please describe what you want to implement."

Extract:

- Feature name (for filename)
- Core functionality needed
- Any constraints mentioned
- **Target module**: `$MODULE`

---

## Phase 2: Deep Code Analysis

**CRITICAL: Analyze the existing codebase thoroughly before proposing anything.**

### Step 1: Read Module Documentation

Read the module's documentation file from `./docs/doc-{module}.md`

### Step 2: Analyze Existing Code Structure

Use Glob and Read tools to understand:

- Current folder structure
- Existing components/services related to the feature
- Patterns used in the codebase
- State management approach
- API patterns (if backend involved)
- Styling conventions

### Step 3: Identify Integration Points

Find where the new feature will connect with existing code:

- Which existing files will need modification
- Which existing components/services to reuse
- Dependencies that already exist vs need to be added

**Present your findings:**

```markdown
## Code Analysis Results

### Current Structure

[Describe relevant parts of existing codebase]

### Existing Patterns Found

- Pattern 1: [description]
- Pattern 2: [description]

### Reusable Components/Services

- [component/service]: [how it can be reused]

### Integration Points

- [file path]: [what needs to change]
```

---

## Phase 3: Propose System Design

Based on your analysis, propose a system design. **DO NOT include code snippets.**

```markdown
## Proposed System Design for: {Feature Name}

### Architecture Overview

[High-level description of how the feature will work]

### Component/Service Structure

- **{Component/Service 1}**: [purpose and responsibility]
- **{Component/Service 2}**: [purpose and responsibility]

### Data Flow

1. [Step 1 - what happens]
2. [Step 2 - what happens]
3. [Step 3 - what happens]

### State Management

[How state will be managed]

### API Design (if applicable)

| Endpoint | Method | Purpose   |
| -------- | ------ | --------- |
| /api/xxx | POST   | [purpose] |

### File Structure
```

modules/{$MODULE}/
├── [new or modified files]
│ ├── file1.tsx (NEW)
│ ├── file2.tsx (MODIFY)

```

### Files to Create
| File Path | Purpose |
|-----------|---------|
| [path]    | [purpose] |

### Files to Modify
| File Path | Changes Needed |
|-----------|----------------|
| [path]    | [what changes] |

### Dependencies
| Package | Purpose | Already Installed? |
|---------|---------|-------------------|
| [pkg]   | [why]   | Yes/No            |
```

**Then ask:**

```
This is my proposed system design based on analyzing your codebase.

Do you:
1. **Approve** this design? (type "approve")
2. **Have feedback** to modify it? (describe your changes)
3. **Want to provide your own design**? (share your design)
4. **Have questions**? (ask anything)
```

**WAIT for user response. DO NOT proceed without explicit approval.**

---

## Phase 4: Design Iteration

### If User Provides Feedback:

1. Acknowledge their feedback
2. Update the design based on their input
3. Present the revised design
4. Ask for approval again

### If User Provides Their Own Design:

1. Acknowledge their design
2. Ask clarifying questions if needed
3. Summarize their design back to them for confirmation
4. Use their design as the basis for the plan

### If User Has Questions:

1. Answer their questions thoroughly (NO code examples)
2. Use diagrams or flow descriptions instead
3. Ask if they have more questions or are ready to approve

**STAY in this phase until user explicitly approves a design.**

---

## Phase 5: Final Design Confirmation

Once user indicates approval, present the final summary:

```markdown
## Final System Design Summary

**Feature:** {feature name}
**Module:** {$MODULE}
**Design Status:** User Approved

### Architecture

[Final architecture description]

### Components/Services to Create

1. [component/service 1] - [purpose]
2. [component/service 2] - [purpose]

### Files to Create

- [ ] {file path 1} - {purpose}
- [ ] {file path 2} - {purpose}

### Files to Modify

- [ ] {file path 1} - {changes}
- [ ] {file path 2} - {changes}

### Dependencies to Add

- [ ] {package} - {purpose}

### Implementation Order

1. [First thing to implement]
2. [Second thing to implement]
3. [Third thing to implement]

---

TYPE "create" TO SAVE THIS PLAN
Type "revise" to make more changes
```

**DO NOT create the plan file until user explicitly types "create"**

---

## Phase 6: Create Plan Document

Only after explicit "create", create the plan file:

```bash
mkdir -p ./.claude/plans
```

Create `./.claude/plans/{feature-name}.md` with:

- Feature overview
- User-approved architecture
- File structure (files to create/modify)
- Implementation checklist (no code, just tasks)
- Dependencies list
- Notes from user feedback

**The plan document should contain NO CODE - only structure, files, and tasks.**

---

## Phase 7: Completion

Show confirmation:

```
System design plan saved!

Module: {$MODULE}
File: ./.claude/plans/{feature-name}.md

IMPORTANT: This plan contains NO code.
When you're ready to implement, use /orchestrate {feature-name}

The implementation phase will follow this approved design.
```

---

## What This Command Does NOT Do

- ❌ Write any code
- ❌ Create code files
- ❌ Edit existing code
- ❌ Generate code snippets in explanations
- ❌ Make implementation decisions without user approval

## What This Command Does

- ✅ Analyze existing codebase
- ✅ Propose system designs
- ✅ Accept user feedback
- ✅ Iterate on designs until approved
- ✅ Create a plan document (structure only, no code)
- ✅ Give user full control over architecture
