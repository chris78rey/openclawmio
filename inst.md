# VPS Ubuntu 24 (base minima en Coolify)

Objetivo:
- mantener el servidor solo con base Ubuntu 24
- no desplegar OpenClaw ni servicios de aplicacion
- usar maximo 5GB RAM y 50GB de disco en el VPS

Archivos usados:
- `docker-compose.coolify.yml`
- `.env.example`

## Uso en Coolify

1. Crea una app tipo Docker Compose.
2. Usa `docker-compose.coolify.yml`.
3. Carga variables desde `.env.example`.
4. Despliega.

Resultado esperado:
- contenedor base `ubuntu:24.04` en ejecucion
- sin dominio, sin Traefik, sin puertos publicados
- limite de memoria del contenedor en `5g`

## Limites de capacidad

- RAM: definida en compose con `mem_limit: 5g` y `memswap_limit: 5g`.
- Disco: el limite de `50GB` se define en el volumen/disco del VPS (Coolify/Proveedor), no en este compose base.

Comandos de verificacion sugeridos en el VPS:

```bash
docker stats --no-stream
df -h
docker system df
```

## Nota operativa

Esta base sirve para validar servidor, red y runtime Docker.
Cuando quieras desplegar el bot, se reemplaza este compose por uno de aplicacion.

## Automatizacion OpenClaw Oficial (1 comando)

Si quieres que el VPS haga todo automaticamente (Docker + repo oficial + permisos + arranque):

```bash
curl -fsSL https://raw.githubusercontent.com/chris78rey/openclawmio/solo-linux/scripts/bootstrap-openclaw-official.sh | sudo bash
```

Que hace este script:
- instala Docker si no existe,
- clona/actualiza `https://github.com/openclaw/openclaw`,
- prepara volumenes con permisos `uid:gid 1000:1000`,
- genera/reutiliza `OPENCLAW_GATEWAY_TOKEN`,
- arranca `openclaw-gateway` con `--allow-unconfigured`.
