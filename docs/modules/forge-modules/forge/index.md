---
module: modules/forge-modules/forge
last_synced_commit: f2d2e661529663d8e31dbb41636edb3e2d712d1a
last_synced: 2026-06-10
---

# Forge (@allsetlabs/forge)

## Overview

Shared React component library used by all frontend modules in the super repo — the single source of UI components, styles, and design tokens. Library package only (no standalone app, no build step); consumers install it as `"@allsetlabs/forge": "file:../forge"` (adjust depth for nesting) and import from source.

## Tech Stack

React 19 + TypeScript + Tailwind CSS v3 + shadcn/ui patterns + Radix UI primitives + CVA, plus cmdk, sonner, vaul, Lucide icons, react-hook-form, and docx/pdfmake for document generation. Storybook for development.

## Architecture

```
src/
├── components/ui/           # shadcn/ui primitives (Button, Dialog, Card, …)
├── components/ai-elements/  # @ai-elements registry components (chat, code, terminal)
├── components/auth-login/   # Authentication/login components
├── statefulComponents/      # Stateful (auth, theme, audio, cursor)
├── hooks/ • icons/ • lib/ • types/
├── styles/                  # Global styles, CSS variables, theme (see src/styles/styles.md)
└── InitializeForgeChunks.tsx  # Required root wrapper
```

Consumers must wrap their app in `InitializeForgeChunks`, extend the library's Tailwind config, and use only the CSS-variable colors from `src/styles/` (no default Tailwind colors). Component usage index: `how_to_use_this_library.md` in the module.

## How to Run

`make setup` / `make install` / `make start` → Storybook on port **6006**. Storybook deploys to GitHub Pages via Actions.

## Recent Changes

- `f2d2e66` chore: adopt AGENTS.md standard, removed stale `docs/` folder
- `a2a833b` fix: increase default padding in DropdownMenuItem and SelectItem
- `82a001b` ci: GitHub Actions workflow to deploy Storybook to GitHub Pages
- `004344b` chore: prettier and eslint config

## Links

- Module [AGENTS.md](../../../../modules/forge-modules/forge/AGENTS.md)
- [Forge skill](../../../../.agents/skills/forge/SKILL.md) (component/CSS standards, Google OAuth, docs maintenance)
- Usage guide: `forge-modules/forge/how_to_use_this_library.md`
