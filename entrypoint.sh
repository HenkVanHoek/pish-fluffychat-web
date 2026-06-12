#!/bin/sh
# Entrypoint script to inject the local sovereign domain into the FluffyChat config on spin-up

CONFIG_FILE="/usr/share/nginx/html/web/assets/config.json"

# Verify if configuration path exists before executing mutation
if [ -f "$CONFIG_FILE" ]; then
    # Replace the default upstream homeserver with our explicit local domain variables
    sed -i "s|\"default_homeserver\": \".*\"|\"default_homeserver\": \"https://${HOMESERVER_DOMAIN}\"|g" $CONFIG_FILE
else
    # Fallback initializer if upstream release structure alters config placement
    mkdir -p /usr/share/nginx/html/web/assets
    echo "{\"default_homeserver\": \"https://${HOMESERVER_DOMAIN}\", \"branding\": {\"application_name\": \"PiSelfhosting Chat\"}}" > $CONFIG_FILE
fi

# Handover control to the primary Nginx process container command
exec "$@"
