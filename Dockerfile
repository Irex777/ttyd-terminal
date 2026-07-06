FROM alpine:latest

RUN apk add --no-cache \
    ttyd \
    openssh-client \
    sshpass \
    tmux \
    nginx \
    supervisor

COPY entrypoint.sh /entrypoint.sh
COPY toolbar.js /toolbar.js
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY supervisord.conf /etc/supervisord.conf
COPY init.sh /init.sh
RUN chmod +x /entrypoint.sh /init.sh

ENTRYPOINT ["/init.sh"]
