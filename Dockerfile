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
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
