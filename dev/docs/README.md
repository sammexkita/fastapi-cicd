# Development Guide - fastapi-cicd

This guide describes how to set up and run the development environment for the `fastapi-cicd` project.

## Prerequisites

Before starting, make sure you have installed:

- Docker and Docker Compose
- mkcert (for local SSL certificate generation)
  - macOS: `brew install mkcert`
  - Linux: See [mkcert installation guide](https://github.com/FiloSottile/mkcert#installation)
  - Windows: `choco install mkcert`

## Quick Start

Run the automated setup script:
```bash
./dev/setup.sh
```
`CONTEXT: Root Folder /`

This script will:
1. Install mkcert CA
2. Generate SSL certificates
3. Build and start Docker containers

## Accessing the Application

After setup completes, access:

- **FastAPI**: https://fastapi.localhost
- **FastAPI Docs**: https://fastapi.localhost/docs
- **Traefik Dashboard**: https://traefik.localhost

## Directory Structure
```
.
├── app
│   ├── main.py # FastAPI application
│   └── requirements.txt # Python dependencies
├── dev
│   ├── docker
│   │   ├── certs # SSL certificates (auto-generated)
│   │   │   ├── local.crt
│   │   │   ├── local.key
│   │   │   ├── traefik.localhost.crt
│   │   │   └── traefik.localhost.key
│   │   ├── docker-compose.yml
│   │   ├── Dockerfile
│   │   └── traefik
│   │       └── dynamic.yml
│   ├── docs
│   │   └── README.md 
│   └── setup.sh # Automated setup script
├── docker-compose.yml
├── Dockerfile
└── README.md
```

## Notes

- Certificates are auto-generated and git-ignored
- The `dev/` directory is excluded from production builds
- Local certificates only work on your machine