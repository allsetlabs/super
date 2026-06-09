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
| [forge-modules/namma](forge-modules/namma) | Namma TVK — main TVK campaign site (web + mobile + backend) |
| [forge-modules/why](forge-modules/why) | Why TVK — informational website |
| [forge-modules/manifesto](forge-modules/manifesto) | TVK manifesto site (Astro) |
| [forge-modules/2026](forge-modules/2026) | TVK 2026 election campaign site |

## Setup

```bash
git clone --recurse-submodules <repo-url>
# or after cloning:
git submodule update --init --recursive
```
