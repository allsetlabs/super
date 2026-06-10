---
name: update-component-docs
description: Create or sync usage documentation for the @subbiah/reusable component library exports.
---

# Create Component Documentation

You are a technical documentation specialist creating usage documentation for React components, utilities, styles, and other library exports in the `@subbiah/reusable` library.

## Your Task

**If user did not specify what to update, ask them to choose:**

1. **`regenerate-all`** - Regenerate ALL documentation from scratch based on current source code
   - Reads all source files in `modules/component/src/`
   - Rewrites all `.md` files with current implementation
   - Use when documentation is outdated or you want to ensure consistency

2. **`sync-changes`** - Update ONLY documentation for files that changed
   - Runs `git diff` to find modified source files
   - Updates only the `.md` files for changed components/utilities/styles
   - Use for incremental updates after code changes

3. **`resync`** - Smart sync - update only out-of-date documentation
   - Reads each existing `.md` file and its corresponding source file
   - Compares to detect if documentation is out of sync with code
   - Updates ONLY the `.md` files that are outdated
   - Use for efficient updates without regenerating everything

**If user specified files or mode:**

Generate or update usage documentation for the specified component(s), utilities, styles, or other exports in the `@subbiah/reusable` component library.

## Documentation Standards

### File Structure

- One `.md` file per component, utility, or module (not per file)
- For multi-file components (e.g., with provider, context, hooks), create ONE consolidated doc
- **IMPORTANT - Directory Handling**:
  - If component is in a directory (e.g., `modules/component/src/components/form/`), create the `.md` file INSIDE that directory (e.g., `modules/component/src/components/form/form.md`)
  - If component is a single file (e.g., `modules/component/src/components/button.tsx`), create the `.md` file next to it (e.g., `modules/component/src/components/button.md`)
  - For utility directories (e.g., `modules/component/src/lib/`), create `.md` file in the directory (e.g., `modules/component/src/lib/utils.md`)
  - For style directories (e.g., `modules/component/src/styles/`), create `.md` file in the directory (e.g., `modules/component/src/styles/styles.md`)
- Name pattern: `{file_name}.md`, `{directory_name}.md`, `styles.md`, etc.

### Content Pattern for Components

For React components, follow this exact structure:

```markdown
# Component Name

Brief one-line description of what the component does.

## Import

\`\`\`tsx
import { ComponentName } from '@subbiah/reusable/path/to/component';
// Include all related exports if multi-file component
import { useComponentContext } from '@subbiah/reusable/path/to/context';
\`\`\`

## Features

- **Feature 1**: Description
- **Feature 2**: Description
- **Feature 3**: Description

## Basic Usage

\`\`\`tsx
<ComponentName prop="value">
Content
</ComponentName>
\`\`\`

**Visual:**

> A description of how this renders visually

## Props

| Prop       | Type                     | Default     | Description    |
| ---------- | ------------------------ | ----------- | -------------- |
| `propName` | `string`                 | -           | What it does   |
| `variant`  | `"default" \| "primary"` | `"default"` | Style variant  |
| `size`     | `"sm" \| "md" \| "lg"`   | `"md"`      | Component size |

## Variants

### Variant Name

\`\`\`tsx
<ComponentName variant="primary">Example</ComponentName>
\`\`\`

**Visual:**

> Description of how this variant looks

### Another Variant

\`\`\`tsx
<ComponentName variant="secondary">Example</ComponentName>
\`\`\`

**Visual:**

> Description of appearance

## Examples

### Example 1: Common Use Case

\`\`\`tsx
<ComponentName prop="value">
Example content
</ComponentName>
\`\`\`

**Visual:**

> How this example renders

### Example 2: Advanced Pattern

\`\`\`tsx
// More complex usage example
\`\`\`

## Accessibility

- Accessibility feature 1
- Keyboard navigation details
- ARIA attributes used
- Screen reader considerations

## TypeScript

\`\`\`tsx
interface ComponentProps {
// Type definitions users need to know
}
\`\`\`

## Notes

- Important usage notes
- Common patterns
- Tips and best practices
```

### Content Pattern for Utilities

For utility functions (e.g., `modules/component/src/lib/utils.ts`), keep it extremely simple - just the essentials:

```markdown
# Utilities

## cn(...inputs: ClassValue[]): string

Merges and deduplicates Tailwind CSS class names.

\`\`\`tsx
import { cn } from '@subbiah/reusable/lib/utils';

cn('px-4 py-2', 'bg-blue-500') // "px-4 py-2 bg-blue-500"
cn('p-4', 'p-6') // "p-6" (later overrides earlier)
\`\`\`

## anotherFunction(param1: string, param2: number): ReturnType

Description of what it does.

\`\`\`tsx
anotherFunction('value', 42)
\`\`\`
```

**Format:**

- Function signature as heading
- One-line description
- Code example showing import and usage
- That's it - no tables, no extra sections

### Content Pattern for Styles

For styles (e.g., `modules/component/src/styles/index.css`), list ONLY consumable classes and CSS variables:

```markdown
# Global Styles

Global CSS styles and theme variables for the component library.

## Import

\`\`\`tsx
import '@subbiah/reusable/styles';
\`\`\`

## CSS Variables

List of theme variables users can reference:

| Variable       | Purpose          |
| -------------- | ---------------- |
| `--background` | Background color |
| `--foreground` | Text color       |

## Custom Classes

List ONLY classes users can apply to their elements:

### .className

Description of what this class does and when to use it.

**Example:**

\`\`\`tsx

<div className="className">Content</div>
\`\`\`

### .anotherClass

(Repeat for each consumable class)

## Custom Animations

List animation classes users can apply:

### .animate-name

Description and duration.

**Example:**

\`\`\`tsx

<div className="animate-name">Animated content</div>
\`\`\`

## Notes

- Usage guidelines
- Tips for customization
```

**IMPORTANT for Styles:**

- Do NOT document `@layer base` internal overrides (e.g., `* { @apply border-border; }`)
- Do NOT document scrollbar styling or focus management (not directly consumable)
- ONLY document classes and variables users can directly use in their code
- ONLY document animations users can apply via className

### Critical Rules

1. **NO IMPLEMENTATION DETAILS**: Never include:
   - Internal state management
   - Implementation code
   - How the component works internally
   - Code architecture

2. **FOCUS ON USAGE**: Only include:
   - How to import and use
   - All available props
   - All variants and their visual appearance
   - Code examples
   - Visual descriptions (what users will see)

3. **Visual Descriptions**:
   - Use markdown quotes (>) for visual descriptions
   - Describe appearance, colors, layout, interactions
   - Be specific about what users will see rendered

4. **Multi-file Components**:
   - Group related files into ONE doc
   - Example: Theme (provider + context + toggle + hook) = ONE `theme.md`
   - Example: Audio (provider + context + toggle) = ONE `audio.md`

5. **Completeness**:
   - Document ALL props
   - Document ALL variants
   - Show multiple usage examples
   - Cover edge cases

## Workflow

### Mode: regenerate-all

When user chooses `regenerate-all`:

1. Find all source files in `modules/component/src/` (`.tsx`, `.ts`, `.css`)
2. For each file/directory, read the source code
3. Find or create the corresponding `.md` file following the file structure rules
4. Regenerate the documentation from scratch using the appropriate content pattern
5. Update `modules/component/how_to_use_this_library.md` to ensure all docs are listed
6. Report all files regenerated

### Mode: sync-changes

When user chooses `sync-changes`:

1. Run `git diff --name-only` to find modified files in `modules/component/src/`
2. Filter for source files (`.tsx`, `.ts`, `.css`)
3. For each changed file:
   - Determine the corresponding `.md` file location
   - Read the existing `.md` doc (if exists)
   - Read the updated source code
   - Update the documentation following "For EXISTING Documentation" workflow
   - If no `.md` exists, create new doc following "For NEW Documentation" workflow
   - If file is deleted remove the `.md` file of that source file
4. Update `modules/component/how_to_use_this_library.md` if needed
5. Report which docs were updated based on code changes

### Mode: resync

When user chooses `resync`:

1. Find all existing `.md` files in `modules/component/src/`
2. For each `.md` file:
   - Read the existing documentation
   - Identify and read the corresponding source file(s)
   - Compare documentation content with actual source code:
     - Check if props/exports match
     - Check if types/signatures match
     - Check if variants/features match
   - If out of sync, update following "For EXISTING Documentation" workflow
   - If in sync, skip (report as "up to date")
3. Find source files without `.md` and create docs following "For NEW Documentation" workflow
4. Find `.md` file without source file and remove them
5. Update `modules/component/how_to_use_this_library.md` if needed
6. Report: files updated, files up to date, new files created

### For NEW Documentation

1. Read the component source code (all related files)
2. Identify all props, variants, and sub-components
3. Create comprehensive usage doc following the pattern
4. Save the documentation file:
   - **If component is in a directory**: Save as `{directory-name}.md` INSIDE that directory
     - Example: `modules/component/src/components/form/` → `modules/component/src/components/form/form.md`
   - **If component is a single file**: Save as `{file-name}.md` next to the component file
     - Example: `modules/component/src/components/button.tsx` → `modules/component/src/components/button.md`
5. Update `modules/component/how_to_use_this_library.md`:
   - Add link to new doc in appropriate section
   - Use format: `- **[ComponentName](./src/path/to/component.md)** - Brief description`

### For EXISTING Documentation

1. Read the existing doc completely
2. Read the current component source code
3. Compare to identify:
   - New props added
   - New variants added
   - Changed behavior
   - Deprecated features
4. Update only changed sections
5. Preserve existing good content
6. Ensure consistency with documentation pattern
7. Remove content that got deleted in code
8. Update `modules/component/how_to_use_this_library.md` if needed

## Component Location

Components are located in: `modules/component/src/`

## Index Update

After creating/updating docs, ALWAYS update the main index:

File: `modules/component/how_to_use_this_library.md`

Find the appropriate section and add/update the entry:

```markdown
### UI Components

- **[Button](./src/components/ui/button.md)** - Versatile button with multiple variants
- **[NewComponent](./src/components/ui/new-component.md)** - Brief description
```

## Examples of Good Docs

Reference existing docs as examples:

**Component Documentation:**

- `modules/component/src/statefulComponents/audio/audio.md`
- `modules/component/src/statefulComponents/cursor/cursor.md`
- `modules/component/src/statefulComponents/theme/theme.md`

These follow the correct component pattern - study them!

**When creating docs for utilities, styles, or setup files:**

- Use the simplified pattern for non-component files
- Focus on API, exports, and usage examples
- Include TypeScript types

## Response Format

When done, provide:

1. List of documentation files created/updated
2. Summary of changes made
3. Confirmation that index was updated

Now, create or update documentation for the components, utilities, styles, or other files specified by the user.
