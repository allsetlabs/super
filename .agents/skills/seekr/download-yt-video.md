# Download YouTube Video

Download full videos or segments from YouTube.

## When to Use

- Download YouTube video
- Download a specific segment/clip from YouTube
- Save YouTube video locally

## Command

```bash
cd forge-modules/meme-vault && npx tsx independent_node_skills/download-yt-video.ts \
  --url <youtube-url>
```

## Options

| Option       | Required | Description                          |
| ------------ | -------- | ------------------------------------ |
| `--url`      | Yes      | YouTube video URL                    |
| `--output`   | No       | Output directory (default: current)  |
| `--start`    | No       | Start time for segment               |
| `--stop`     | No       | Stop time for segment                |
| `--quality`  | No       | 'best' or 'worst' (default: best)    |
| `--filename` | No       | Output filename (default: video.mp4) |

## Time Formats

| Format  | Example | Meaning      |
| ------- | ------- | ------------ |
| Seconds | `90`    | 90 seconds   |
| MM:SS   | `1:30`  | 1 min 30 sec |
| mm.ss   | `1.30`  | 1 min 30 sec |

## Examples

```bash
# Download full video
cd forge-modules/meme-vault && npx tsx independent_node_skills/download-yt-video.ts \
  --url "https://youtube.com/watch?v=xxx" --output ~/Downloads

# Download segment (30s to 60s)
cd forge-modules/meme-vault && npx tsx independent_node_skills/download-yt-video.ts \
  --url "https://youtube.com/watch?v=xxx" --start 30 --stop 60

# Download lowest quality
cd forge-modules/meme-vault && npx tsx independent_node_skills/download-yt-video.ts \
  --url "https://youtube.com/watch?v=xxx" --quality worst
```

## User Examples

```
User: Download this YouTube video https://youtube.com/watch?v=xxx
Claude: [Runs download-yt-video with the URL]

User: Download from 1:30 to 2:00 of https://youtube.com/watch?v=xxx
Claude: [Runs download-yt-video with --start 1.30 --stop 2.00]
```
