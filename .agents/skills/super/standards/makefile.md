# makefile — Makefile Standard

Apply this when onboarding a new module and when auditing existing ones.

Every module must have a `Makefile` with these targets:

1. **`make setup`** — system-level deps (Node, Python, tmux). Idempotent — check before installing.
2. **`make install`** — project-level deps (`npm install`, `pip install`, etc.).
3. **`make start`** — start all services in a tmux session. Single entry point.

Hardcode ports as Makefile variables at the top. Never in `.env` files.
