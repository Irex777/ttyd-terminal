# ttyd web terminal
FROM alpine:3.17

RUN apk add --no-cache \
    ttyd sshpass tmux bash

# Copy scripts
COPY init.sh /init.sh
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY toolbar.js /usr/share/nginx/html/toolbar.js

# Copy entrypoint script for SSH connection
COPY entrypoint.sh /entrypoint.sh

# Make scripts executable
RUN chmod +x /init.sh /entrypoint.sh

EXPOSE 80
CMD ["/init.sh"]
