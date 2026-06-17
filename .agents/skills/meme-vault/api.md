# Meme Vault API Reference

Next.js route handlers under `modules/forge-modules/meme-vault/src/app/api/`. Backed by Supabase (`clips`, `jobs`, `users` tables). Mutations are mostly **asynchronous**: they queue a job in the `jobs` table that a local worker processes.

## Connection Details

| Setting      | Value                                                                                                                                                              |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Base URL** | The Next.js app origin (e.g. `http://localhost:3000`)                                                                                                              |
| **Auth**     | None on the routes themselves; Google login issues a Supabase session token for the UI                                                                             |
| **Env**      | `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `GITHUB_TOKEN`, `NEXT_PUBLIC_GITHUB_REPO`, `NEXT_PUBLIC_GITHUB_BRANCH`, `INSTAGRAM_ACCESS_TOKEN` in `.env`/`.env.development` |

## Auth

### POST /api/auth/google-login

Verify a Google ID token via Supabase Auth and upsert the user.

- **Body:** `{ credential }` (Google ID token)
- **Response:** `{ access_token, token_type: "bearer", user: { id, email, name, picture } }`
- **Errors:** 400 missing credential, 401 auth failed

## Clips

### GET /api/clips

List clips with pagination and filtering.

- **Query:** `page` (default 1), `limit` (default 20), `search` (partial match on name/caption), `tags` (comma-separated, must all match)
- **Response:** `{ clips, total, page, limit, totalPages }` — newest first

**Clip shape:** `{ id, name, tags[], source_url, start_seconds, stop_seconds, caption, thumbnail_second, approved, created_at, insta_reel_link, createdBy, updatedBy }`

### POST /api/clips

Queue a **create** job (processed by the local worker: download → caption → GIF → GitHub → Instagram → DB).

- **Body:** `{ source_url, start_seconds, stop_seconds, user }` required; `{ name?, caption?, thumbnail_second?, tags? }` optional
- **Response:** 202 `{ job_id, status, message }`

```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"source_url":"https://youtube.com/watch?v=...","start_seconds":10,"stop_seconds":15,"user":"<user>"}' \
  http://localhost:3000/api/clips
```

### PUT /api/clips

Queue an **update** job. Worker regenerates only what changed (start/stop → full re-download; caption → video/gif/thumbnail; thumbnail_second → thumbnail only).

- **Body:** `{ id, user }` required; `{ start_seconds?, stop_seconds?, caption?, thumbnail_second?, name?, tags? }` optional
- **Response:** 202 `{ job_id, status, message }`; 404 if clip not found

### PATCH /api/clips

Toggle approval (synchronous, no job).

- **Body:** `{ id, approved: boolean }`
- **Response:** `{ clip }`

### DELETE /api/clips?id=<clipId>

Delete a clip everywhere — Supabase row, GitHub assets, Instagram reel (synchronous, uses the `delete-meme` script).

- **Response:** `{ deleted: true, result }`; 207 if some services failed (partial deletion); 400 missing id

## Jobs table (worker contract)

| Field     | Value                                                         |
| --------- | ------------------------------------------------------------- |
| `type`    | `create` \| `update`                                          |
| `status`  | `pending` → `processing` → `completed`/`failed`               |
| `payload` | CreateJobPayload / UpdateJobPayload (see `src/types/clip.ts`) |
| `user`    | Requesting user                                               |

The worker (`worker/`) polls `jobs` for `pending` rows and runs the media pipeline locally.
