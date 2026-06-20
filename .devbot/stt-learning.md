# STT User Learning

This file is automatically maintained to improve speech-to-text accuracy.
It is referenced before every voice transcription as vocabulary hints for the whisper model.

Corrections are also stored as structured JSON in `~/.devbot/stt-corrections.json` and applied via Ollama (llama3.2:3b) after each whisper transcription.

## Learning Entries

### 2026-06-19 14:28:30

**STT output:** My dad is gifting me just land, my dad is buying this land and they're just saying it in my name.
**User sent:** My dad is gifting me just land, my dad is buying this land and registering it in my name.
**Summary:** Corrected 'they're just saying it' to 'registering it'
**Corrections:**

- "they're just saying it" → "registering it"
