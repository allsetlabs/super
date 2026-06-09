# Super Repo

All projects live as git submodules under `forge-modules/`. No code exists in this repo itself.

## Before You Start

**Ask the user: Which project do you want to work on?**

Navigate to that module directory before making any changes.

## Module Organization Rule

Group similar projects in subcategories inside `forge-modules/`. Flat entries are for standalone projects only.

Current groups: `forge-modules/tvk/` — TVK political sites.

## Module Map

| Path | Project |
|------|---------|
| `forge-modules/forge` | `forge` component library |
| `forge-modules/devbot` | DevBot personal assistant app |
| `forge-modules/portfolio` | Personal portfolio website |
| `forge-modules/seekr` | Seekr product suite |
| `forge-modules/meme-vault` | Meme creation platform |
| `forge-modules/tn-crime` | TN crime analytics dashboard |
| `forge-modules/tvk/namma` | Namma TVK campaign site |
| `forge-modules/tvk/why` | Why TVK informational site |
| `forge-modules/tvk/manifesto` | TVK manifesto (Astro) |
| `forge-modules/tvk/2026` | TVK 2026 election site |

---

## Every Module Must Have

### Makefile with 3 targets

| Target | Purpose |
|--------|---------|
| `make setup` | System-level deps (Node, Python, tmux). Idempotent — check before installing. |
| `make install` | Project-level deps (`npm install`, `pip install`, etc.) |
| `make start` | Start all services in a tmux session. Single entry point. |

Hardcode ports as Makefile variables at the top. Never in `.env` files.

### CLAUDE.md with these headings

```
## Goal
## Description
## Architecture
## Progress
## <Project-Specific Topics>
```

Keep it lean — every line consumes context. No duplicate info from this root CLAUDE.md.

---

## Commit Message Format

```
<type>(<scope>): <short description>

<optional body>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

**Types:** `feat` | `fix` | `chore` | `refactor` | `docs` | `test` | `style` | `perf` | `ci`

**Examples:**
```
feat(devbot): add voice chat support
fix(portfolio): broken image on mobile
chore(forge): update button variant types
```

## Branch Naming

| Prefix | Use |
|--------|-----|
| `feat/` | New features |
| `fix/` | Bug fixes |
| `refactor/` | Restructuring |
| `chore/` | Maintenance, deps |
| `docs/` | Documentation |

Always lowercase with hyphens. Include module: `feat/devbot-voice-chat`.

**NEVER commit or push directly to `main`.** Always work on a branch and open a PR. See `.github/PULL_REQUEST_TEMPLATE.md`.

---

## Code Standards

All rules live in `.agents/skills/coding-standards/`. Run `/fix-coding-standards` to auto-fix.

After every change:
```bash
npm run lint
npm run type-check
```

## Visual Testing

Only when a change affects visible UI — use Chrome MCP tools (`mcp__claude-in-chrome__*`) to screenshot and interact.
