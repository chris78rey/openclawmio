# OpenClaw en Coolify (automatico)

Objetivo:
- desplegar OpenClaw en `bot.da-tica.com` con HTTPS
- mantener maximo `5GB` RAM y politica de `50GB` disco del VPS

Archivos:
- `docker-compose.coolify.yml`
- `.env.example`
- `scripts/bootstrap-openclaw-official.sh` (opcional, fuera de Coolify)

## Despliegue en Coolify

1. App tipo Docker Compose.
2. Repo: `chris78rey/openclawmio`.
3. Branch: `solo-linux`.
4. Compose file: `docker-compose.coolify.yml`.
5. Cargar variables desde `.env.example`.
6. En Secrets, reemplazar `OPENCLAW_GATEWAY_TOKEN` por valor real.
7. Deploy / Redeploy.

## Requisitos para que funcione el dominio

- DNS `A` de `bot.da-tica.com` al IP publico del VPS.
- Traefik de Coolify activo.
- Abrir puertos 80 y 443 en firewall.
- Acceder por `https://bot.da-tica.com/` (sin puerto `:18789`).

## Capacidad

- RAM contenedor: `mem_limit: 5g` y `memswap_limit: 5g`.
- Disco 50GB: se controla en el disco/volumen del VPS, no en compose.

## Validacion local de compose

```bash
docker compose -f docker-compose.coolify.yml --env-file .env.example config
```

## Opcion alternativa (host, fuera de Coolify)

Instalacion oficial OpenClaw en 1 comando:

```bash
curl -fsSL https://raw.githubusercontent.com/chris78rey/openclawmio/solo-linux/scripts/bootstrap-openclaw-official.sh | sudo bash
```
