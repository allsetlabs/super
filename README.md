# super

All projects as git submodules. No code lives here.

## forge-modules/ — Forge component-based projects

| Module | Description |
|--------|-------------|
| [forge-modules/forge](forge-modules/forge) | `forge` — shared React component library (`@allsetlabs/reusable`), used by all forge-modules projects |
| [forge-modules/devbot](forge-modules/devbot) | DevBot personal assistant app; Claude Code terminal proxy via xterm.js + tmux |
| [forge-modules/portfolio](forge-modules/portfolio) | Personal portfolio website |
| [forge-modules/seekr](forge-modules/seekr) | Seekr product suite — web, Chrome extension, Electron desktop, mobile, Python backend |
| [forge-modules/meme-vault](forge-modules/meme-vault) | Meme creation and distribution platform (Next.js) |
| [forge-modules/tn-crime](forge-modules/tn-crime) | Tamil Nadu crime analytics dashboard |

## tvk/ — TVK political projects

| Module | Description |
|--------|-------------|
| [tvk/namma](tvk/namma) | Namma TVK — main TVK campaign site (web + mobile + backend) |
| [tvk/why](tvk/why) | Why TVK — informational website |
| [tvk/manifesto](tvk/manifesto) | TVK manifesto site (Astro) |
| [tvk/2026](tvk/2026) | TVK 2026 election campaign site |

## Setup

```bash
git clone --recurse-submodules <repo-url>
# or after cloning:
git submodule update --init --recursive
```
