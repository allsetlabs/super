# Forge Modules

All projects here use the `forge` component library (`@allsetlabs/reusable`).

## Component Library (`forge-modules/forge`)

- Source: `forge-modules/forge/src/components/`
- Storybook: `cd forge-modules/forge && npm run storybook`
- Docs: `forge-modules/forge/how_to_use_this_library.md` and `forge-modules/forge/docs/`

## Using Components

Reference as `file:../forge` in package.json (or `file:../../forge` for nested packages like `seekr/web`, `namma/web`, `why/web`).

Edits to `forge-modules/forge/src/` are immediately live in all projects — no publishing needed.

```json
"@allsetlabs/reusable": "file:../forge"
```

tsconfig.json path alias for IDE support:
```json
"@allsetlabs/reusable/*": ["../forge/src/*"]
```

## Projects

| Dir | Repo | Stack |
|-----|------|-------|
| `forge/` | allsetlabs/component | React + Storybook |
| `devbot/` | allsetlabs/devbot | Vite + React + Node.js |
| `portfolio/` | allsetlabs/portfolio | Vite + React |
| `seekr/` | allsetlabs/seekr | Vite + React + Python FastAPI |
| `meme-vault/` | allsetlabs/meme-vault | Next.js |
| `tn-crime/` | allsetlabs/tn-crime-analytics | Vite + React |
| `namma/` | allsetlabs/namma-tvk | Vite + React (web + mobile + backend) |
| `why/` | allsetlabs/why-tvk | Vite + React |
| `manifesto/` | allsetlabs/tvk-manifesto | Astro + React |
| `2026/` | allsetlabs/tvk-2026 | Vite + React |
