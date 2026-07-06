#!/bin/sh
set -e

SSH_HOST="${SSHHOST:-192.168.64.1}"
SSH_PORT="${SSHPORT:-2222}"
SSH_USER="${SSHUSER:-aboy}"
SSH_PASS="${SSHPASS:-P6atriot66}"
AUTH="${BASIC_AUTH:-anton:P6atriot6}"

echo "[ttyd] Starting ttyd -> ${SSH_USER}@${SSH_HOST}:${SSH_PORT}"

exec ttyd -p 7681 -W -c "$AUTH" \
    sshpass -p "$SSH_PASS" ssh -t -p "$SSH_PORT" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o PreferredAuthentications=password \
    -o PubkeyAuthentication=no \
    "${SSH_USER}@${SSH_HOST}" \
    'tmux new-session -A -s main'
