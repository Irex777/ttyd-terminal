FROM alpine:latest

RUN apk add --no-cache \
    ttyd \
    openssh-client \
    tmux \
    shadow

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7681

ENTRYPOINT ["/entrypoint.sh"]
