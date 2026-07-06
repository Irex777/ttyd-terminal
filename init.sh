#!/bin/sh
set -e

# Inline toolbar.js into nginx config FIRST, before anything starts
if [ -f /toolbar.js ] && [ -f /etc/nginx/http.d/default.conf ]; then
  python3 -c "
with open('/toolbar.js') as f:
    js = f.read().replace(chr(10), ' ')
with open('/etc/nginx/http.d/default.conf') as f:
    conf = f.read()
conf = conf.replace('__TOOLBAR_JS__', js)
with open('/etc/nginx/http.d/default.conf', 'w') as f:
    f.write(conf)
print('[init] Toolbar JS inlined into nginx config')
" || echo "[init] WARNING: Failed to inline toolbar JS"
fi

# Now start supervisor (which starts nginx + ttyd)
exec /usr/bin/supervisord -c /etc/supervisord.conf
