---
name: agent-name
description: One sentence describing the agent's purpose
tools: Read, Write, Edit, Grep, Glob, Bash
model: haiku
---

# Agent Name

**Role**: One sentence describing what this agent does
**Goal**: One sentence describing the desired outcome

---

## Workflow

### 1. Step Name

Brief description → expected output

### 2. Step Name

Brief description → expected output

### 3. Step Name

Brief description → expected output

---

## Required Output

```markdown
# [Agent Name] Output

## Summary

[2-3 sentences describing results]

## Key Findings

- Finding 1
- Finding 2
- Finding 3

## Recommendations

1. Priority 1: [Action] - [Reason]
2. Priority 2: [Action] - [Reason]

## Details

[Agent-specific structured details]
```

---

## Key Rules

1. **Rule 1** - Brief explanation
2. **Rule 2** - Brief explanation
3. **Rule 3** - Brief explanation
4. **Rule 4** - Brief explanation

---

## Success Criteria

✅ Criterion 1
✅ Criterion 2
✅ Criterion 3
✅ Criterion 4

---

## Template Usage Guidelines

### When Creating a New Agent:

1. **Copy this template** to `.claude/agents/your-agent-name.md`
2. **Update frontmatter**:
   - `name`: Lowercase with hyphens (e.g., code-analyzer)
   - `description`: Clear, concise purpose statement
   - `tools`: Only tools the agent actually needs
   - `model`: Choose `haiku` (fast/cheap) or `sonnet` (code generation)

3. **Define clear workflow** (3-5 steps max):
   - Each step = input → action → output
   - Use bullet points, not paragraphs

4. **Specify output format**:
   - Use structured markdown
   - Include all required sections
   - Reference I/O spec for consistency

5. **Keep it concise**:
   - Target: 80-120 lines total
   - Use bullets over paragraphs
   - Link to docs instead of inline examples

### Model Selection:

**Use `haiku` for:**

- Read-only analysis (code-analyzer)
- Text-based planning (implementation-planner)
- Simple transformations

**Use `sonnet` for:**

- Code generation (frontend-developer, backend-developer)
- Complex refactoring
- When code quality is critical

### Best Practices:

✅ Start with template
✅ Keep under 120 lines
✅ Use structured format
✅ Extract examples to docs
✅ Define clear I/O
✅ Choose appropriate model
✅ Link to external docs

❌ Don't add verbose explanations
❌ Don't include multiple inline examples
❌ Don't exceed 150 lines
❌ Don't duplicate content across agents
