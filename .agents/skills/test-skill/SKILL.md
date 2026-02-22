---
name: test-skill
description: Crear y validar un skill minimo de prueba. Usar cuando se necesite confirmar que la estructura de skills funciona (SKILL.md, agents/openai.yaml, scripts, references), ejecutar una validacion rapida y dejar un ejemplo simple reutilizable.
---

# Test Skill

## Overview

Usar este skill para pruebas tecnicas rapidas de skills. Aplicar cuando el objetivo sea verificar estructura, validacion y ejecucion de recursos sin introducir complejidad de dominio.

## Workflow

1. Confirmar que existan `SKILL.md` y `agents/openai.yaml`.
2. Ejecutar el validador del creador de skills sobre esta carpeta.
3. Ejecutar el script de ejemplo para confirmar que `scripts/` es funcional.
4. Reportar resultado corto: archivos detectados, validacion, y salida del script.

## Commands

Ejecutar estos comandos desde la raiz del repositorio:

```bash
python C:/Users/crrb/.codex/skills/.system/skill-creator/scripts/quick_validate.py .agents/skills/test-skill
python .agents/skills/test-skill/scripts/hello_skill.py
```

## Resources

- `scripts/hello_skill.py`: script minimo para probar ejecucion local.
- `references/checklist.md`: checklist breve para validar un skill nuevo.

## Output esperado

Entregar:
- estado de validacion (`OK` o errores concretos),
- salida del script de prueba,
- cambios recomendados si falla alguna verificacion.
