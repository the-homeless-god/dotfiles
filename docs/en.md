# Dotfiles & Development Tools

This repository contains configuration files (dotfiles) and scripts for automatic setup of a developer's working environment. Supports macOS and Linux (via Docker for testing).

## Repository Contents

### Configuration Files
- `.zshrc` - Zsh shell configuration
- `.vimrc` - Vim settings
- `.tmux.conf` - Tmux configuration
- `.alacritty.toml` - Alacritty terminal settings
- `.gitconfig` and `.gitignore` - Global Git settings
- `.editorconfig` - Code formatting settings
- Configurations for various utilities in `.config/`:
  - `bpytop` - System monitoring
  - `lf` - File manager
  - `tmux` - Session configurations
  - `vifm` - Vim-style file manager

### Scripts
- `install-tools.sh` - Main installation script
- Custom scripts in `scripts/customs/`
- Scripts for lf in `scripts/lf/`
- `tmux.sh` - Script for managing tmux sessions

## Key Features

### Development Tools
- Modern alternatives to standard utilities (eza, bat, ripgrep, etc.)
- Development tools (Git, Python, Node.js, asdf, etc.)
- File managers (lf, vifm)
- Terminal utilities (tmux, Alacritty)
- Support for various programming languages

### Configuration
- Configured Zsh with Oh My Zsh and Powerlevel10k
- Vim with development plugins
- Tmux with optimized settings
- Git integration with enhanced output

## Installation

### Direct Installation (macOS)

1. Clone the repository:
   ```bash
   git clone https://github.com/the-homeless-god/dotfiles.git ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   cd ~/dotfiles/scripts
   ./install-tools.sh
   ```

3. Follow the interactive prompts for:
   - Selecting interface language (Russian/English)
   - Choosing components to install
   - Installing configuration files
   - Running post-installation setup
   - Working with VS Code extensions

### Testing with Docker

1. Build the image:
   ```bash
   docker build -t dotfiles-test .
   ```

2. Run the container:
   ```bash
   docker run -it dotfiles-test
   ```

## Configuration Structure

### Terminal
- **Alacritty**: Modern GPU-accelerated terminal
- **Tmux**: Terminal multiplexer with custom key bindings
- **Zsh**: Configured shell with autocompletion and syntax highlighting

### Editors
- **Vim**: Configured for development with various plugins
- **VS Code**: Extension synchronization support

### File Managers
- **lf**: Modern ranger-style file manager
- **vifm**: Vim-style file manager

### Development Utilities
- **Git**: Extended configuration with aliases and integrations
- **asdf**: Programming language version management
- **Python**: Configured environment with pip
- **Node.js**: Installation via nvm with core tools

## Customization

1. Fork the repository
2. Modify configuration files to your needs
3. Add or remove tools in `install-tools.sh`
4. Configure your custom scripts in `scripts/customs/`

## Language Support

- Russian (primary)
- English (alternative)

Localization is configured through `scripts/locales.json`

## Requirements

- macOS or Linux
- Git
- Internet connection for downloading components
- For macOS: Command Line Tools

## Known Issues

- Some components may not be available on Linux
- Homebrew requires additional setup on Linux

## Contributing

1. Fork the repository
2. Create a branch for new functionality
3. Submit a pull request

## Acknowledgments

- Dotfiles community
- Developers of all tools used 

### Using Docker

#### Using Pre-built Image

We publish pre-built Docker images to GitHub Container Registry:

```bash
docker pull ghcr.io/the-homeless-god/dotfiles:latest
docker run -it ghcr.io/the-homeless-god/dotfiles:latest
```

Available tags:
- `latest` - Latest stable version
- `vX.Y.Z` - Specific version releases
- `main` - Latest development version
- `sha-XXXXXXX` - Specific commit builds

#### Local Build

If you want to build the image locally:

```bash
docker build -t dotfiles-test .
docker run -it dotfiles-test
``` 

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

You can check the current build status on the [Actions tab](https://github.com/the-homeless-god/dotfiles/actions) or by the badge at the top of the main README. 
