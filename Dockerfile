# Custom lightweight web server configuration for FluffyChat PWA
FROM nginx:alpine

# Install tools to pull the community web release assets
RUN apk add --no-cache wget tar

# Download production-ready FluffyChat web client directly from the correct upstream release
WORKDIR /tmp
RUN wget https://github.com/krille-chan/fluffychat/releases/latest/download/fluffychat-web.tar.gz && \
    mkdir -p /usr/share/nginx/html && \
    tar -xzf fluffychat-web.tar.gz -C /usr/share/nginx/html --strip-components=2 && \
    rm fluffychat-web.tar.gz

# Copy local entrypoint script to handle runtime domain injection
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
