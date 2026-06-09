---
name: seekr-add-caption-to-video
description: Burn captions/subtitles into a video file.
---

# Add Caption to Video

Burn captions/subtitles into a video file.

## When to Use

- Add text overlay to a video
- Burn subtitles into video
- Add meme captions to clips

## Command

```bash
cd modules/meme-vault && npx tsx independent_node_skills/add-caption-to-video.ts \
  --input <video> --output <video> --caption "text"
```

## Options

| Option           | Required | Description                   |
| ---------------- | -------- | ----------------------------- |
| `--input`        | Yes      | Input video file              |
| `--output`       | Yes      | Output video file             |
| `--caption`      | Yes      | Text to burn into video       |
| `--font-size`    | No       | Font size (default: 22)       |
| `--video-width`  | No       | Output width (default: 480)   |
| `--font-color`   | No       | Font color (default: white)   |
| `--border-color` | No       | Border color (default: black) |

## Examples

```bash
# Basic caption
cd modules/meme-vault && npx tsx independent_node_skills/add-caption-to-video.ts \
  --input ./video.mp4 --output ./captioned.mp4 --caption "Hello World!"

# Large text
cd modules/meme-vault && npx tsx independent_node_skills/add-caption-to-video.ts \
  --input ./video.mp4 --output ./captioned.mp4 --caption "BIG TEXT" --font-size 36
```

## User Examples

```
User: Add caption "Ennada!" to this video ./clip.mp4
Claude: [Runs add-caption-to-video with --caption "Ennada!"]
```
