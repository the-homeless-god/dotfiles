# Dotfiles & Development Tools

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Docker Build](https://github.com/the-homeless-god/dotfiles/actions/workflows/docker-publish.yml/badge.svg)
![GitHub package (latest by date)](https://github.com/the-homeless-god/dotfiles/pkgs/container/dotfiles)

Environment configuration and development tools setup automation.

[🇷🇺 Русская версия](docs/ru.md) | [🇬🇧 English version](docs/en.md)

## Quick Start

### macOS

```bash
git clone https://github.com/the-homeless-god/dotfiles.git ~/dotfiles
cd ~/dotfiles/scripts
./install-tools.sh
```

### Docker

#### Using pre-built image

```bash
# Run container
docker pull ghcr.io/the-homeless-god/dotfiles:latest
docker run -it --name dotfiles ghcr.io/the-homeless-god/dotfiles:latest

# To reconnect to the container later
docker start dotfiles
docker exec -it dotfiles /bin/bash
```

#### Building locally

```bash
# Build and run container
docker build -t dotfiles-test .
docker run -it --name dotfiles-dev dotfiles-test

# To reconnect to the container later
docker start dotfiles-dev
docker exec -it dotfiles-dev /bin/bash
```

## Preview

![Terminal Preview](configs/wallpaper.jpeg)

## CI/CD

This repository uses GitHub Actions for continuous integration and delivery:

- Automatic Docker image builds on every push to main branch
- Automatic releases when tags are pushed
- Image publishing to GitHub Container Registry
- Build caching for faster builds
- Automated tagging system

### Automated Builds

The following events trigger builds:

- Push to main branch
- Creation of tags (vX.Y.Z)
- Pull requests

### Docker Tags

Available tags in the registry:

- `latest` - Latest stable version
- `vX.Y.Z` - Specific version releases
- `main` - Latest development version
- `sha-XXXXXXX` - Specific commit builds

### Registry

Images are published to GitHub Container Registry (ghcr.io):

```bash
ghcr.io/the-homeless-god/dotfiles
```

### Build Status

You can check the current build status on the [Actions tab](https://github.com/the-homeless-god/dotfiles/actions) or by the badge at the top of this README.

## License

MIT
