# super

All projects as git submodules. No code lives here.

Modules are organized under `modules/` with category subdirectories (e.g. `modules/forge-modules/` for projects built on the `forge` component library, with subgroups for related projects). The authoritative module list is `.gitmodules` — or run:

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

Onboard the module per the Standards section in this repo's root `AGENTS.md`.
