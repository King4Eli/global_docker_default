#!/bin/bash

set -e

BASE_DIR="/opt/portainer"

sudo mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

cat > compose.yml <<'EOF'
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped

    ports:
      - "8000:8000"
      - "9000:9000"
      - "9443:9443"

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

volumes:
  portainer_data:
EOF

docker compose up -d

echo
echo "======================================"
echo "Portainer is running."
echo "HTTPS: https://localhost:9443"
echo "HTTP : http://localhost:9000"
echo "======================================"