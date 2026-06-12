# PiSelfhosting FluffyChat Web Component

This sovereign component packages the official FluffyChat web client (PWA) into a self-hosted Nginx container tailored for the PiSelfhosting ecosystem.

## Architecture
The container pulls the latest compiled distribution package directly from the upstream repository (krille-official/fluffychat) during the local docker build phase. On container deployment, the entrypoint script dynamically updates the application configuration to seamlessly bind to your local matrix environment domain.

## Deployment Modes

### Nginx Proxy Manager (NPM)
The service exposes an external port (default: 8080) mapped to internal container port 80. Ensure the container shares a network with your NPM instance (`proxy-network`) and map your custom domain (e.g., `chat.yourdomain.com`) directly to this container context.

### Traefik
Standard service labels are pre-configured for automated Traefik ingress discovery routing.

## Environment Variables
* `HOMESERVER_DOMAIN`: Specifies the primary domain architecture context (e.g., `piselfhosting.com`). Driven by `${PISH_DOMAIN}` variable state.
* `FLUFFYCHAT_WEB_PORT`: Public host execution port (default: 8080).
