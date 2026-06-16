# Video to Thumbnail

Extract a thumbnail image from a video at a specific timestamp.

## When to Use

- Create preview image from video
- Extract frame at specific time
- Generate video thumbnail

## Command

```bash
cd forge-modules/meme-vault && npx tsx independent_node_skills/video-to-thumbnail.ts \
  --input <video> --output <image>
```

## Options

| Option      | Required | Description                       |
| ----------- | -------- | --------------------------------- |
| `--input`   | Yes      | Input video file                  |
| `--output`  | Yes      | Output image file (png/jpg)       |
| `--time`    | No       | Timestamp in seconds (default: 0) |
| `--quality` | No       | JPEG quality 1-31 (default: 2)    |
| `--width`   | No       | Output width in pixels            |

## Examples

```bash
# Thumbnail at start
cd forge-modules/meme-vault && npx tsx independent_node_skills/video-to-thumbnail.ts \
  --input ./video.mp4 --output ./thumb.png

# Thumbnail at 5 seconds
cd forge-modules/meme-vault && npx tsx independent_node_skills/video-to-thumbnail.ts \
  --input ./video.mp4 --output ./thumb.png --time 5

# Smaller thumbnail
cd forge-modules/meme-vault && npx tsx independent_node_skills/video-to-thumbnail.ts \
  --input ./video.mp4 --output ./thumb.png --time 3 --width 320
```

## User Examples

```
User: Create a thumbnail from ./video.mp4 at 10 seconds
Claude: [Runs video-to-thumbnail with --time 10]
```
