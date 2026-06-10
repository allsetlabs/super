
# Video to GIF

Convert a video to an animated GIF with high quality palette optimization.

## When to Use

- Convert video clip to GIF
- Create animated meme
- Make shareable GIF from video

## Command

```bash
cd forge-modules/meme-vault && npx tsx independent_node_skills/video-to-gif.ts \
  --input <video> --output <gif>
```

## Options

| Option       | Required | Description                      |
| ------------ | -------- | -------------------------------- |
| `--input`    | Yes      | Input video file                 |
| `--output`   | Yes      | Output GIF file                  |
| `--width`    | No       | Width in pixels (default: 480)   |
| `--fps`      | No       | Frames per second (default: 10)  |
| `--colors`   | No       | Max palette colors (default: 64) |
| `--start`    | No       | Start time in seconds            |
| `--duration` | No       | Duration in seconds              |
| `--fast`     | No       | Fast mode (lower quality)        |

## Examples

```bash
# Basic conversion
cd forge-modules/meme-vault && npx tsx independent_node_skills/video-to-gif.ts \
  --input ./video.mp4 --output ./output.gif

# Higher quality
cd forge-modules/meme-vault && npx tsx independent_node_skills/video-to-gif.ts \
  --input ./video.mp4 --output ./output.gif --fps 15 --colors 128

# Partial video (first 5 seconds)
cd forge-modules/meme-vault && npx tsx independent_node_skills/video-to-gif.ts \
  --input ./video.mp4 --output ./output.gif --start 0 --duration 5

# Fast mode for quick preview
cd forge-modules/meme-vault && npx tsx independent_node_skills/video-to-gif.ts \
  --input ./video.mp4 --output ./output.gif --fast
```

## User Examples

```
User: Convert ./clip.mp4 to a GIF
Claude: [Runs video-to-gif]

User: Make a small GIF from the first 3 seconds of ./video.mp4
Claude: [Runs video-to-gif with --duration 3 --width 320]
```
