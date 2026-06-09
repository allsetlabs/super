# Super Repo

All projects live here as git submodules. No code exists in this repo itself.

## Before You Start

**Ask the user: Which project do you want to work on?**

Then navigate to that module directory before making any changes.

## Module Organization Rule

**Always group similar projects into subcategories inside `forge-modules/`.** Do not add new submodules as flat entries under `forge-modules/` if they belong to an existing group or form a new group of 2+.

Examples:
- TVK political sites → `forge-modules/tvk/`
- If new Seekr-adjacent tools are added → `forge-modules/seekr-tools/`
- Standalone projects with no siblings stay flat: `forge-modules/devbot/`, `forge-modules/portfolio/`

## Module Map

| Path | Project |
|------|---------|
| `forge-modules/forge` | `forge` component library (`@allsetlabs/reusable`) |
| `forge-modules/devbot` | DevBot personal assistant app |
| `forge-modules/portfolio` | Personal portfolio website |
| `forge-modules/seekr` | Seekr product suite |
| `forge-modules/meme-vault` | Meme creation platform |
| `forge-modules/tn-crime` | TN crime analytics dashboard |
| `forge-modules/tvk/namma` | Namma TVK campaign site |
| `forge-modules/tvk/why` | Why TVK informational site |
| `forge-modules/tvk/manifesto` | TVK manifesto site (Astro) |
| `forge-modules/tvk/2026` | TVK 2026 election campaign site |

See `README.md` for descriptions of each module.
