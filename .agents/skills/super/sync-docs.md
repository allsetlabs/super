# sync-docs — Module Documentation in the Super Repo

Maintain one documentation folder per module in the super repo at `docs/<module-directory-path>/` (mirroring the module's path in the repo). Each folder has an `index.md` built from the module's code and git commit history. Supporting files are allowed, but **every file in the folder must be linked from `index.md`** — no orphan docs.

## Output Layout

```
docs/
├── index.md                                  # table of all modules linking to each module's index.md
├── <module-directory-path>/index.md          # one folder per module, mirroring its repo path
├── <category>/<nested-module-path>/index.md  # nested modules mirror their nesting
└── ...
```

## Incremental Sync via Commit SHA

Each module's `index.md` starts with frontmatter:

```markdown
---
module: <module-directory-path>
last_synced_commit: <full sha of module HEAD at last sync>
last_synced: <YYYY-MM-DD>
---
```

- **First run (no doc or no frontmatter):** full sync — read the module's structure, key code, and full commit history (`git log --oneline` inside the module).
- **Subsequent runs:** inside the module run `git log <last_synced_commit>..HEAD --stat`. If empty, the module is in sync — skip it. Otherwise read the new commits (and the files they touched) and update only the affected sections.
- Always update `last_synced_commit` to the module's current HEAD after syncing.

## index.md Content

Write for an AI or developer who has never seen the module:

1. **Overview** — what the module is and its goal (source: module `AGENTS.md` + code)
2. **Tech stack** — languages, frameworks, key deps (source: `package.json` / `pyproject.toml`)
3. **Architecture** — top-level structure, services, how parts connect; link to the module's API reference doc (see [sync-api.md](sync-api.md)) if it has a backend
4. **How to run** — the module's `make setup` / `make install` / `make start` and ports
5. **Recent changes** — short changelog distilled from commit history since last sync (newest first; keep the section trimmed to the last ~20 entries)
6. **Links** — module `AGENTS.md`, supporting doc files in this folder

Split big topics (e.g. `architecture.md`, `deployment.md`) into supporting files in the same folder and link them from `index.md`.

## Steps

1. **List modules:** `git submodule status` from the super repo root — never use a hardcoded module list. Mirror each module's path under `docs/`. Skip untracked directories that are not submodules.
2. **Per module:** read the existing `index.md` frontmatter, compute the commit delta, do a full or incremental sync as above.
3. **Update the root `docs/index.md`** — one row per module: name, one-line description, link to its `index.md`. Add new modules, remove deleted ones.
4. **Verify no orphans:** every file under `docs/<module-directory-path>/` must be reachable from that module's `index.md`.

## Rules

1. **Docs describe reality** — derive content from code and commits, not from what older docs claim
2. **Minimal diffs on incremental runs** — only touch sections affected by new commits
3. **No secrets** — never copy env values or keys into docs
4. **Lean** — these docs are read by AIs; every line consumes context. Summarize, link to code, don't paste large code blocks.

## Report

```
## Docs Sync Complete

**Last synced:** [current date in YYYY-MM-DD format]

### Updated
- <module>: [n] new commits since [old sha → new sha] — [sections updated]

### Created (first sync)
- <module>

### Already in sync
- <module>
```
