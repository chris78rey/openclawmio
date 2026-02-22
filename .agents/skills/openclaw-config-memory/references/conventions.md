# Convenciones Operativas del Repo

## Seguridad
- Guardar `OPENCLAW_GATEWAY_TOKEN` y cookies/sesiones solo como secretos en Coolify.
- No escribir valores reales en `.env.example` ni en commits.

## Red y Exposicion
- Mantener acceso via Traefik (`coolify` network).
- Usar `expose` en el servicio y evitar `ports` publicos directos.

## Capacidad
- Objetivo de VPS: maximo 4GB RAM y 50GB disco.
- Mantener limites de memoria en compose.
- Mantener rotacion de logs para evitar crecimiento no controlado.

## Configuracion Base
- `TZ=America/Guayaquil`.
- Volumenes persistentes para configuracion y workspace.
- Revisar coherencia entre `inst.md`, compose y variables.
