# 0016 — Super Repo Made Public

**Date**: 2026-06-27
**Status**: Accepted

## Context

The super repo (github.com/allsetlabs/super) was previously private. It holds all project skills, agent configurations, hooks, and standards for the allsetlabs monorepo. The user wanted to publish home-grown skills so they could be installed on other machines using `npx skills add`.

## Decision

Make the super repo public at https://github.com/allsetlabs/super so skills can be installed directly from it without a separate public skills mirror repo.

## Rationale

The `npx skills add` CLI installs from GitHub repos. Making the super repo public is the simplest path: no separate mirror repo to maintain, no manual sync step, and skills stay in their canonical location. The repo contains no secrets — hooks, skills, and standards are all config/documentation.

## Consequences

- Any machine can now install skills with `npx skills add allsetlabs/super --skill <name> [-g]`
- All content in the repo (AGENTS.md, hooks, skills, standards, docs) is publicly visible
- If sensitive content is ever added to the repo, it must be moved to a private submodule first
- The org is `allsetlabs`, not the personal `subbiah2806` account — team members can also install skills without needing personal repo access
