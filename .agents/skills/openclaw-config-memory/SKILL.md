---
name: openclaw-config-memory
description: Conservar y aplicar conocimiento estable de configuracion del repositorio. Usar al editar compose, variables de entorno, seguridad de secretos, red y limites operativos de OpenClaw en VPS/Coolify.
---

# OpenClaw Config Memory

## Cuando usar
- Cambiar `docker-compose.coolify.yml` o `.env.example`.
- Revisar PRs de configuracion operativa.
- Verificar cumplimiento de politicas de seguridad y capacidad.

## Flujo de Trabajo
1. Comparar cambios propuestos contra las convenciones del repo.
2. Validar secretos, red, limites de recursos y zona horaria.
3. Confirmar consistencia entre `inst.md`, compose y env.
4. Reportar desviaciones y proponer correcciones puntuales.

## Reglas y Convenciones
- Secrets solo en Coolify Secrets.
- No publicar credenciales en archivos versionados.
- Mantener `mem_limit: 4g` y `memswap_limit: 4g` salvo cambio aprobado.
- Mantener log rotation (`max-size`, `max-file`).
- Usar `.agents/skills` para skills del repo.

## Referencias
- `.agents/skills/openclaw-config-memory/references/conventions.md`
- `inst.md`
- `docker-compose.coolify.yml`
- `.env.example`
