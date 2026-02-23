---
name: openclaw-config-memory
description: Conservar y aplicar conocimiento estable de configuracion del repositorio. Usar al editar compose, variables de entorno, seguridad de secretos, red y limites operativos de OpenClaw en VPS/Coolify.
---

# OpenClaw Config Memory

## Cuando usar
- Cambiar `docker-compose.coolify.yml` o `.env.example`.
- Revisar PRs de configuracion operativa.
- Verificar cumplimiento de politicas de seguridad y capacidad.
- Recuperar despliegue en Coolify cuando aparezca `no available server`.
- Resolver autenticacion de dashboard (`token missing`, `pairing required`).

## Flujo de Trabajo
1. Comparar cambios propuestos contra las convenciones del repo.
2. Validar secretos, red, limites de recursos y zona horaria.
3. Confirmar consistencia entre `inst.md`, compose y env.
4. Si falla el dominio, validar Traefik/Coolify con logs de `coolify-proxy`.
5. Reportar desviaciones y proponer correcciones puntuales.

## Reglas y Convenciones
- Secrets solo en Coolify Secrets.
- No publicar credenciales en archivos versionados.
- Mantener `mem_limit: 5g` y `memswap_limit: 5g` para este entorno.
- Mantener log rotation (`max-size`, `max-file`).
- Usar `.agents/skills` para skills del repo.
- En este VPS/Coolify (v4 beta), preferir labels Traefik explicitas para `bot.da-tica.com`.
- No usar variables en labels Traefik `Host(...)` (ejemplo `${OPENCLAW_DOMAIN...}`), usar dominio literal.
- Usar un solo metodo de routing por app: labels manuales o domain autogenerado, no ambos.

## Recuperacion Rapida (operativa)
- Ver contenedor activo:
  - `docker ps --format "{{.Names}}" | grep '^openclaw-gateway-s'`
- Generar dashboard URL con token:
  - `docker exec <cid> node dist/index.js dashboard --no-open`
- Aprobar pairing:
  - `docker exec <cid> node dist/index.js devices list --token "<TOKEN>"`
  - `docker exec <cid> node dist/index.js devices approve "<REQUEST_ID>" --token "<TOKEN>"`
- Verificar backend local:
  - `curl -I http://127.0.0.1:18789/`
  - `curl -kI https://127.0.0.1 -H "Host: bot.da-tica.com"`
- Revisar enrutamiento:
  - `docker logs --since 5m coolify-proxy | grep -i "bot.da-tica.com"`
- OpenRouter + MiniMax:
  - `docker exec <cid> node dist/index.js models list --all --provider openrouter --plain | grep -i minimax`
  - `docker exec <cid> node dist/index.js models set openrouter/<provider>/<model>`

## Referencias
- `.agents/skills/openclaw-config-memory/references/conventions.md`
- `inst.md`
- `docker-compose.coolify.yml`
- `.env.example`
