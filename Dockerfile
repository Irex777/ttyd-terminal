FROM tsl0922/ttyd:latest

# Install openssh-client for SSH to the relay
RUN apk add --no-cache openssh-client tmux

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7681

ENTRYPOINT ["/entrypoint.sh"]
