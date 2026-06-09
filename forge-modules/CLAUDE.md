# Forge Modules

Projects in this directory share the `forge` component library.

## Component Library (`forge-modules/forge`)

- Source: `forge-modules/forge/src/components/`
- Storybook: `cd forge-modules/forge && npm run storybook`
- Docs: `forge-modules/forge/how_to_use_this_library.md` and `forge-modules/forge/docs/`

## Using Components

All projects reference the library as `file:../forge` (or `file:../../forge` for nested packages like `seekr/web`).

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
