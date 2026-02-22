# Repository Guidelines

## Project Structure & Module Organization
This repository is a deployment configuration repo for OpenClaw on VPS/Coolify.

- `docker-compose.coolify.yml`: production compose definition (Traefik labels, memory limits, volumes, healthcheck).
- `.env.example`: template of required runtime variables.
- `inst.md`: operational deployment notes and VPS runbook.
- `scripts/shield_env.py`: optional helper to encrypt env values into `*_ENC` format.
- `.agents/skills/`: repository-local skills for Codex (source of truth for custom skills in this repo).
- `_tmp_openclaw/`: local upstream reference clone for research only; do not edit or ship from here.

Keep new files focused on operations (`docs/`, `scripts/`, compose/env templates).

## Skills Path (Codex)
- Use `.agents/skills/<skill-name>` for repo-scoped skills.
- Use `~/.agents/skills/<skill-name>` for user-scoped local skills.
- Do not place custom skills under `~/.codex/skills/.system`; that path is for bundled/system skills.

## Build, Test, and Development Commands
No app build happens in this repo; validation is config-focused.

- `git status --short`: quick check before commit.
- `docker compose -f docker-compose.coolify.yml config`: validate compose syntax and env interpolation.
- `python scripts/shield_env.py`: generate encrypted env output (optional workflow).
- `git log --oneline -n 10`: review recent commit style before writing messages.

If testing on VPS:
- `docker compose -f docker-compose.coolify.yml up -d`
- `docker compose -f docker-compose.coolify.yml logs -f openclaw-gateway`

## Coding Style & Naming Conventions
- Use UTF-8 text files, 2-space YAML indentation, and concise Spanish/English operational wording.
- Use lowercase, hyphenated file names for new runbooks (example: `coolify-backup.md`).
- Environment variables must be uppercase with underscores (example: `OPENCLAW_GATEWAY_TOKEN`).
- Never hardcode secrets in tracked files; use variable placeholders only.

## Testing Guidelines
- Minimum check for each change: compose lint via `docker compose ... config`.
- For routing changes, verify Traefik labels and `expose` port consistency (`18789`).
- For secret handling changes, confirm `.env.example` contains keys but no real values.
- There is no formal coverage target yet; prioritize deploy safety and rollback clarity.

## Commit & Pull Request Guidelines
Current history uses short imperative subjects:
- `Deploy OpenClaw VPS setup`
- `Set default timezone to America/Guayaquil`

Follow the same pattern:
- `<Verb> <scope/outcome>` (50-72 chars preferred).

PRs should include:
- purpose and operational impact,
- changed files list,
- manual validation performed,
- rollback note (how to revert safely).

## Security & Configuration Tips
- Store sensitive values only in Coolify Secrets (`OPENCLAW_GATEWAY_TOKEN`, session cookies/keys).
- Keep `ports` closed in compose; prefer `expose` behind Traefik.
- Preserve disk/RAM limits and log rotation unless there is a justified capacity change.
