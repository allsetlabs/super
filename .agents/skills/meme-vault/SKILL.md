---
name: meme-vault
description: Meme Vault module skill — manage memes stored across Supabase, GitHub, and Instagram, plus API reference for the clips/auth routes. Use when working in forge-modules/meme-vault, integrating with its APIs, or when the user asks to delete or manage memes.
---

# Meme Vault

Entry point for Meme Vault management tasks. Load only the topic file you need:

| Topic | File | When to load |
|-------|------|--------------|
| Delete meme | [delete-meme.md](delete-meme.md) | Removing a meme from Supabase, GitHub assets, and Instagram |
| API reference | [api.md](api.md) | Calling or integrating with the Meme Vault APIs (clips CRUD, job queue, Google login) |

Meme *creation* tooling (download, caption, GIF, upload) lives in the [seekr](../seekr/SKILL.md) skill.
