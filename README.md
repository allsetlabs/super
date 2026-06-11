# super

All projects as git submodules. No code lives here.

Modules are organized under category directories (e.g. `forge-modules/` for projects built on the `forge` component library, with subgroups for related projects). The authoritative module list is `.gitmodules` — or run:

```bash
git submodule status
```

## Setup

```bash
git clone --recurse-submodules <repo-url>
# or after cloning:
git submodule update --init --recursive
```

## Adding a module

Never clone code into this repo — always `git submodule add`. See `.agents/skills/super/how-to-organize-module.md` for categorization and placement, then onboard the module per `.agents/skills/super/module-standards-to-follow.md`.
