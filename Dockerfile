# Custom lightweight web server configuration for FluffyChat PWA
FROM nginx:alpine

# Install tools to pull the community web release assets
RUN apk add --no-cache wget unzip

# Download production-ready FluffyChat web client directly from the correct upstream release
WORKDIR /tmp
RUN wget https://github.com/krille-official/fluffychat/releases/latest/download/web.zip && \
    unzip web.zip -d /usr/share/nginx/html && \
    rm web.zip

# Copy local entrypoint script to handle runtime domain injection
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
