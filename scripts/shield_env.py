#!/usr/bin/env python3
import os
from cryptography.fernet import Fernet

ENV_FILE = ".env"
OUTPUT_FILE = "docker-compose-encrypted.txt"
MASTER_KEY = None


def shield() -> None:
    global MASTER_KEY
    if not MASTER_KEY:
        MASTER_KEY = Fernet.generate_key()

    f = Fernet(MASTER_KEY)

    if not os.path.exists(ENV_FILE):
        print(f"Error: no se encuentra {ENV_FILE}")
        return

    with open(OUTPUT_FILE, "w", encoding="utf-8") as out:
        out.write("# Guarda esta llave en un secret manager\n")
        out.write(f"# MASTER_KEY={MASTER_KEY.decode()}\n\n")
        out.write("environment:\n")

        with open(ENV_FILE, "r", encoding="utf-8") as source:
            for raw in source:
                line = raw.strip()
                if not line or line.startswith("#"):
                    continue
                if "=" not in line:
                    continue

                key, value = line.split("=", 1)
                encrypted_value = f.encrypt(value.encode()).decode()
                out.write(f"  - {key}_ENC={encrypted_value}\n")

    print(f"Listo. Archivo generado: {OUTPUT_FILE}")
    print(f"MASTER_KEY: {MASTER_KEY.decode()}")


if __name__ == "__main__":
    shield()
