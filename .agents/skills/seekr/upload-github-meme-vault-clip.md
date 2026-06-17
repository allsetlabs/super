# Upload GitHub Meme Vault Clip

Upload meme vault clip files to a GitHub repository.

## When to Use

- Upload clip assets to GitHub
- Push video, GIF, thumbnail, audio to meme-vault repo
- Store meme files in version control

## Pre-execution Steps

Before running the command, you MUST:

1. **Find available env files** using Glob:

   ```
   Glob pattern: modules/forge-modules/meme-vault/.env*
   ```

2. **Ask user to select an env file** using AskUserQuestion with header "Environment" and options for each found env file (e.g., `.env` for prod, `.env.development` for dev)

3. **Run the command** with the selected `--env-path`

## Command

```bash
cd modules/forge-modules/meme-vault && npx tsx independent_node_skills/upload-github.ts \
  --clip-id <id> --dir <path> --env-path <selected-env-file>
```

## Options

| Option       | Required | Description                                           |
| ------------ | -------- | ----------------------------------------------------- |
| `--clip-id`  | Yes      | Clip ID (folder name in repo)                         |
| `--dir`      | Yes      | Local directory containing clip files                 |
| `--env-path` | Yes      | Path to env file (from user selection)                |
| `--files`    | No       | Comma-separated list of files (default: all 5 assets) |

## Environment Variables

Loaded from the selected env file.

| Variable                    | Required | Description                       |
| --------------------------- | -------- | --------------------------------- |
| `GITHUB_TOKEN`              | Yes      | GitHub personal access token      |
| `NEXT_PUBLIC_GITHUB_REPO`   | Yes      | Repository (format: owner/repo)   |
| `NEXT_PUBLIC_GITHUB_BRANCH` | No       | Branch to push to (default: main) |

## Default Files Uploaded

- `source.mp4` - Original video
- `video.mp4` - Captioned video
- `audio.mp3` - Audio track
- `captioned.gif` - Animated GIF
- `thumbnail.png` - Preview image

## Examples

```bash
# Upload all clip assets (with prod env)
cd modules/forge-modules/meme-vault && npx tsx independent_node_skills/upload-github.ts \
  --clip-id abc123_20240101_120000 --dir ./output --env-path .env

# Upload specific files only (with dev env)
cd modules/forge-modules/meme-vault && npx tsx independent_node_skills/upload-github.ts \
  --clip-id abc123 --dir ./meme --files video.mp4,thumbnail.png --env-path .env.development
```

## User Examples

```
User: Upload this clip to GitHub with ID my_clip_001
Claude: [Uses Glob to find env files, asks user to select one, then runs upload-github with --clip-id my_clip_001 and selected env-path]

User: Push the meme assets to the repo
Claude: [Uses Glob to find env files, asks user to select one, then runs upload-github with clip ID, directory, and selected env-path]
```
