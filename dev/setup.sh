#!/bin/bash

set -e

echo "🚀 Setting up development environment..."
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

if ! command -v mkcert &> /dev/null; then
    echo -e "${YELLOW}⚠️  mkcert not found. Please install it first.${NC}"
    echo "Visit: https://github.com/FiloSottile/mkcert#installation"
    exit 1
fi

echo "📜 Installing mkcert CA..."
mkcert -install

echo "📁 Creating certificates directory..."
mkdir -p dev/docker/certs
echo ""

echo "🔐 Generating SSL certificates..."
mkcert -cert-file dev/docker/certs/traefik.localhost.crt \
       -key-file dev/docker/certs/traefik.localhost.key \
       traefik.localhost
echo ""
mkcert -cert-file dev/docker/certs/local.crt \
       -key-file dev/docker/certs/local.key \
       fastapi.localhost
echo ""

echo "🐳 01. Building docker image..."
docker build -f dev/docker/Dockerfile -t fastapi:0.0.1 .
echo ""

echo "🐳 02. Starting Docker containers..."
docker-compose -p fastapi -f dev/docker/docker-compose.yml up --build -d
echo ""

echo -e "${GREEN}✅ Development environment is ready!${NC}"
echo ""
echo "Access your application at:"
echo "  - FastAPI: https://fastapi.localhost"
echo "  - FastAPI Docs: https://fastapi.localhost/docs"
echo "  - Traefik Dashboard: https://traefik.localhost"
echo ""
echo "To view logs: docker-compose -p fastapi -f dev/docker/docker-compose.yml logs -f"
echo "To stop: docker-compose -p fastapi -f dev/docker/docker-compose.yml down"