#!/bin/sh
set -e

# Configure nginx with toolbar injection
cat > /etc/nginx/conf.d/default.conf <<'NGINX'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;

    sub_filter '</body>' '<script src="/toolbar.js"></script></body>';
    sub_filter_once on;

    location / {
        proxy_pass http://127.0.0.1:7681;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
}
NGINX

# Start nginx in background
nginx

# Start ttyd in background (SSH connection)
ttyd -W --no-auth -c sshpass ssh -o StrictHostKeyChecking=no aboy@192.168.64.1 -p 2222 &

# Keep container running
wait
