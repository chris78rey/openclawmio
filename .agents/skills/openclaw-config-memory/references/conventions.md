# Convenciones Operativas del Repo

## Seguridad
- Guardar `OPENCLAW_GATEWAY_TOKEN` y cookies/sesiones solo como secretos en Coolify.
- No escribir valores reales en `.env.example` ni en commits.
- Tratar URLs con `#token=...` como secreto.

## Red y Exposicion
- Mantener acceso via Traefik (`coolify` network).
- Usar `expose` en el servicio y evitar `ports` publicos directos.
- Dominio canonico: `bot.da-tica.com` (sin puerto).
- En este entorno, usar labels Traefik explicitas para mayor estabilidad.
- Evitar variables en `Host(...)` de labels Traefik; usar host literal.
- No mezclar routing autogenerado de Coolify con labels manuales en la misma app.

## Capacidad
- Objetivo de VPS: maximo 5GB RAM y 50GB disco.
- Mantener limites de memoria en compose.
- Mantener rotacion de logs para evitar crecimiento no controlado.

## Configuracion Base
- `TZ=America/Guayaquil`.
- Volumenes persistentes para configuracion y workspace.
- Revisar coherencia entre `inst.md`, compose y variables.

## Troubleshooting conocido
- `no available server`: revisar conflicto de routers en Traefik y dominio repetido.
- `unauthorized: gateway token missing`: entrar con URL `#token=...` del contenedor activo.
- `pairing required`: aprobar `requestId` con `devices approve`.
- `gateway token mismatch`: usar `--token "<OPENCLAW_GATEWAY_TOKEN>"` en comandos CLI.
- `EACCES` en `/home/node/.openclaw`: corregir ownership de volumenes a `1000:1000`.
