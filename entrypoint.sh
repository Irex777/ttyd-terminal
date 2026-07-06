#!/bin/sh
set -e

SSH_HOST="${SSHHOST:-192.168.64.1}"
SSH_PORT="${SSHPORT:-2222}"
SSH_USER="${SSHUSER:-aboy}"
SSH_PASS="${SSHPASS:-P6atriot66}"
AUTH="${BASIC_AUTH:-anton:P6atriot6}"

# Inline toolbar.js into nginx config (avoids browser blocking external script with credentials in URL)
if [ -f /toolbar.js ]; then
  TOOLBAR_JS=$(cat /toolbar.js | tr '\n' ' ' | sed "s/'/\\\\'/g")
  sed -i "s|__TOOLBAR_JS__|${TOOLBAR_JS}|" /etc/nginx/http.d/default.conf
fi

echo "[ttyd] Starting ttyd -> ${SSH_USER}@${SSH_HOST}:${SSH_PORT}"

ttyd -i 127.0.0.1 -p 7681 -W -c "$AUTH" \
    sshpass -p "$SSH_PASS" ssh -t -p "$SSH_PORT" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o PreferredAuthentications=password \
    -o PubkeyAuthentication=no \
    "${SSH_USER}@${SSH_HOST}" \
    'tmux new-session -A -s main'
