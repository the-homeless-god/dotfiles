#!/bin/bash

# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install Git and useful utilities
brew install git
brew install exa
brew install ripgrep
brew install procs
brew install gping
brew install mcfly
brew install git-delta

# Install podman and related tools
brew install podman
brew install podman-compose
podman machine init
podman machine start
podman info

# Install file management and search utilities
brew install dust
brew install bat
brew install duf
brew install fd

# JFYI: pdf previewer
brew install gs

# JFYI: svg previewer
brew install imagemagick

# JFYI: video thumbnails
brew install ffmpeg
brew install mpv
brew install GraphicsMagick
brew install jstkdng/programs/ueberzugpp

# Install Node Version Manager (NVM)
brew install nvm
# Configure NVM (add to your shell profile)
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo 'source $(brew --prefix nvm)/nvm.sh' >> ~/.zshrc

# Install text editors
brew install alacritty
brew install vim
brew install tmux

# Install and configure TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install and configure fonts
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
brew install --cask font-fira-code-nerd-font

# Install web browsers and other applications
brew install w3m
brew install --cask qutebrowser
brew install --cask insomnia
brew install neofetch

# Install LM Studio
wget https://releases.lmstudio.ai/mac/arm64/0.2.29/latest/LM-Studio-0.2.29-arm64.dmg
~/.cache/lm-studio/bin/lms bootstrap
python3.11 -m pip install open-interpreter


# Optional: Copy your configuration files (e.g., .zshrc, .tmux.conf, .alacritty.toml, etc.) to the appropriate locations
# Example: cp path/to/your/.alacritty.toml ~/.config/alacritty/.alacritty.toml

# Optional: Set up your development environment, clone repositories, and configure your tools
# Example: git clone https://github.com/your/repo.git ~/projects/repo

echo "Installation complete. Don't forget to configure your dotfiles and development environment!"
