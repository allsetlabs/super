---
name: seekr-create-meme
description: Complete meme creation pipeline from YouTube URL. Downloads, captions, converts to GIF, uploads to GitHub/Instagram, and saves to database.
---

# Create Meme - Complete Pipeline

Complete meme creation pipeline from YouTube URL. All steps are mandatory.

## Pipeline Steps

1. Download video from YouTube URL
2. Add caption to video
3. Convert to GIF
4. Create thumbnail
5. Extract audio
6. Upload to GitHub
7. Upload to Instagram
8. Save to database

## What It Creates

| File            | Description            |
| --------------- | ---------------------- |
| `source.mp4`    | Downloaded video       |
| `video.mp4`     | Captioned video (480p) |
| `audio.mp3`     | Audio track (128kbps)  |
| `captioned.gif` | Animated GIF           |
| `thumbnail.png` | Preview image          |

## Command

```bash
cd modules/meme-vault && npx tsx independent_node_skills/create-meme.ts \
  --url <youtube-url> --start <seconds> --stop <seconds>
```

## Required Options

| Option           | Description           |
| ---------------- | --------------------- |
| `--url <url>`    | YouTube URL           |
| `--start <secs>` | Start time in seconds |
| `--stop <secs>`  | Stop time in seconds  |

## Optional Options

| Option               | Description                              |
| -------------------- | ---------------------------------------- |
| `--output <path>`    | Output directory (default: temp)         |
| `--clip-id <id>`     | Custom clip ID (default: auto-generated) |
| `--caption <text>`   | Caption to burn into video               |
| `--thumbnail <secs>` | Timestamp for thumbnail (default: 0)     |
| `--width <n>`        | Video width (default: 480)               |
| `--gif-fps <n>`      | GIF frames per second (default: 10)      |
| `--gif-colors <n>`   | GIF max colors (default: 64)             |
| `--name <name>`      | Clip name for database                   |
| `--tags <tags>`      | Comma-separated tags                     |

## Required Environment Variables

```
GITHUB_TOKEN              GitHub personal access token
NEXT_PUBLIC_GITHUB_REPO   GitHub repo (owner/repo)
INSTAGRAM_ACCESS_TOKEN    Instagram Graph API token
INSTAGRAM_USER_ID         Instagram user ID
SUPABASE_URL              Supabase project URL
SUPABASE_ANON_KEY         Supabase anon key
```

## Examples

```bash
# Basic usage
cd modules/meme-vault && npx tsx independent_node_skills/create-meme.ts \
  --url "https://youtube.com/watch?v=abc123" --start 10 --stop 25

# With caption and metadata
cd modules/meme-vault && npx tsx independent_node_skills/create-meme.ts \
  --url "https://youtube.com/watch?v=abc123" \
  --start 10 --stop 25 --caption "Ennada!" \
  --name "Funny Clip" --tags "comedy,tamil"
```

## User Examples

```
User: Create a meme from YouTube video X from 10s to 25s with caption "Nice!"
Claude: [Runs create-meme with --url, --start, --stop, --caption]

User: Make a clip from this YouTube link
Claude: [Runs create-meme - will download, create assets, upload to GitHub/Instagram, save to DB]
```

## Programmatic Usage

```typescript
import { createMeme } from './create-meme';

const result = await createMeme({
  url: 'https://youtube.com/watch?v=abc123',
  startSeconds: 10,
  stopSeconds: 25,
  caption: 'Ennada!',
  name: 'Funny Clip',
  tags: ['comedy', 'tamil'],
});

// Result includes:
// - clipId: string
// - outputDir: string
// - files: { source, video, audio, gif, thumbnail }
// - duration: number
// - githubUrl: string
// - githubUrls: { source, video, audio, gif, thumbnail }
// - instagramReelUrl: string
// - dbSaved: boolean
```
