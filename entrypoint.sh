#!/bin/sh
# Entrypoint script to configure FluffyChat web client based on the selected framework mode

CONFIG_FILE="/usr/share/nginx/html/web/config.json"
JS_FILE="/usr/share/nginx/html/web/main.dart.js"

if [ "$CHAT_MODE" = "your-own-domain" ]; then
    echo "Configuring FluffyChat for Dedicated Domain Mode..."
    
    # Ensure the target directory exists
    mkdir -p /usr/share/nginx/html/web
    
    # Generate the local JSON configuration
    echo "{\"default_homeserver_url\": \"https://${HOMESERVER_DOMAIN}\"}" > $CONFIG_FILE
    
    # Force the compiled JavaScript to look at our domain instead of the public GitHub repo list
    if [ -f "$JS_FILE" ]; then
        echo "Patching FluffyChat source code to lock homeserver routing..."
        sed -i 's|https://raw.githubusercontent.com/krille-chan/fluffychat/refs/heads/main/recommended_homeservers.json|/web/config.json|g' $JS_FILE
    fi
    
    echo "Target homeserver locked to: https://${HOMESERVER_DOMAIN}"
else
    echo "Configuring FluffyChat for Standard Open Mode..."
    rm -f $CONFIG_FILE
fi

# Handover control to the primary Nginx process container command
exec "$@"
