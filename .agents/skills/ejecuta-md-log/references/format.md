# Formato estandar para `ejecuta.md`

Cada entrada debe tener:
- timestamp,
- titulo corto,
- 1-3 notas de contexto,
- bloque bash copiable.

Modo recomendado:
- `replace` para mantener solo el ultimo bloque (sin historial).
- `append` solo si el usuario pide historial.

Ejemplo:

```markdown
## 2026-02-23 22:10 - Reiniciar gateway y validar logs

Que hace:
- Reinicia el contenedor activo del gateway.
- Muestra ultimas 80 lineas de logs para validar arranque.

```bash
CID="$(docker ps -a --format '{{.Names}}' | grep '^openclaw-gateway-s' | head -n1)"
docker restart "$CID"
docker logs --tail=80 "$CID"
```
```
