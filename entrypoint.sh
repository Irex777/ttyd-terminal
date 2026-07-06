#!/bin/sh
set -e

SSH_HOST="${SSHHOST:-192.168.64.1}"
SSH_PORT="${SSHPORT:-2222}"
SSH_USER="${SSHUSER:-aboy}"
SSH_PASS="${SSHPASS:-P6atriot66}"
AUTH="${BASIC_AUTH:-anton:P6atriot6}"

# Inline toolbar.js into nginx config (avoids browser blocking external script with credentials in URL)
if [ -f /toolbar.js ] && [ -f /etc/nginx/http.d/default.conf ]; then
  # Use python to do the replacement (more reliable than sed for large JS with special chars)
  python3 -c "
import sys
with open('/toolbar.js') as f:
    js = f.read().replace(chr(10), ' ')
with open('/etc/nginx/http.d/default.conf') as f:
    conf = f.read()
conf = conf.replace('__TOOLBAR_JS__', js)
with open('/etc/nginx/http.d/default.conf', 'w') as f:
    f.write(conf)
" 2>/dev/null || {
    # Fallback: use awk
    TOOLBAR_JS=$(cat /toolbar.js | tr '\n' ' ')
    awk -v js="$TOOLBAR_JS" '{gsub(/__TOOLBAR_JS__/, js); print}' /etc/nginx/http.d/default.conf > /tmp/nginx.conf.tmp
    mv /tmp/nginx.conf.tmp /etc/nginx/http.d/default.conf
  }
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
