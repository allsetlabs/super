---
module: forge-modules/portfolio
last_synced_commit: 0703539a6b42ba31a42061634d58cd39a610a6e9
last_synced: 2026-06-10
---

# Portfolio

## Overview

Personal portfolio site for Subbiah Chandramouli showcasing work experience, projects, and skills. Responsive multi-page site with dark mode (system preference), Framer Motion animations, SEO, and WCAG AA accessibility. Live at https://subbiah2806.github.io/portfolio.

## Tech Stack

React + Vite + TypeScript + Tailwind CSS + Framer Motion + React Router v7, React Hook Form + Zod for forms. Uses `@allsetlabs/forge` from `../forge`.

## Architecture

```
src/
├── components/{features,layout,ui}/  # Hero/Projects/Skills sections, Header/Footer, SEO/ThemeToggle
├── pages/      # Home, Projects, Contact, NotFound
├── hooks/      # useReducedMotion etc.
├── data/       # Static resume + project data
└── utils/ • types/ • styles/
```

No backend. Resume and project content live in `src/data/`.

## How to Run

`make setup` / `make install` / `make start` → port **4000**. Deploy: `npm run build` then push to `gh-pages` branch.

## Recent Changes

- `0703539` chore: adopt AGENTS.md standard, removed stale `docs/` folder
- `103924c` chore: update component ref to `file:../forge`
- `de1de3b` fix: code quality improvements

## Links

- Module [AGENTS.md](../../../forge-modules/portfolio/AGENTS.md)
