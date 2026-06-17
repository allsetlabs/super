# Upload Instagram Meme Vault Clip

Upload a meme vault clip to Instagram as a Reel.

## When to Use

- Post meme to Instagram
- Upload video as Instagram Reel
- Share clip on Instagram

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
cd modules/forge-modules/meme-vault && npx tsx independent_node_skills/upload-instagram.ts \
  --url <video-url> --caption <text> --env-path <selected-env-file>
```

## Options

| Option       | Required | Description                                    |
| ------------ | -------- | ---------------------------------------------- |
| `--url`      | Yes      | Public URL to the video file                   |
| `--caption`  | Yes      | Caption for the Reel                           |
| `--env-path` | Yes      | Path to env file (from user selection)         |
| `--max-wait` | No       | Max wait attempts for processing (default: 30) |
| `--interval` | No       | Wait interval in ms (default: 5000)            |

## Environment Variables

Loaded from the selected env file.

| Variable                 | Required | Description                           |
| ------------------------ | -------- | ------------------------------------- |
| `INSTAGRAM_ACCESS_TOKEN` | Yes      | Instagram Graph API access token      |
| `INSTAGRAM_USER_ID`      | Yes      | Instagram Business/Creator account ID |

## Requirements

- Instagram Business or Creator account
- Account connected to a Facebook Page
- Access token with permissions: `instagram_basic`, `instagram_content_publish`
- Video must be publicly accessible (e.g., GitHub raw URL)
- Video specs: MP4, H264, max 90 seconds, 9:16 aspect ratio recommended

## Examples

```bash
# Upload video from GitHub to Instagram (with prod env)
cd modules/forge-modules/meme-vault && npx tsx independent_node_skills/upload-instagram.ts \
  --url "https://raw.githubusercontent.com/user/repo/main/clip/video.mp4" \
  --caption "Check this out!" \
  --env-path .env

# Upload with dev env
cd modules/forge-modules/meme-vault && npx tsx independent_node_skills/upload-instagram.ts \
  --url "https://example.com/video.mp4" \
  --caption "New meme alert! #memes #funny" \
  --env-path .env.development
```

## User Examples

```
User: Post this clip to Instagram with caption "LOL!"
Claude: [Uses Glob to find env files, asks user to select one, then runs upload-instagram with video URL, caption, and selected env-path]

User: Upload the video to Instagram as a Reel
Claude: [Uses Glob to find env files, asks user to select one, then runs upload-instagram with the GitHub video URL and selected env-path]
```
