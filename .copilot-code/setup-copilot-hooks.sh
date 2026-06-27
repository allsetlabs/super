#!/usr/bin/env bash
# Idempotently install/update Copilot hooks from .copilot-code/config/hooks.toml
# into ~/.copilot-code/config.toml without duplicating existing hooks.

set -e

config_file="$HOME/.copilot-code/config.toml"
hooks_file=".copilot-code/config/hooks.toml"

mkdir -p "$(dirname "$config_file")"
touch "$config_file"

/usr/bin/python3 <<PY
import re

with open("$hooks_file", "r") as f:
    hooks_text = f.read()

with open("$config_file", "r") as f:
    config_text = f.read()

# Split hooks.toml into individual [[hooks]] blocks.
blocks = re.split(r'\n(?=\[\[hooks\]\]\n)', hooks_text.strip())
blocks = [b for b in blocks if b.strip()]

installed = []
for block in blocks:
    cmd_match = re.search(r'command\s*=\s*"([^"]+)"', block)
    if not cmd_match:
        continue
    cmd = cmd_match.group(1)
    if cmd not in config_text:
        with open("$config_file", "a") as f:
            f.write("\n" + block + "\n")
        installed.append(cmd)

if installed:
    print(f"Installed Copilot hooks: {', '.join(installed)}")
else:
    print("Copilot hooks already up to date")
PY
