# super

All projects as git submodules. No code lives here.

## allset/ — Component-based projects

| Module | Description |
|--------|-------------|
| [allset/ui](allset/ui) | Shared React component library (`@allsetlabs/reusable`) — used by all allset projects |
| [allset/devbot](allset/devbot) | Personal assistant mobile app; Claude Code terminal proxy via xterm.js + tmux |
| [allset/portfolio](allset/portfolio) | Personal portfolio website |
| [allset/seekr](allset/seekr) | Seekr product suite — web, Chrome extension, Electron desktop, mobile, Python backend |
| [allset/meme-vault](allset/meme-vault) | Meme creation and distribution platform (Next.js) |
| [allset/tn-crime](allset/tn-crime) | Tamil Nadu crime analytics dashboard |

## tvk/ — TVK political projects

| Module | Description |
|--------|-------------|
| [tvk/namma](tvk/namma) | Namma TVK — main TVK campaign site (web + mobile + backend) |
| [tvk/why](tvk/why) | Why TVK — informational website |
| [tvk/manifesto](tvk/manifesto) | TVK manifesto site (Astro) |
| [tvk/2026](tvk/2026) | TVK 2026 election campaign site |

## tools/ — Standalone tools

| Module | Description |
|--------|-------------|
| [tools/vscode-mkt](tools/vscode-mkt) | Self-hosted VS Code extension marketplace (Docker + Caddy + Kubernetes) |

## content/ — Content & media

| Module | Description |
|--------|-------------|
| [content/cushionday](content/cushionday) | Cushion Day brand knowledge base — Norwegian home décor DTC brand |

## Setup

```bash
git clone --recurse-submodules <repo-url>
# or after cloning:
git submodule update --init --recursive
```
