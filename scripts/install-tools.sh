#!/bin/bash

# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install Git and useful utilities
brew install git
brew install eza
brew install --cask db-browser-for-sqlite
brew install ripgrep
brew install procs
brew install gping
brew install mcfly
brew install git-delta
brew install wget

# Install podman and related tools
brew install podman
brew install podman-compose

# podman machine init
# podman machine start
# podman info

# Install file management and search utilities
brew install dust
brew install bat
brew install duf
brew install fd

brew install vifm
brew install vifmimg
# JFYI: pdf previewer
brew install gs

# JFYI: svg previewer
brew install imagemagick

# JFYI: video thumbnails
brew install ffmpeg
brew install mpv
brew install GraphicsMagick
brew install jstkdng/programs/ueberzugpp

# JFYI: other previews
brew install chafa
brew install unzip 7-zip rar docx2txt odt2txt gnumeric exiftool cdrtools simple-comic
brew install wkhtmltopdf
brew install glow mdcat
brew install docx2txt
brew install --cask transmission

# https://guide.macports.org/chunked/installing.macports.html
curl -O https://distfiles.macports.org/MacPorts/MacPorts-2.10.0.tar.bz2
tar xf MacPorts-2.10.0.tar.bz2
cd MacPorts-2.10.0/
./configure
make
sudo make install
cd ..
rm -rf MacPorts-2.10.0
rm -rf MacPorts-2.10.0.tar.bz2
port install catdoc


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

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install Vim plugin manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install tiling window manager for Vim
mkdir -p ~/.vim/plugin ~/.vim/doc; \
wget -qO ~/.vim/plugin/dwm.vim \
    https://raw.github.com/spolu/dwm.vim/master/plugin/dwm.vim; \
wget -qO ~/.vim/doc/dwm.txt \
    https://raw.github.com/spolu/dwm.vim/master/doc/dwm.txt;

# Install C#
brew install --cask dotnet-sdk

# Install C# language server for Vim's support
dotnet tool install --global csharp-ls


echo "Installation complete. Don't forget to configure your dotfiles and development environment!"
