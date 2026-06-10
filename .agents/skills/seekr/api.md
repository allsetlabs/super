# Seekr Backend API Reference

Python FastAPI backend for resume management, AI resume chat, and TTS/STT. Source: `forge-modules/seekr/backend/`.

## Connection Details

| Setting      | Value                                                              |
| ------------ | ------------------------------------------------------------------ |
| **Base URL** | `http://<BACKEND_HOST>:<BACKEND_PORT>` — both required in `forge-modules/seekr/.env` (no defaults) |
| **Auth**     | `Authorization: Bearer <JWT>` (from `/api/auth/google-login`, or `/api/auth/login` in development) |
| **Docs**     | Swagger at `/docs`, ReDoc at `/redoc` (FastAPI auto-generated)     |

Always read `forge-modules/seekr/.env` for current values. Never hardcode secrets.

## Health

| Method | Endpoint  | Description                                  |
| ------ | --------- | --------------------------------------------- |
| `GET`  | `/`       | Health check → `{ status: "ok", message }`    |
| `GET`  | `/health` | Health check → `{ status: "healthy", message }` |

## Auth (`/api/auth`) — no auth required except `/me`

| Method | Endpoint                 | Description                                                                 |
| ------ | ------------------------ | ---------------------------------------------------------------------------- |
| `POST` | `/api/auth/google-login` | Google OAuth login (`{ credential }` = Google ID token) → token + user        |
| `POST` | `/api/auth/signup`       | Email/password signup (`{ email, password, name? }`) — **development mode only** (403 otherwise); password min 8 chars |
| `POST` | `/api/auth/login`        | Email/password login (`{ email, password }`) — **development mode only**     |
| `GET`  | `/api/auth/me`           | Get current user (requires Bearer token)                                     |

**Token response:** `{ access_token, token_type: "bearer", user }`
**User shape:** `{ id, google_id, email, name, profile_picture, created_at, updated_at }`

```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"credential":"<google-id-token>"}' \
  http://$BACKEND_HOST:$BACKEND_PORT/api/auth/google-login
```

## Resumes (`/api/resumes`) — auth required, scoped to current user

| Method   | Endpoint                            | Description                                                          |
| -------- | ----------------------------------- | --------------------------------------------------------------------- |
| `GET`    | `/api/resumes`                      | List (`?page=1&page_size=10&name=<keyword>`; page_size max 100; name is case-insensitive partial match) |
| `GET`    | `/api/resumes/{id}`                 | Get single resume (404 if not owned)                                  |
| `POST`   | `/api/resumes`                      | Create (`{ name, resume_json }`) — 201; name unique per user (400 on conflict) |
| `PUT`    | `/api/resumes/{id}`                 | Update (`{ name?, resume_json? }`) — partial update                    |
| `DELETE` | `/api/resumes/{id}`                 | Delete — 204                                                           |
| `PUT`    | `/api/resumes/{id}/set-default`     | Set as default resume (stores `default_resume` user setting) → `{ message, resume_id }` |

**Resume shape:** `{ id, name, user_id, resume_json, ttl, created_at, updated_at }`
**List response:** `{ page, page_size, resumes }` (no total count, by design)

## User Settings (`/api/settings`) — auth required, scoped to current user

| Method   | Endpoint                     | Description                                                          |
| -------- | ---------------------------- | --------------------------------------------------------------------- |
| `GET`    | `/api/settings`              | List (`?page=1&page_size=10&name=<keyword>`)                           |
| `GET`    | `/api/settings/{id}`         | Get by id                                                              |
| `GET`    | `/api/settings/name/{name}`  | Get by exact name                                                      |
| `POST`   | `/api/settings`              | Create (`{ name, value }`) — 201; name unique per user                 |
| `PUT`    | `/api/settings/{id}`         | Update (`{ value? }`)                                                  |
| `DELETE` | `/api/settings/{id}`         | Delete — 204                                                           |

**Setting shape:** `{ id, user_id, name, value, ttl, created_at, updated_at }`

## Chat (`/api/chat`) — AI resume generation

| Method | Endpoint    | Description                                                                |
| ------ | ----------- | --------------------------------------------------------------------------- |
| `POST` | `/api/chat` | Generate/update resume JSON via Claude (`{ messages, file_content? }`)       |

**Request:** `messages` is `[{ role: 'user'|'assistant', content, resume? }]`; `file_content` is optional raw resume text for initial extraction. If both `file_content` and user messages are missing → 422.

**Response:** `{ resume_json, response?, generatedName? }` — `resume_json` is the full `ResumeData` shape (`firstName`, `email`, `phone`, `github`, `website`, `linkedin`, `experience[]`, `skills{category: []}`, `education[]`, `summary`, …); partial AI output is accepted with defaults applied.

**Errors:** 500 if `ANTHROPIC_API_KEY` unset; 503 if the Anthropic call fails.

## TTS / STT (`/api/tts`, `/api/stt`, `/api/voices`)

Provider-based speech endpoints. TTS providers: `edge` (free), `openai`, `elevenlabs`, `google`. STT providers: `openai` (Whisper), `wispr`, `elevenlabs`. Provider API keys come from env (`OPENAI_API_KEY`, `ELEVENLABS_API_KEY`, etc.).

| Method | Endpoint                | Description                                                                 |
| ------ | ----------------------- | ----------------------------------------------------------------------------- |
| `POST` | `/api/stt/{provider}`   | Transcribe audio (`multipart/form-data`, field `audio`) → `{ text }`           |
| `POST` | `/api/tts/{provider}`   | Synthesize speech (`?text=<1-5000 chars>&voice=<id>`) → `audio/mpeg` stream    |
| `GET`  | `/api/voices/{provider}`| List available voices → `{ voices }`                                           |

```bash
curl -X POST "http://$BACKEND_HOST:$BACKEND_PORT/api/tts/edge?text=Hello%20world" -o speech.mp3
```

## Database (PostgreSQL `seekr_db`, SQLAlchemy; tables auto-created on startup)

| Table           | Columns                                                                                              |
| --------------- | ----------------------------------------------------------------------------------------------------- |
| `users`         | `id` PK, `google_id` (unique, nullable), `email` (unique, NN), `name`, `password_hash` (nullable), `profile_picture`, `created_at`, `updated_at` |
| `resumes`       | `id` PK, `name` NN, `user_id` FK→users (CASCADE), `resume_json` JSON NN, `ttl` NN (auto-calculated), `created_at`, `updated_at` — unique (user, name) |
| `user_settings` | `id` PK, `user_id` FK→users (CASCADE), `name` NN, `value` TEXT NN, `ttl` (always null), `created_at`, `updated_at` — unique (user, name) |
