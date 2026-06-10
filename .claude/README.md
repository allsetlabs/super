# Claude Code Agents & Commands

AI agent system for this monorepo. Agents are specialized for different modules and tasks.

> This directory is the **Claude Code adapter**. Canonical instructions live in the root `AGENTS.md` (CLAUDE.md is a symlink), and all skills live in `.agents/skills/` so Codex, Copilot CLI, and Kimi CLI can use them too. Copilot mirrors of the subagents live in `.github/agents/` — when editing an agent here, update the mirror.

## Structure

```
.claude/
├── agents/
│   ├── development/           # Module-specific development agents
│   │   ├── frontend-dev.md    # React/TypeScript for portfolio & Seekr frontends
│   │   ├── backend-dev.md     # Python FastAPI for Seekr backend
│   │   ├── component-lib.md   # Shared component library
│   │   ├── platform-dev.md    # Chrome extension, Electron, Capacitor
│   │   └── test-dev.md        # Testing (Vitest, pytest, E2E)
│   ├── code-analyzer.md       # Pattern discovery & reuse
│   ├── implementation-planner.md  # Task breakdown & planning
│   ├── seekr-web-tester.md    # Browser testing with Playwright
│   └── whole-prompt-analyzer.md   # Conversation analysis
├── commands/                  # Claude-only slash commands (orchestrate, cleanup-tasks)
├── skills/ → ../.agents/skills/   # Symlink — skills live in .agents/skills (cross-tool)
│   │
│   │   # Module skills (one per module; SKILL.md indexes topic files)
│   ├── devbot/                # backend.md, crud-patterns.md, worker-patterns.md, plugin-install.md, create-project.md
│   ├── seekr/                 # Video/meme toolkit: download, caption, GIF, thumbnail, uploads, create-meme
│   ├── meme-vault/            # delete-meme.md
│   ├── forge/                 # Component/CSS standards + google-oauth.md, update-docs.md
│   │
│   │   # Generic skills (apply to every module)
│   ├── coding-standards/      # Rules + clean-code guides (typescript, react, pagination, ios)
│   ├── code-review-checklist/ # 120+ review checks
│   ├── git-workflow/          # Branch protection, naming, commit standards
│   ├── page-size-guard/       # 200-line component limit
│   ├── context/               # Personal context (resume, work, family)
│   │
│   │   # Downloaded skills (skills-lock.json — do not edit)
│   └── deploy-to-vercel/, tanstack-*/, vercel-*/, web-design-guidelines/, remotion-best-practices/
└── tasks/                     # Task execution workspace
```

## Agents

### Development Agents

| Agent           | Use For                                                   | Module Scope                                                       |
| --------------- | --------------------------------------------------------- | ------------------------------------------------------------------ |
| `frontend-dev`  | React/TypeScript UI components                            | portfolio, seekr/web, seekr/extension, seekr/desktop, seekr/mobile |
| `backend-dev`   | Python FastAPI endpoints, database                        | seekr/backend                                                      |
| `component-lib` | Shared React components (affects ALL modules)             | modules/component                                                  |
| `platform-dev`  | Platform-specific code (Chrome APIs, Electron, Capacitor) | seekr/extension, seekr/desktop, seekr/mobile                       |
| `test-dev`      | Writing tests                                             | All modules                                                        |

### Utility Agents

| Agent                    | Use For                                                |
| ------------------------ | ------------------------------------------------------ |
| `code-analyzer`          | Finding reusable patterns before building new features |
| `implementation-planner` | Breaking down complex features into actionable tasks   |
| `seekr-web-tester`       | Browser testing with Playwright MCP for Seekr web      |
| `whole-prompt-analyzer`  | Extracting optimized prompts from conversation history |

## Slash Commands

Only Claude-mechanics-dependent commands remain here; everything else was migrated to `.agents/skills/` so all AI CLIs can run them (in Claude they're still invoked as `/name`).

| Command          | Description                                              |
| ---------------- | -------------------------------------------------------- |
| `/orchestrate`   | Feature development workflow (analysis → plan → execute) |
| `/cleanup-tasks` | Archive or remove old task directories                   |

Former commands now living in `.agents/skills/`: architect, db-upgrade, dedup (includes `--report` mode, absorbed code-duplication-analysis), discover-skills, docker-clean, fix-auto-fixable-standards, fix-coding-standards, product-ideas, sync-api, sync-coding-standards, sync-docs, tailor-resume. Module-specific ones moved into their module skill: delete-meme → meme-vault, update-component-docs → forge.

## Skills

Skills are auto-discovered by Claude and used when relevant. Unlike slash commands (user-invoked), skills are triggered by Claude when it determines they're needed.

| Skill                                    | Description                                                           | Trigger                                  |
| ---------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------- |
| `context`                                | Personal context (resume, work, family info)                          | Session needs user background info       |
| `coding-standards`                       | Generic coding rules + clean-code guides (TS, React, pagination, iOS) | Writing or reviewing code anywhere       |
| `git-workflow`                           | Git workflow: branch protection, naming, commit standards             | Any git operation                        |
| `code-review-checklist`                  | 120+ checks across security, bugs, perf, TS, React, Node, DB          | Reviewing PRs or completing features     |
| `page-size-guard`                        | Warns when pages/components exceed 200-line limit, guides extraction  | Editing pages/components in any module   |
| `forge`                                  | Forge component/CSS standards + Google OAuth + component docs         | Editing .tsx files in any module         |
| `devbot`                                 | DevBot module: backend API, CRUD/worker patterns, plugins, projects   | Working in forge-modules/devbot          |
| `seekr`                                  | Seekr video/meme toolkit: download, caption, GIF, thumbnail, upload   | Any video processing or meme task        |
| `meme-vault`                             | Meme Vault management (delete memes from Supabase/GitHub/Instagram)   | Working in forge-modules/meme-vault      |
| `remotion-best-practices`                | Remotion video creation with React (animations, compositions, timing) | User is working with Remotion code       |
| `deploy-to-vercel`                       | Deploy applications and websites to Vercel                            | User requests deployment to Vercel       |
| `tanstack-query-best-practices`          | TanStack Query caching, mutations, and server state patterns          | Building data-driven React apps          |
| `tanstack-router-best-practices`         | Type-safe routing, data loading, search params                        | React apps with complex routing          |
| `tanstack-start-best-practices`          | Full-stack React with server functions, SSR, middleware               | Full-stack TanStack Start apps           |
| `tanstack-integration-best-practices`    | TanStack Query + Router + Start integration patterns                  | Full-stack data flow and SSR             |
| `vercel-composition-patterns`            | React composition patterns for scalable component APIs                | Refactoring components, building libs    |
| `vercel-react-best-practices`            | React/Next.js performance optimization from Vercel Engineering        | Writing/reviewing React/Next.js code     |
| `vercel-react-native-skills`             | React Native/Expo best practices for performant mobile apps           | Building React Native components         |
| `web-design-guidelines`                  | Review UI code for Web Interface Guidelines compliance                | UI review, accessibility audit           |

### seekr (create-meme pipeline)

**Location:** `.agents/skills/seekr/` (see `create-meme.md`)

Complete meme creation pipeline from YouTube URL. All steps are mandatory:

1. Download video from YouTube URL
2. Add caption to video
3. Convert to GIF
4. Create thumbnail
5. Extract audio
6. Upload to GitHub
7. Upload to Instagram
8. Save to database

**Creates:**

- `source.mp4` - Downloaded video
- `video.mp4` - Captioned video (480p)
- `audio.mp3` - Audio track (128kbps)
- `captioned.gif` - Animated GIF
- `thumbnail.png` - Preview image

**Run directly:**

```bash
cd forge-modules/meme-vault && npx tsx independent_node_skills/create-meme.ts \
  --url "https://youtube.com/watch?v=xxx" --start 10 --stop 25 --caption "Ennada!"
```

### remotion-best-practices

**Location:** `.claude/skills/remotion-best-practices/` (symlink to `.agents/skills/`)

Remotion agent skill for programmatic video creation with React. Provides domain-specific knowledge for animations, compositions, timing, audio, captions, 3D, charts, transitions, and more. Installed via `npx skills add remotion-dev/skills`.

**Setup a Remotion project:**

```bash
npx create-video@latest
cd my-video && npm install && npm run dev
```

**34 rule files** covering: 3D, animations, assets, audio, audio-visualization, calculate-metadata, charts, compositions, display-captions, extract-frames, ffmpeg, fonts, gifs, images, light-leaks, lottie, maps, measuring-dom-nodes, measuring-text, parameters, sequencing, subtitles, tailwind, text-animations, timing, transcribe-captions, transitions, transparent-videos, trimming, videos, and more.

**Update:** `npx remotion skills update`

### seekr Topic Files

The `seekr` skill (`.agents/skills/seekr/`) indexes one topic file per task:

- **download-yt-video.md**: Download YouTube videos with optional segment extraction
- **add-caption-to-video.md**: Burn text captions into videos
- **video-to-gif.md**: High-quality GIF conversion with palette optimization
- **video-to-thumbnail.md**: Extract frame at specific timestamp
- **upload-github-meme-vault-clip.md**: Upload to meme-vault GitHub repo
- **upload-instagram-meme-vault-clip.md**: Post as Instagram Reel

**Dependencies:**

```bash
# Required for video processing
brew install ffmpeg yt-dlp
```

## Usage

### Invoke Agent via Task Tool

```
Use subagent_type="frontend-dev" for React work
Use subagent_type="backend-dev" for Python API work
Use subagent_type="component-lib" for shared components
```

### Run Slash Command

```
/orchestrate add user authentication to Seekr web
/cleanup-tasks
/clip-youtube https://youtube.com/watch?v=xxx 30 60
```

## Quick Reference

- **Before creating components**: Check `modules/component` first
- **Custom colors only**: Never use default Tailwind colors
- **After code changes**: Run `npm run lint` and `npm run type-check`
