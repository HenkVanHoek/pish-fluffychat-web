#!/bin/sh
# Entrypoint script to configure FluffyChat routing and behavior

CONFIG_FILE="/usr/share/nginx/html/web/config.json"
NGINX_CONF="/etc/nginx/conf.d/default.conf"

if [ "$CHAT_MODE" = "your-own-domain" ]; then
    echo "Configuring FluffyChat for Dedicated Domain Mode..."
    
    # Ensure directories exist
    mkdir -p /usr/share/nginx/html/web
    mkdir -p /etc/nginx/conf.d
    
    # 1. Generate the local JSON configuration
    echo "{\"default_homeserver_url\": \"https://${HOMESERVER_DOMAIN}\"}" > $CONFIG_FILE
    
    # 2. Inject custom Nginx location block to intercept and redirect recommended server requests
    cat << 'EOF' > $NGINX_CONF
server {
    listen 80;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        try_files $uri $uri/ /index.html;
    }

    # Intercept any attempt to fetch upstream server lists and serve our local configuration instead
    location ~* (recommended_homeservers\.json) {
        root /usr/share/nginx/html/web;
        try_files /config.json =404;
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
    }
}
EOF
    echo "Nginx interceptor configuration applied for: ${HOMESERVER_DOMAIN}"
else
    echo "Configuring FluffyChat for Standard Open Mode..."
    rm -f $CONFIG_FILE
    # Restore default clean Nginx configuration if it was modified
    rm -f $NGINX_CONF
fi

# Handover control to the primary Nginx process container command
exec "$@"
