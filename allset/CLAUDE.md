# AllSet Projects

These projects all use the shared `@allsetlabs/reusable` component library at `allset/ui/`.

## Component Library (`allset/ui`)

- Source: `allset/ui/src/components/`
- Storybook: `cd allset/ui && npm run storybook`
- Docs: `allset/ui/how_to_use_this_library.md` and `allset/ui/docs/`

## Using Components in a Project

All projects reference the library as `file:../ui` (or `file:../../ui` for nested packages like `seekr/web`). This means edits to `allset/ui/src/` are immediately live in all projects without publishing.

```json
"@allsetlabs/reusable": "file:../ui"
```

tsconfig.json path alias for IDE support:
```json
"@allsetlabs/reusable/*": ["../ui/src/*"]
```

## Updating the Component Library

1. Edit `allset/ui/src/` — changes are immediately available in all projects
2. Run `cd allset/ui && npm run build` if a build step is required
3. When ready to publish, commit and push `allset/ui`, then update the submodule pointer here

## Projects

| Dir | Repo | Stack |
|-----|------|-------|
| `ui/` | allsetlabs/component | React + Storybook |
| `devbot/` | allsetlabs/devbot | Vite + React + Node.js |
| `portfolio/` | allsetlabs/portfolio | Vite + React |
| `seekr/` | allsetlabs/seekr | Vite + React + Python FastAPI |
| `meme-vault/` | allsetlabs/meme-vault | Next.js |
| `tn-crime/` | allsetlabs/tn-crime-analytics | Vite + React |
