#!/bin/sh
set -e

# Write nginx config with toolbar injection
cat > /etc/nginx/conf.d/default.conf <<'EOF'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    sub_filter '</body>' '<script src="/toolbar.js"></script></body>';
    sub_filter_once on;

    location / {
        proxy_pass http://127.0.0.1:7681;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 3600;
        proxy_send_timeout 3600;
    }
}
EOF

# Start nginx in background
nginx

# Keep ttyd running in foreground (this blocks, keeping container alive)
exec ttyd --no-auth --hostname 0.0.0.0 -p 7681 -W -c bash /bin/sh -c 'sshpass -p "P6atriot66" ssh -o StrictHostKeyChecking=no aboy@192.168.64.1 -p 2222'
