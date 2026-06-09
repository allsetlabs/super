# Forge Modules

All projects here use the `forge` component library (`@allsetlabs/reusable`). This is enforced — no raw HTML elements, no third-party component libs.

## Grouping Rule

Group related projects in subcategories. Flat = standalone only.  
Current group: `tvk/` (TVK political sites).

---

## Using Forge Components

**Docs:** `forge-modules/forge/how_to_use_this_library.md`  
**Styles & colors:** `forge-modules/forge/src/styles/styles.md`  
**Storybook:** `cd forge-modules/forge && make start`

### Installing the dep

```json
"@allsetlabs/reusable": "file:../forge"
```

Adjust depth:
- Flat project (`forge-modules/myapp`): `file:../forge`
- Group project (`forge-modules/tvk/myapp`): `file:../../forge`
- Nested package inside project (`forge-modules/myapp/web`): `file:../../forge`

tsconfig.json path alias for IDE:
```json
"baseUrl": ".",
"paths": { "@allsetlabs/reusable/*": ["../forge/src/*"] }
```

### Importing components

```tsx
import { Button, Input, Card } from '@allsetlabs/reusable';
```

---

## Strict Forge Rules

### 1. Always use forge — never raw elements

```tsx
// BAD
<button className="bg-blue-500 text-white px-4 py-2">Save</button>

// GOOD
import { Button } from '@allsetlabs/reusable';
<Button variant="primary">Save</Button>
```

### 2. Need a component that doesn't exist? Create it in forge first

```bash
cd forge-modules/forge
# Add component to src/components/
# Export from src/index.ts
```

Then use it from `@allsetlabs/reusable`. This way all modules share it.

### 3. Editing an existing forge component — isolation check

**Before changing a forge component, ask:**

> Which modules currently use this component?

```bash
grep -r "from '@allsetlabs/reusable'" forge-modules/ --include="*.tsx" -l
```

**Decision tree:**

| Situation | Action |
|-----------|--------|
| Change is additive (new optional prop with a default) | Safe to edit — won't break existing usage |
| Change alters existing behaviour / removes a prop | Create a NEW component or new variant instead |
| Styling change affects all usages in an intentional way | Edit and confirm each affected module looks correct |
| Only one module needs the change | Add an opt-in prop to isolate it |

**Example — safe additive change:**
```tsx
// BEFORE
function Button({ label }: { label: string }) { ... }

// AFTER — adding optional prop with default = no breaking change
function Button({ label, size = 'md' }: { label: string; size?: 'sm' | 'md' | 'lg' }) { ... }
```

**Example — isolating a breaking change:**
```tsx
// Instead of changing Button, create ButtonV2 or add a variant
function Button({ label, variant = 'default', newBehavior = false }) { ... }
```

---

## Projects

| Dir | Repo | Stack |
|-----|------|-------|
| `forge/` | allsetlabs/component | React + Storybook |
| `devbot/` | allsetlabs/devbot | Vite + React + Node.js |
| `portfolio/` | allsetlabs/portfolio | Vite + React |
| `seekr/` | allsetlabs/seekr | Vite + React + Python FastAPI |
| `meme-vault/` | allsetlabs/meme-vault | Next.js |
| `tn-crime/` | allsetlabs/tn-crime-analytics | Vite + React |
| `tvk/namma` | allsetlabs/namma-tvk | Vite + React (web + mobile + backend) |
| `tvk/why` | allsetlabs/why-tvk | Vite + React |
| `tvk/manifesto` | allsetlabs/tvk-manifesto | Astro + React |
| `tvk/2026` | allsetlabs/tvk-2026 | Vite + React |
