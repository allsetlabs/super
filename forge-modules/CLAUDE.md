# Forge Modules

All projects here use the `forge` component library (`@allsetlabs/reusable`).

## Grouping Rule

**Always group related projects into a subcategory folder.** Flat entries are only for standalone projects with no siblings.

Current groups:
- `tvk/` — TVK political/campaign sites

When adding a new project, ask: does it belong to an existing group, or does it form a new group with another module? If yes, create or use the subcategory.

## Component Library (`forge-modules/forge`)

- Source: `forge-modules/forge/src/components/`
- Storybook: `cd forge-modules/forge && npm run storybook`
- Docs: `forge-modules/forge/how_to_use_this_library.md` and `forge-modules/forge/docs/`

## Using Components

Reference as `file:../forge` (flat), `file:../../forge` (one group deep), or `file:../../../forge` (nested package inside a group).

Edits to `forge-modules/forge/src/` are immediately live — no publishing needed.

```json
"@allsetlabs/reusable": "file:../forge"
```

tsconfig.json path alias:
```json
"@allsetlabs/reusable/*": ["../forge/src/*"]
```

Adjust `../` depth to match your position relative to `forge-modules/`.

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
