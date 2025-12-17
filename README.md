# How the CI/CD Pipeline Works

`Source code` → `GitHub` → `GitHub Actions` → `Build + Push (Docker Hub)` → `Pull + Deploy (Server) via Portainer`

## Source Code

You can use the language of your choice. In this repo I choose Python + FastAPI ⚡️.

## GitHub

The repository is hosted on GitHub and serves as the single source of truth for our application code and configuration.

### Repository Structure
- `Dockerfile` - Defines how to build the application image
- `docker-compose.yml` - Defines the Docker Swarm stack configuration
- `.github/workflows/deploy.yml` - GitHub Actions workflow for CI/CD

## GitHub Actions

Automated workflow that triggers on every push to the `main` branch.

### Workflow Steps:

1. **Checkout code** - Pulls the latest code from the repository
2. **Set up Docker Buildx** - Prepares Docker build environment
3. **Login to Docker Hub** - Authenticates using secrets (`DOCKER_USERNAME`, `DOCKER_TOKEN`)
4. **Build and push image** - Builds the Docker image and pushes to Docker Hub as `sammexkita/fastapi:latest`
5. **Deploy via Portainer API** - Triggers deployment through Portainer's REST API

### Required GitHub Secrets:
- `DOCKER_USERNAME` - Docker Hub username
- `DOCKER_TOKEN` - Docker Hub access token
- `PORTAINER_URL` - Portainer URL
- `PORTAINER_TOKEN` - Portainer API token
- `PORTAINER_CLUSTER_ID` - Docker Swarm cluster ID

## Docker Hub

Acts as our container registry, storing versioned images of our application. This allows:
- Separation of build and deployment environments
- Easy rollback to previous versions
- Multiple servers to pull the same image
- Build process happens on GitHub's infrastructure, not on production server

## Server (Hetzner)

Running Docker Swarm mode with Portainer for container management.

### Infrastructure Components:
- **Docker Swarm** - Container orchestration platform
- **Portainer** - Web UI for Docker management
- **Traefik** - Reverse proxy handling SSL certificates and routing

### Deployment Process:
1. GitHub Actions calls Portainer API with the updated `docker-compose.yml`
2. Portainer creates/updates the stack in Docker Swarm
3. Docker Swarm pulls the new image from Docker Hub
4. Rolling update replaces old containers with new ones (zero downtime)
5. Traefik routes traffic to `fastapi.mydomain`

## Benefits of This Setup

✅ **Automated Deployment** - Push to main = automatic deploy  
✅ **No SSH Required** - Uses Portainer API (more secure with firewall)  
✅ **Zero Downtime** - Rolling updates via Docker Swarm  
✅ **Easy Rollback** - All images versioned in Docker Hub  
✅ **Scalable** - Add more replicas or servers easily  
✅ **Manageable** - Full control via Portainer UI  

## How to Deploy

Simply push your changes to the `main` branch:
```bash
git add .
git commit -m "Your changes"
git push origin main
```

GitHub Actions will automatically build, push, and deploy your application!