FROM alpine:latest

RUN apk add --no-cache \
    ttyd \
    openssh-client \
    sshpass \
    tmux \
    nginx \
    supervisor \
    python3

COPY entrypoint.sh /entrypoint.sh
COPY toolbar.js /toolbar.js
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY supervisord.conf /etc/supervisord.conf
COPY init.sh /init.sh
RUN chmod +x /entrypoint.sh /init.sh

# Do the toolbar JS inlining BEFORE starting supervisor
# This ensures nginx sees the correct config from the start
ENTRYPOINT ["/init.sh"]
