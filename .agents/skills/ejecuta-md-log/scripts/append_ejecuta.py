#!/usr/bin/env python3
"""
Write a formatted command block to ejecuta.md.

Usage example:
python .agents/skills/ejecuta-md-log/scripts/append_ejecuta.py \
  --mode replace \
  --title "Reiniciar gateway" \
  --notes "Reinicia el contenedor activo" "Valida logs de arranque" \
  --cmd "CID=\"$(docker ps -a --format '{{.Names}}' | grep '^openclaw-gateway-s' | head -n1)\"" \
  --cmd "docker restart \"$CID\"" \
  --cmd "docker logs --tail=80 \"$CID\""
"""

from __future__ import annotations

from argparse import ArgumentParser
from datetime import datetime
from pathlib import Path


def build_entry(title: str, notes: list[str], commands: list[str]) -> str:
    ts = datetime.now().strftime("%Y-%m-%d %H:%M")
    lines: list[str] = [f"## {ts} - {title}", "", "Que hace:"]
    for note in notes:
        lines.append(f"- {note}")
    lines.extend(["", "```bash"])
    lines.extend(commands)
    lines.extend(["```", ""])
    return "\n".join(lines)


def main() -> int:
    parser = ArgumentParser(description="Write command section to ejecuta.md")
    parser.add_argument("--title", required=True, help="Section title")
    parser.add_argument("--notes", nargs="+", required=True, help="1..N note bullets")
    parser.add_argument(
        "--cmd",
        action="append",
        required=True,
        help="Command line to append (repeat --cmd for each command)",
    )
    parser.add_argument(
        "--file",
        default="ejecuta.md",
        help="Target markdown file (default: ejecuta.md)",
    )
    parser.add_argument(
        "--mode",
        choices=["replace", "append"],
        default="replace",
        help="replace keeps only latest block; append keeps history (default: replace)",
    )
    args = parser.parse_args()

    target = Path(args.file)
    entry = build_entry(args.title.strip(), [n.strip() for n in args.notes], [c.rstrip() for c in args.cmd])
    header = "# Comandos Operativos\n\n"
    if args.mode == "replace":
        target.write_text(header + entry, encoding="utf-8")
        print(f"Replaced content in {target}")
        return 0

    if not target.exists():
        target.write_text(header, encoding="utf-8")
    current = target.read_text(encoding="utf-8")
    if not current.endswith("\n"):
        current += "\n"
    target.write_text(current + "\n" + entry, encoding="utf-8")
    print(f"Appended section to {target}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
