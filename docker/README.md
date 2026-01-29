# Docker Build Context

This directory contains all files needed to build the CSC Workstation Docker image.

## Building the Image

```bash
cd docker
docker build -t workstation:local .
```

## Directory Structure

```
docker/
├── Dockerfile              # Main image definition
├── root/                   # Files copied to container root (/)
│   ├── defaults/
│   │   └── startwm.sh      # Desktop session startup script
│   └── etc/
│       ├── apt/preferences.d/
│       │   └── firefox-no-snap    # Prevents Firefox snap installation
│       ├── cont-init.d/
│       │   └── 50-ssl-certs       # SSL certificate auto-configuration
│       └── profile.d/
│           └── ssl-certs.sh       # Shell environment for SSL certs
└── setup/                  # Post-deployment setup files
    ├── conda/              # Conda environment definitions
    │   ├── standard_env.yaml      # CPU-only environment
    │   └── standard_gpu_env.yaml  # GPU/CUDA environment
    ├── scripts/            # Interactive setup scripts
    │   ├── setup.sh        # Main setup entrypoint
    │   ├── ssl_avoid.sh    # SSL verification bypass
    │   ├── themes.sh       # Desktop customization
    │   ├── conda.sh        # Conda environment creation
    │   └── vscode.sh       # VS Code extension installation
    └── vscode/             # VS Code configuration
        ├── settings.json           # Default settings
        └── settings_nossl.json     # Settings with SSL bypass
```

## Customization

### Adding System Packages

Edit the `Dockerfile` and add packages to the appropriate `apt-get install` block:

```dockerfile
RUN apt-get update && apt-get install -y \
    your-package-here \
    another-package
```

### Adding Python Packages

Edit `setup/conda/standard_env.yaml` (or `standard_gpu_env.yaml` for GPU):

```yaml
dependencies:
  - your-package
  - conda-forge:specific-package
```

### Adding VS Code Extensions

Edit `setup/scripts/vscode.sh` and add extension IDs:

```bash
code --install-extension publisher.extension-name
```

### Adding Desktop Shortcuts

Edit `setup/scripts/themes.sh` to add `.desktop` files to the user's desktop.

## Container Init Scripts

Files in `root/etc/cont-init.d/` run automatically at container startup (via s6-overlay):

- **50-ssl-certs**: Detects `/config/ssl/cert.pem` and configures system-wide SSL certificates

## Base Image

Built on [ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble](https://github.com/linuxserver/docker-baseimage-kasmvnc) which provides:

- Ubuntu Noble (24.04) base
- KasmVNC web-based remote desktop
- s6-overlay init system
- LinuxServer.io conventions (PUID/PGID, /config volume)
