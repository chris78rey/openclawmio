# OpenClaw en VPS (Ubuntu + Coolify/Traefik)

Objetivo:
- desplegar OpenClaw en `bot.da-tica.com`
- usar maximo `4GB` RAM y `50GB` disco
- mantener host limpio (solo Docker + utilidades base)

Repositorio de despliegue:
- `https://github.com/chris78rey/openclawmio.git`

Upstream oficial usado como base:
- `https://github.com/openclaw/openclaw`
- imagen Docker oficial en GHCR: `ghcr.io/openclaw/openclaw`

## Archivos de este repo

- `docker-compose.coolify.yml`
- `.env.example`
- `scripts/shield_env.py` (opcional para cifrar valores antes de importarlos como env vars)

## Politica recomendada (aplicada)

1. Limites explicitos: `mem_limit: 4g` y `memswap_limit: 4g`
2. Logs con rotacion: `max-size=10m`, `max-file=5`
3. Sin `ports`, solo `expose` para Traefik en red `coolify`
4. Un solo servicio principal (`openclaw-gateway`)

## Paso a paso en VPS/Coolify

1. Crea una app en Coolify apuntando a este repo.
2. Usa como compose file: `docker-compose.coolify.yml`.
3. Carga variables desde `.env.example` (copiando y completando valores reales).
4. Define secret fuerte para `OPENCLAW_GATEWAY_TOKEN` (32+ bytes aleatorios).
5. Despliega.
6. Verifica:
   - URL: `https://bot.da-tica.com`
   - health interno: `http://127.0.0.1:18789/` dentro del contenedor
7. Completa onboarding/configuracion desde Control UI.

## DNS

- `bot.da-tica.com` -> A record al IP publico del VPS.
- Espera propagacion antes de pedir certificado.

## Mantenimiento para 50GB disco

Programar limpieza periodica (semanal):

```bash
docker image prune -af
docker builder prune -af
docker system df
```

## Seguridad minima

- no exponer puertos directos del contenedor
- usar solo Traefik + TLS
- rotar token de gateway si se filtra
- respaldar volumenes `openclaw_config` y `openclaw_workspace`

## Nota sobre cifrado de variables

El script `scripts/shield_env.py` cifra valores `KEY=VALUE` a formato `KEY_ENC=...`.
Solo sirve si tu aplicacion consume y descifra `*_ENC`. Si OpenClaw no usa esos campos,
guarda secretos normales en Coolify Secrets.
