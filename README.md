# CSC Workstation

A Docker-based Ubuntu desktop workstation accessible via web browser, built on [linuxserver/docker-baseimage-kasmvnc](https://github.com/linuxserver/docker-baseimage-kasmvnc). Provides a MATE desktop environment with development tools pre-installed—designed for clinical and enterprise settings with SSL/certificate workarounds.

## Features

- **Full Ubuntu Desktop** - MATE desktop environment accessible from any modern web browser
- **Pre-installed Development Tools**:
  - [VS Code](https://code.visualstudio.com/) - Code editor
  - [Miniforge](https://github.com/conda-forge/miniforge) - Conda package manager with mamba
  - [Google Chrome](https://www.google.com/chrome/) - Web browser
  - [GitHub Desktop](https://github.com/shiftkey/desktop) - Git GUI client
- **Enterprise Compatible** - Built-in SSL certificate handling for networks with traffic inspection
- **GPU Support** - Optional NVIDIA GPU passthrough for ML/AI workloads
- **Persistent Storage** - User home directory persists across container restarts

## Quick Start

### Access the Desktop

Once running, access the workstation at:
- **HTTP**: http://yourhost:3000/
- **HTTPS**: https://yourhost:3001/

Default credentials: username `abc`, password as configured (default: `abc`)

### Docker Compose (Recommended)

```yaml
services:
  workstation:
    image: ghcr.io/csc-software-stack/workstation:latest
    container_name: workstation
    security_opt:
      - seccomp:unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - PASSWORD=yourpassword
      - TITLE=CSC Workstation
    volumes:
      - workstation_data:/config
      - /var/run/docker.sock:/var/run/docker.sock  # Optional: Docker access
    ports:
      - 3000:3000
      - 3001:3001
    shm_size: "1gb"
    restart: unless-stopped

volumes:
  workstation_data:
```

### Docker CLI

```bash
docker run -d \
  --name=workstation \
  --security-opt seccomp=unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e PASSWORD=yourpassword \
  -e TITLE="CSC Workstation" \
  -p 3000:3000 \
  -p 3001:3001 \
  -v workstation_data:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  ghcr.io/csc-software-stack/workstation:latest
```

## Post-Deployment Setup

After first launch, run the interactive setup script inside the container:

```bash
/bin/bash /setup/scripts/setup.sh
```

This configures:
1. **SSL Avoidance** - For networks with traffic inspection (clinical environments)
2. **Desktop Themes** - Shortcuts, Yaru-dark theme, and UI customizations
3. **Conda Environment** - Creates `developer` environment with common data science packages
4. **VS Code Extensions** - Installs Python, Docker, Jupyter, and other extensions

## SSL Certificate Configuration

### Option 1: Custom CA Certificate (Recommended)

Place your organization's CA certificate at `/config/ssl/cert.pem` before starting the container. On startup, the container will automatically configure:

- System CA bundle (`update-ca-certificates`)
- pip, conda, curl, wget, git, npm/node
- Python `requests` library
- Desktop session environment variables

### Option 2: SSL Avoidance Mode

For networks where you cannot obtain the CA certificate, run `setup.sh` and select SSL avoidance. This disables SSL verification for package managers (use with caution).

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | 1000 | User ID for file permissions |
| `PGID` | 1000 | Group ID for file permissions |
| `TZ` | Etc/UTC | Timezone ([list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)) |
| `PASSWORD` | abc | Web interface password |
| `TITLE` | KasmVNC Client | Browser tab title |
| `SUBFOLDER` | / | Subfolder for reverse proxy (e.g., `/workstation/`) |
| `CUSTOM_PORT` | 3000 | Internal HTTP port |
| `CUSTOM_HTTPS_PORT` | 3001 | Internal HTTPS port |
| `FM_HOME` | /config | File manager home directory |

## Volumes

| Path | Description |
|------|-------------|
| `/config` | User home directory - **persist this volume** |
| `/config/ssl/cert.pem` | Custom CA certificate (optional) |
| `/var/run/docker.sock` | Host Docker socket (optional) |

## Deployment Profiles

Pre-configured compose files are available in [application/](application/):

| Profile | CPUs | RAM | GPU | Use Case |
|---------|------|-----|-----|----------|
| `docker-compose_standard.yml` | 4 | 16GB | No | General development |
| `docker-compose_highmem.yml` | 8 | 64GB | No | Data processing |
| `docker-compose_large.yml` | 16 | 48GB | No | Heavy workloads |
| `docker-compose_gpu.yml` | 24 | 64GB | Yes | ML/AI training |

Example with environment variables:
```bash
INSTANCE_ID=dev HTTP_PORT=3000 HTTPS_PORT=3001 PASSWORD=secret TITLE=DevWorkstation \
  docker compose -f application/docker-compose_standard.yml up -d
```

## GPU Support

For NVIDIA GPU passthrough:

```yaml
services:
  workstation:
    # ... other config ...
    environment:
      - DRINODE=/dev/dri/renderD128  # Optional: specific GPU
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

The setup script auto-detects GPU availability and installs appropriate CUDA-enabled packages.

## Building from Source

```bash
git clone https://github.com/CSC-Software-Stack/Workstation.git
cd Workstation/docker
docker build -t workstation:local .
```

## Project Structure

```
docker/                    # Image build context
├── Dockerfile            # Base image configuration
├── root/                 # Files copied to container root filesystem
│   ├── defaults/startwm.sh   # MATE session startup
│   └── etc/
│       ├── cont-init.d/      # Container init scripts (SSL setup)
│       └── profile.d/        # Shell profile scripts
└── setup/                # Post-deployment configuration
    ├── conda/            # Environment definitions
    ├── scripts/          # Interactive setup scripts
    └── vscode/           # VS Code settings

application/              # Deployment configurations
└── docker-compose_*.yml  # Resource profile templates
```

## Important Notes

- **Security**: Use `--security-opt seccomp=unconfined` for GUI app compatibility
- **Persistence**: System-level changes (apt packages) are lost on container recreation; user home (`/config`) persists
- **Shared Memory**: Set `--shm-size="1gb"` to prevent browser crashes

## Troubleshooting

### SSL/Certificate Errors
1. Check if `/config/ssl/cert.pem` exists and is readable
2. Restart the container to trigger certificate configuration
3. Verify environment variables: `echo $SSL_CERT_FILE`

### GUI Apps Not Starting
Ensure `--security-opt seccomp=unconfined` is set in your run command.

### Permission Issues
Match `PUID`/`PGID` to your host user: `id username`

## License

See [LICENSE](LICENSE) for details.

## Acknowledgments

Built on [linuxserver/docker-baseimage-kasmvnc](https://github.com/linuxserver/docker-baseimage-kasmvnc)
