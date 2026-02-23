---
name: ejecuta-md-log
description: Registrar comandos operativos en `ejecuta.md` con formato consistente. Usar cuando se necesite ejecutar comandos y dejar solo el ultimo bloque listo para copiar/pegar.
---

# Ejecuta MD Log

## Cuando usar
- Cuando el usuario pida ejecutar o preparar comandos de consola.
- Cuando se necesite dejar un historial operativo simple en `ejecuta.md`.
- Cuando se quiera evitar errores por comandos partidos en chat.

## Regla principal
Antes de ejecutar comandos (o al entregarlos al usuario), escribir una seccion en `ejecuta.md` con:
1. Titulo corto del objetivo.
2. Explicacion de que hace.
3. Bloque `bash` con comandos completos en una sola linea por comando.

Por defecto este skill debe mantener **solo el ultimo bloque** (sin historial).

## Formato obligatorio en `ejecuta.md`

Usar esta plantilla:

```markdown
## YYYY-MM-DD HH:MM - <objetivo>

Que hace:
- <explicacion breve 1>
- <explicacion breve 2>

```bash
<comando 1>
<comando 2>
```
```

## Flujo de trabajo
1. Confirmar objetivo del comando.
2. Escribir entrada en `ejecuta.md` usando `scripts/append_ejecuta.py --mode replace`.
3. Ejecutar comandos en terminal si aplica.
4. Reportar resultado y dejar referencia al bloque agregado.

## Comando recomendado

```bash
python .agents/skills/ejecuta-md-log/scripts/append_ejecuta.py --mode replace --title "<objetivo>" --notes "<nota1>" "<nota2>" --cmd "<comando 1>" --cmd "<comando 2>"
```

## Referencias
- `.agents/skills/ejecuta-md-log/references/format.md`
- `ejecuta.md`
