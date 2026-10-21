#!/bin/bash
set -euo pipefail

# simple wrapper for ssh-keygen
# Creates a key pair with suffix _SERVER_NAME and copies it to the server.

# ssh-keygen -t ed25519 -C "${USER}@$(hostname)" -f "${HOME}/.ssh/id_ed25519_${1}"

SERVER_NAME="${1:-}"

[[ -n "${SERVER_NAME}" ]] || { echo "Usage: $0 <SERVER_NAME>"; exit 1; }

KEY_PRIVATE="${HOME}/.ssh/id_ed25519_${SERVER_NAME}"
KEY_PUBLIC="${HOME}/.ssh/id_ed25519_${SERVER_NAME}.pub"

ssh-keygen -t ed25519 -f "${KEY_PRIVATE}"

ssh-copy-id -i "${KEY_PUBLIC}" -o PubkeyAuthentication=no -o StrictHostKeyChecking=ask "${1}"
