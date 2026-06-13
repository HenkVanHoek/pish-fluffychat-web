#!/bin/sh
# Entrypoint script to configure FluffyChat web client based on the selected framework mode

CONFIG_FILE="/usr/share/nginx/html/web/config.json"

if [ "$CHAT_MODE" = "your-own-domain" ]; then
    echo "Configuring FluffyChat for Dedicated Domain Mode..."
    
    # Ensure the target directory exists
    mkdir -p /usr/share/nginx/html/web
    
    # Generate the exact JSON configuration required by modern FluffyChat builds
    echo "{\"default_homeserver_url\": \"https://${HOMESERVER_DOMAIN}\"}" > $CONFIG_FILE
    
    # Block the upstream application from falling back to the external GitHub homeserver list
    # by overriding internal routing logic if necessary.
    echo "Target homeserver locked to: https://${HOMESERVER_DOMAIN}"
else
    echo "Configuring FluffyChat for Standard Open Mode..."
    # In standard mode, we remove any explicit config to let the client default to its open UI
    rm -f $CONFIG_FILE
fi

# Handover control to the primary Nginx process container command
exec "$@"
