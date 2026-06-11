---
name: seekr
description: Seekr video and meme toolkit plus backend API reference — download YouTube videos, burn captions into video, convert video to GIF, extract thumbnails, upload meme vault clips to GitHub or Instagram, run the full meme creation pipeline, or call the Seekr FastAPI backend (auth, resumes, settings, AI chat, TTS/STT). Use for any video processing or meme task, when integrating with Seekr APIs, or when the user mentions Seekr.
---

# Seekr

Entry point for all Seekr video/meme tooling. Load only the topic file you need. If invoked directly (e.g. `/seekr`) with no task or topic, ask the user which operation to run (AskUserQuestion with the options below) — do not guess.

| Topic | File | When to load |
|-------|------|--------------|
| Create meme (full pipeline) | [create-meme.md](create-meme.md) | Creating a meme from a YouTube URL — download → caption → GIF → thumbnail → upload → save |
| Download YouTube video | [download-yt-video.md](download-yt-video.md) | Downloading a full video or segment from YouTube |
| Add caption to video | [add-caption-to-video.md](add-caption-to-video.md) | Burning captions/subtitles into a video file |
| Video to GIF | [video-to-gif.md](video-to-gif.md) | Converting video to animated GIF with palette optimization |
| Video to thumbnail | [video-to-thumbnail.md](video-to-thumbnail.md) | Extracting a thumbnail image at a timestamp |
| Upload clip to GitHub | [upload-github-meme-vault-clip.md](upload-github-meme-vault-clip.md) | Uploading meme vault clip files to the GitHub repo |
| Upload clip to Instagram | [upload-instagram-meme-vault-clip.md](upload-instagram-meme-vault-clip.md) | Posting a meme vault clip as an Instagram Reel |
| API reference | [api.md](api.md) | Calling or integrating with the Seekr backend APIs (auth, resumes, settings, AI chat, TTS/STT) |

Dependencies: `brew install ffmpeg yt-dlp`
