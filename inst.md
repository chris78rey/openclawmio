# VPS Ubuntu 24 (base minima en Coolify)

Objetivo:
- mantener el servidor solo con base Ubuntu 24
- no desplegar OpenClaw ni servicios de aplicacion

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

## Nota operativa

Esta base sirve para validar servidor, red y runtime Docker.
Cuando quieras desplegar el bot, se reemplaza este compose por uno de aplicacion.
