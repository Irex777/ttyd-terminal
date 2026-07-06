#!/bin/sh
set -e

# Base64-encode toolbar.js and inject into nginx config as an inline decoder.
# This avoids ALL external script loading issues (CORS, mixed content, credentials).
B64=$(base64 -w0 /toolbar.js 2>/dev/null || base64 /toolbar.js | tr -d '\n')

# Generate nginx config with inline base64-decoded toolbar JS
cat > /etc/nginx/http.d/default.conf <<NGINX_EOF
server {
    listen 80 default_server;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:7681;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_read_timeout 86400;
        proxy_buffering on;
        proxy_set_header Accept-Encoding "";

        sub_filter '</body>' '<script>try{eval(atob("${B64}"))}catch(e){console.error("toolbar error:",e)}</script></body>';
        sub_filter_once on;
    }
}
NGINX_EOF

exec /usr/bin/supervisord -c /etc/supervisord.conf
