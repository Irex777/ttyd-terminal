#!/bin/sh
set -e

SSH_HOST="${SSHHOST:-192.168.64.1}"
SSH_PORT="${SSHPORT:-2222}"
SSH_USER="${SSHUSER:-root}"

# Write private key if provided
if [ -n "$SSH_PRIVATE_KEY" ]; then
    mkdir -p /root/.ssh
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa
    # Trust the relay host
    ssh-keyscan -p "$SSH_PORT" "$SSH_HOST" >> /root/.ssh/known_hosts 2>/dev/null || true
fi

# ttyd options:
# -p port 7681
# -c enable basic auth (user:password) - set via -c flag
# -W allow writeable
# -t locale setting
# Start an SSH session that auto-attaches to tmux (or creates one)
# ttyd runs the command once per connection

AUTH="${BASIC_AUTH:-}"
TTYD_ARGS="-p 7681 -W"

if [ -n "$AUTH" ]; then
    TTYD_ARGS="$TTYD_ARGS -c $AUTH"
fi

echo "[ttyd] Starting ttyd -> ${SSH_USER}@${SSH_HOST}:${SSH_PORT}"

exec ttyd $TTYD_ARGS \
    ssh -t -p "$SSH_PORT" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "${SSH_USER}@${SSH_HOST}" \
    'tmux new-session -A -s main'
