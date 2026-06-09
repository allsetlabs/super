# super

All projects as git submodules. No code lives here.

## forge-modules/ — All projects using `forge` component library

| Module | Description |
|--------|-------------|
| [forge-modules/forge](forge-modules/forge) | `forge` — shared React component library (`@allsetlabs/reusable`) |
| [forge-modules/devbot](forge-modules/devbot) | DevBot personal assistant app; Claude Code terminal proxy via xterm.js + tmux |
| [forge-modules/portfolio](forge-modules/portfolio) | Personal portfolio website |
| [forge-modules/seekr](forge-modules/seekr) | Seekr product suite — web, Chrome extension, Electron desktop, mobile, Python backend |
| [forge-modules/meme-vault](forge-modules/meme-vault) | Meme creation and distribution platform (Next.js) |
| [forge-modules/tn-crime](forge-modules/tn-crime) | Tamil Nadu crime analytics dashboard |

### forge-modules/tvk/ — TVK political & campaign sites

| Module | Description |
|--------|-------------|
| [forge-modules/tvk/namma](forge-modules/tvk/namma) | Namma TVK — main campaign site (web + mobile + backend) |
| [forge-modules/tvk/why](forge-modules/tvk/why) | Why TVK — informational website |
| [forge-modules/tvk/manifesto](forge-modules/tvk/manifesto) | TVK manifesto site (Astro) |
| [forge-modules/tvk/2026](forge-modules/tvk/2026) | TVK 2026 election campaign site |

## Setup

```bash
git clone --recurse-submodules <repo-url>
# or after cloning:
git submodule update --init --recursive
```
