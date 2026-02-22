---
name: coolify-openclaw-deploy
description: Guiar despliegues de OpenClaw en Coolify con Traefik. Usar cuando se necesite configurar dominio, secretos, limites de recursos, despliegue y verificacion post-deploy en VPS.
---

# Coolify OpenClaw Deploy

## Cuando usar
- Desplegar o actualizar OpenClaw en Coolify.
- Validar configuracion de Traefik y dominio.
- Ejecutar checklist operativo antes y despues del deploy.

## Flujo de Trabajo
1. Revisar `docker-compose.coolify.yml` y `.env.example`.
2. Confirmar secretos en Coolify (`OPENCLAW_GATEWAY_TOKEN` y otros sensibles).
3. Verificar dominio y labels Traefik para `bot.da-tica.com`.
4. Validar limites operativos (RAM, logs, no exponer puertos directos).
5. Ejecutar despliegue y checks post-deploy.

## Reglas y Convenciones
- Mantener `expose` y evitar `ports` en este stack.
- Mantener rotacion de logs activa.
- Mantener `OPENCLAW_GATEWAY_TOKEN` solo como secret.
- Mantener `TZ` en `America/Guayaquil` salvo solicitud explicita.

## Comandos
```bash
docker compose -f docker-compose.coolify.yml config
docker compose -f docker-compose.coolify.yml logs -f openclaw-gateway
```

## Referencias
- `inst.md`
- `docker-compose.coolify.yml`
- `.env.example`
- `AGENTS.md`
