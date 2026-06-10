# Super Repo

All projects live as git submodules under `forge-modules/`. No code exists in this repo itself.

## AI Tool Layout

This repo works with any AI CLI (Claude Code, Codex, Copilot CLI, Kimi CLI). One portable core, thin per-tool adapters:

| Path | Role |
|------|------|
| `AGENTS.md` | Canonical instructions (this file). `CLAUDE.md` is a symlink to it — never edit the symlink. |
| `.agents/skills/` | Single source of truth for all skills/commands (open Agent Skills standard). Codex and Copilot read it natively; `.claude/skills` symlinks to it for Claude Code; point Kimi at it via `extra_skill_dirs`. |
| `.claude/` | Claude Code adapter: subagents, hooks, settings, Claude-only commands. |
| `.github/agents/` | Copilot CLI custom agents, generated from `.claude/agents/` — edit the Claude version first, then mirror. |
| `.mcp.json` | MCP servers (Claude format). Configure other tools' MCP manually from this list. |

**Add new reusable prompts as skills in `.agents/skills/<name>/SKILL.md`, never as tool-specific commands.**

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

### AGENTS.md with these headings

```
## Goal
## Description
## Architecture
## Progress
## <Project-Specific Topics>
```

Plus a `CLAUDE.md` symlink pointing to it. Keep it lean — every line consumes context. No duplicate info from this root AGENTS.md.

---

## Commit Message Format

```
<type>(<scope>): <short description>

<optional body>

Co-Authored-By: <AI tool and model, e.g. Claude Sonnet 4.6 <noreply@anthropic.com>>
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
