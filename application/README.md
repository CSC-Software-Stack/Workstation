# Deployment Configurations

This directory contains Docker Compose files with pre-configured resource profiles for different workloads.

## Available Profiles

| File | CPUs | Memory | GPU | Best For |
|------|------|--------|-----|----------|
| `docker-compose_standard.yml` | 4 | 16GB | No | General development, light workloads |
| `docker-compose_highmem.yml` | 8 | 32GB | No | Data processing, larger datasets |
| `docker-compose_large.yml` | 16 | 48GB | No | Heavy computation, multiple processes |
| `docker-compose_gpu.yml` | 24 | 64GB | Yes | ML/AI training, GPU-accelerated tasks |

## Required Environment Variables

All compose files require these environment variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `INSTANCE_ID` | Unique identifier for the instance | `dev`, `user1`, `prod` |
| `HTTP_PORT` | External HTTP port | `3000` |
| `HTTPS_PORT` | External HTTPS port | `3001` |
| `PASSWORD` | Web interface password | `mysecretpassword` |
| `TITLE` | Browser tab title | `My Workstation` |

For GPU deployments:
| Variable | Description | Example |
|----------|-------------|---------|
| `GPU_ID` | NVIDIA GPU device ID | `0`, `1` |

## Usage

### Using Environment Variables

```bash
# Standard deployment
INSTANCE_ID=dev HTTP_PORT=3000 HTTPS_PORT=3001 PASSWORD=secret TITLE=DevWorkstation \
  docker compose -f docker-compose_standard.yml up -d

# GPU deployment
INSTANCE_ID=ml HTTP_PORT=3002 HTTPS_PORT=3003 PASSWORD=secret TITLE=ML-Workstation GPU_ID=0 \
  docker compose -f docker-compose_gpu.yml up -d
```

### Using an Environment File

Create a `.env` file:
```bash
INSTANCE_ID=myworkstation
HTTP_PORT=3000
HTTPS_PORT=3001
PASSWORD=mysecretpassword
TITLE=My CSC Workstation
```

Then run:
```bash
docker compose -f docker-compose_standard.yml up -d
```

## Multiple Instances

Deploy multiple workstations on the same host using different instance IDs and ports:

```bash
# Instance 1
INSTANCE_ID=user1 HTTP_PORT=3000 HTTPS_PORT=3001 PASSWORD=pass1 TITLE=User1 \
  docker compose -f docker-compose_standard.yml up -d

# Instance 2
INSTANCE_ID=user2 HTTP_PORT=3002 HTTPS_PORT=3003 PASSWORD=pass2 TITLE=User2 \
  docker compose -f docker-compose_standard.yml up -d
```

Each instance gets its own named volume (`csc_workstation-${INSTANCE_ID}`) for persistent storage.

## Stopping and Removing

```bash
# Stop
INSTANCE_ID=dev docker compose -f docker-compose_standard.yml down

# Stop and remove volumes (destroys user data!)
INSTANCE_ID=dev docker compose -f docker-compose_standard.yml down -v
```
