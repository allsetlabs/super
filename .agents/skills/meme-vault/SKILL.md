---
name: meme-vault
description: Meme Vault module skill — manage memes stored across Supabase, GitHub, and Instagram. Use when working in forge-modules/meme-vault or when the user asks to delete or manage memes.
---

# Meme Vault

Entry point for Meme Vault management tasks. Load only the topic file you need:

| Topic | File | When to load |
|-------|------|--------------|
| Delete meme | [delete-meme.md](delete-meme.md) | Removing a meme from Supabase, GitHub assets, and Instagram |

Meme *creation* tooling (download, caption, GIF, upload) lives in the [seekr](../seekr/SKILL.md) skill.
