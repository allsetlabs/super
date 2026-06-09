# Claude Code Agents & Commands

AI agent system for this monorepo. Agents are specialized for different modules and tasks.

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
├── commands/                  # Slash commands (user-invoked)
├── skills/                    # Skills (Claude auto-discovers and uses)
│   ├── component-google-oauth-auth/  # Google OAuth authentication flow
│   ├── context/               # Personal context (resume, work, family)
│   ├── devbot-backend/        # DevBot backend API reference
│   ├── devbot-commit/         # Git commit workflow
│   ├── remotion-best-practices/  # Remotion video creation with React (symlink)
│   ├── seekr-add-caption-to-video/  # Burn captions into video
│   ├── seekr-create-meme/     # Complete meme pipeline (download → upload)
│   ├── seekr-download-yt-video/  # Download YouTube videos
│   ├── seekr-upload-github-meme-vault-clip/  # Upload clips to GitHub
│   ├── seekr-upload-instagram-meme-vault-clip/  # Upload clips to Instagram
│   ├── seekr-video-to-gif/    # Convert video to GIF
│   ├── seekr-video-to-thumbnail/  # Extract thumbnail from video
│   ├── deploy-to-vercel/     # Vercel deployment automation
│   ├── devbot-backend-crud-patterns/  # CRUD route pattern enforcement
│   ├── devbot-css-standards/  # CSS/component library enforcement
│   ├── devbot-plugin-install/  # Plugin installation from GitHub/local
│   ├── devbot-supabase-safety/  # Supabase query error checking
│   ├── devbot-page-size-guard/  # 200-line component limit guard
│   ├── devbot-worker-patterns/  # Claude CLI worker process patterns
│   ├── devbot-capacitor-best-practices/  # Capacitor mobile best practices
│   ├── devbot-code-review/  # Comprehensive code review checklist
│   ├── tanstack-query-best-practices/  # TanStack Query patterns
│   ├── tanstack-router-best-practices/  # TanStack Router patterns
│   ├── tanstack-start-best-practices/  # TanStack Start patterns
│   ├── tanstack-integration-best-practices/  # TanStack integration
│   ├── vercel-composition-patterns/  # React composition patterns
│   ├── vercel-react-best-practices/  # React/Next.js performance
│   ├── vercel-react-native-skills/  # React Native/Expo best practices
│   └── web-design-guidelines/  # Web Interface Guidelines compliance
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

| Command                  | Description                                                                       |
| ------------------------ | --------------------------------------------------------------------------------- |
| `/architect`             | Create implementation plan for a feature                                          |
| `/cleanup-tasks`         | Archive or remove old task directories                                            |
| `/dedup`                 | Analyze code for duplicacy, create reusable utils, refactor to reduce duplication |
| `/delete-meme`           | Delete a meme from Meme Vault (Supabase, GitHub, Instagram)                       |
| `/discover-skills`       | Discover public Claude Code skills and improvements for code quality              |
| `/db-upgrade`            | Apply pending Supabase migrations to DevBot DB without data loss                  |
| `/docker-clean`          | Clean up Docker containers, images, volumes, and networks                         |
| `/orchestrate`           | Feature development workflow (analysis → plan → execute)                          |
| `/product-ideas`         | Analyze module, search web for improvements, save plans to Plans route            |
| `/sync-api`              | Read backend routes and update devbot-backend skill to match current API          |
| `/sync-docs`             | Deep analyze codebase and sync all documentation (CLAUDE.md, agents, commands)    |
| `/tailor-resume`         | Generate tailored resume for job applications                                     |
| `/update-component-docs` | Sync component library documentation after changes                                |

## Skills

Skills are auto-discovered by Claude and used when relevant. Unlike slash commands (user-invoked), skills are triggered by Claude when it determines they're needed.

| Skill                                    | Description                                                           | Trigger                                  |
| ---------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------- |
| `context`                                | Personal context (resume, work, family info)                          | Session needs user background info       |
| `devbot-commit`                          | Git commit workflow with proper formatting                            | User wants to commit changes             |
| `devbot-backend`                         | DevBot backend API reference for sessions, chats, uploads             | User needs to interact with DevBot APIs  |
| `component-google-oauth-auth`            | Google OAuth authentication flow                                      | User needs Google OAuth login            |
| `remotion-best-practices`                | Remotion video creation with React (animations, compositions, timing) | User is working with Remotion code       |
| `seekr-create-meme`                      | Complete meme pipeline: download → caption → GIF → thumbnail → upload | User wants to create a meme from YouTube |
| `seekr-download-yt-video`                | Download full videos or segments from YouTube                         | User wants to download YouTube video     |
| `seekr-add-caption-to-video`             | Burn text captions into video files                                   | User wants to add captions to video      |
| `seekr-video-to-gif`                     | Convert video to animated GIF                                         | User wants to convert video to GIF       |
| `seekr-video-to-thumbnail`               | Extract thumbnail from video                                          | User wants thumbnail from video          |
| `seekr-upload-github-meme-vault-clip`    | Upload clip assets to GitHub                                          | User wants to upload clip to GitHub      |
| `seekr-upload-instagram-meme-vault-clip` | Upload video as Instagram Reel                                        | User wants to post to Instagram          |
| `deploy-to-vercel`                       | Deploy applications and websites to Vercel                            | User requests deployment to Vercel       |
| `devbot-backend-crud-patterns`           | Enforces consistent CRUD route patterns in DevBot backend             | Editing routes in devbot/backend         |
| `devbot-css-standards`                   | Enforces no raw HTML, no default Tailwind colors, component lib usage | Editing .tsx files in devbot/app         |
| `devbot-plugin-install`                  | Install DevBot plugins from GitHub URL or local path                  | User wants to install a DevBot plugin    |
| `devbot-supabase-safety`                 | Enforces error checking on all Supabase .from() queries               | Editing .ts files in devbot/backend      |
| `devbot-page-size-guard`                 | Warns when pages/components exceed 200-line limit, guides extraction  | Editing pages/components in devbot/app   |
| `devbot-worker-patterns`                 | Enforces Claude CLI worker process patterns (spawn, parse, persist)   | Editing worker files in devbot/backend   |
| `devbot-capacitor-best-practices`        | Capacitor mobile best practices (safe areas, keyboard, network)       | Editing files in devbot/app              |
| `devbot-code-review`                     | 120+ checks across security, bugs, perf, TS, React, Node, Supabase    | Reviewing PRs or completing features     |
| `tanstack-query-best-practices`          | TanStack Query caching, mutations, and server state patterns          | Building data-driven React apps          |
| `tanstack-router-best-practices`         | Type-safe routing, data loading, search params                        | React apps with complex routing          |
| `tanstack-start-best-practices`          | Full-stack React with server functions, SSR, middleware               | Full-stack TanStack Start apps           |
| `tanstack-integration-best-practices`    | TanStack Query + Router + Start integration patterns                  | Full-stack data flow and SSR             |
| `vercel-composition-patterns`            | React composition patterns for scalable component APIs                | Refactoring components, building libs    |
| `vercel-react-best-practices`            | React/Next.js performance optimization from Vercel Engineering        | Writing/reviewing React/Next.js code     |
| `vercel-react-native-skills`             | React Native/Expo best practices for performant mobile apps           | Building React Native components         |
| `web-design-guidelines`                  | Review UI code for Web Interface Guidelines compliance                | UI review, accessibility audit           |

### seekr-create-meme

**Location:** `.claude/skills/seekr-create-meme/`

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
cd modules/meme-vault && npx tsx independent_node_skills/create-meme.ts \
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

### Individual Skills

Each skill in `.claude/skills/` has a `SKILL.md` file with usage instructions. Key skills:

- **seekr-download-yt-video**: Download YouTube videos with optional segment extraction
- **seekr-add-caption-to-video**: Burn text captions into videos
- **seekr-video-to-gif**: High-quality GIF conversion with palette optimization
- **seekr-video-to-thumbnail**: Extract frame at specific timestamp
- **seekr-upload-github-meme-vault-clip**: Upload to meme-vault GitHub repo
- **seekr-upload-instagram-meme-vault-clip**: Post as Instagram Reel

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
