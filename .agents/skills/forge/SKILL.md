---
name: forge
description: Forge component library skill — enforces component and CSS standards for every module using the forge library (no raw HTML elements, no default Tailwind colors, no dark: prefixes), plus Google OAuth integration and component docs maintenance. Auto-triggers when editing .tsx files in any forge-modules project or when the user mentions forge.
---

# Forge Component & CSS Standards

All modules under `forge-modules/` use the forge component library (`@allsetlabs/forge`; some modules alias it as `@allsetlabs/forge`). These rules apply to every `.tsx` file in every module.

**Library docs:** `forge-modules/forge/how_to_use_this_library.md` · **Colors/styles:** `forge-modules/forge/src/styles/styles.md`

## Topic Files

| Topic | File | When to load |
|-------|------|--------------|
| Google OAuth | [google-oauth.md](google-oauth.md) | Adding Google OAuth authentication to an app via the forge pattern |
| Component docs | [update-docs.md](update-docs.md) | Creating or syncing usage documentation for forge library exports |

## Rules (Non-Negotiable)

### 1. No Raw HTML Elements

**NEVER** use raw HTML elements for UI. Always use the forge component library.

| Forbidden    | Required Replacement                      |
| ------------ | ----------------------------------------- |
| `<button>`   | `<Button>` from the forge library         |
| `<input>`    | `<Input>` from the forge library          |
| `<textarea>` | `<Textarea>` from the forge library       |
| `<select>`   | `<Select>` from the forge library         |
| `<dialog>`   | `<Dialog>` or `<Drawer>` from the library |

### 2. No Default Tailwind Colors

**NEVER** use default Tailwind color utilities. Only use custom theme colors from `forge-modules/forge/src/styles/styles.md`.

```
FORBIDDEN: bg-blue-500, text-red-600, border-gray-300, bg-slate-100, etc.
FORBIDDEN: bg-[#3b82f6], text-[#ef4444] (arbitrary color values)

CORRECT: bg-background, bg-primary, bg-card, bg-muted, bg-success
CORRECT: text-foreground, text-primary-foreground, text-muted-foreground
CORRECT: border-border, border-input
```

### 3. No dark: Prefixes

Theme switching is handled automatically by `InitializeForgeChunks` in `App.tsx`. Never use `dark:` Tailwind prefixes.

```
FORBIDDEN: dark:bg-gray-900, dark:text-white
CORRECT: bg-background, text-foreground (auto-switches with theme)
```

### 4. Minimize Inline Styles

Use Tailwind classes instead of `style={{}}`. Exceptions:

- Dynamic values for virtual scrolling (TanStack Virtual `transform` props)
- SVG/chart rendering with computed dimensions
- All other cases must use Tailwind classes

### 5. Component Library First

Before creating any new UI element, check if it exists in the forge library:

- `Button`, `Input`, `Textarea`, `Select` - Form controls
- `Dialog`, `Drawer`, `Sheet` - Overlays
- `Card`, `Badge`, `Avatar` - Display
- `DataFetchWrapper` - Loading/error states
- `Tabs`, `Accordion` - Layout

If a needed component or variant doesn't exist, create it first in `forge-modules/forge/` (additive, non-breaking — see `forge-modules/CLAUDE.md` isolation check), then use it.

## Verification Checklist

Before completing any edit to a `.tsx` file:

- [ ] No `<button>`, `<input>`, `<textarea>`, `<select>`, `<dialog>` tags
- [ ] No `bg-blue`, `text-red`, `border-gray` or similar default colors
- [ ] No `[#hex]` arbitrary color values
- [ ] No `dark:` prefixes
- [ ] All new UI elements use forge library components
