#!/bin/bash

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to handle user input
handle_input() {
    case "$1" in
        q|Q)
            echo "Прерывание установки / Installation aborted"
            exit 0
            ;;
        default|DEFAULT)
            export INSTALL_ALL=true
            ;;
        *)
            return
            ;;
    esac
}

# Check for curl or wget
if ! command_exists curl && ! command_exists wget; then
    echo "Error: Neither curl nor wget is installed."
    echo "Please install either curl or wget to continue."
    echo "For Alpine: apk add curl"
    echo "For Ubuntu: apt-get install curl"
    echo "For macOS: brew install curl"
    exit 1
fi

# Function to download file
download_file() {
    if command_exists curl; then
        curl -fsSL "$1"
    elif command_exists wget; then
        wget -qO- "$1"
    fi
}

# Detect package manager
detect_package_manager() {
    if command_exists brew; then
        echo "brew"
    elif command_exists apt-get; then
        echo "apt"
    elif command_exists apk; then
        echo "apk"
    else
        echo "unknown"
    fi
}

# Install package using detected package manager
install_package() {
    local package=$1
    local pkg_manager=$(detect_package_manager)
    
    case $pkg_manager in
        brew)
            brew install $package
            ;;
        apt)
            sudo apt-get update && sudo apt-get install -y $package
            ;;
        apk)
            sudo apk add --no-cache $package
            ;;
        *)
            echo "Unsupported package manager"
            return 1
            ;;
    esac
}

# Add after the initial variable declarations
declare -A INSTALLATION_SUMMARY
INSTALLATION_SUMMARY["installed"]=()
INSTALLATION_SUMMARY["skipped"]=()

# Modify install_if_confirmed function to track installations
install_if_confirmed() {
    local package=$1
    local description=$(get_description "$package")
    local str_install=$(get_localized_string "system" "install")
    local str_installing=$(get_localized_string "system" "installing")
    local str_installed=$(get_localized_string "system" "installed")
    local str_skipping=$(get_localized_string "system" "skipping")

    if [ "$INSTALL_ALL" = true ]; then
        echo "${str_installing} $package..."
        install_package "$package"
        INSTALLATION_SUMMARY["installed"]+=("$package")
        echo "$package ${str_installed}"
        return
    fi

    read -p "${str_install} ${description} ($package)? [y/N/q/default] " response
    handle_input "$response"
    
    if [ "$INSTALL_ALL" = true ]; then
        echo "${str_installing} $package..."
        install_package "$package"
        INSTALLATION_SUMMARY["installed"]+=("$package")
        echo "$package ${str_installed}"
    elif [[ "$response" =~ ^[Yy]$ ]]; then
        echo "${str_installing} $package..."
        install_package "$package"
        INSTALLATION_SUMMARY["installed"]+=("$package")
        echo "$package ${str_installed}"
    else
        echo "${str_skipping} $package"
        INSTALLATION_SUMMARY["skipped"]+=("$package")
    fi
}

# Check system and install Homebrew if supported
install_homebrew() {
    if [[ "$(uname)" == "Darwin" ]] || [[ "$(uname -s)" == "Linux" && -f "/etc/debian_version" ]]; then
        if ! command_exists brew; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(download_file https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        fi
    else
        echo "Homebrew is not supported on this system, using native package manager"
    fi
}

# Try to install Homebrew only on supported systems
install_homebrew

# Check for jq
if ! command_exists jq; then
    echo "Installing jq..."
    if command_exists brew; then
        brew install jq
    elif command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y jq
    elif command_exists apk; then
        sudo apk add --no-cache jq
    else
        echo "Error: Cannot install jq. Please install it manually."
        exit 1
    fi
fi

# Load localization
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOCALES_FILE="$SCRIPT_DIR/locales.json"

# Function to get localized string
get_localized_string() {
    local section=$1
    local key=$2
    jq -r ".[\"$LANG\"][\"$section\"][\"$key\"]" "$LOCALES_FILE"
}

# Function to extract VS Code extensions
extract_vscode_extensions() {
    local str_extract_complete=$(get_localized_string "system" "vscode_extract_complete")
    local output_file="$SCRIPT_DIR/vscode-extensions.sh"
    
    echo "#!/bin/bash" > "$output_file"
    code --list-extensions | xargs -L 1 echo code --install-extension >> "$output_file"
    chmod +x "$output_file"
    
    echo "$str_extract_complete $output_file"
}

# Function to install VS Code extensions
install_vscode_extensions() {
    local str_install_complete=$(get_localized_string "system" "vscode_install_complete")
    local extensions_file="$SCRIPT_DIR/vscode-extensions.sh"
    
    if [ -f "$extensions_file" ]; then
        bash "$extensions_file"
        echo "$str_install_complete"
    else
        echo "Extensions file not found: $extensions_file"
    fi
}

# Function to select language
select_language() {
    echo "$(get_localized_string "system" "choose_language")"
    echo "1) Русский"
    echo "2) English"
    read -p "Введите номер / Enter number (1-2): " lang_choice
    case $lang_choice in
        1)
            LANG="ru"
            ;;
        2)
            LANG="en"
            ;;
        *)
            echo "$(get_localized_string "system" "invalid_choice")"
            LANG="en"
            ;;
    esac
}

# Function to get package description
get_description() {
    local package=$1
    jq -r ".[\"$LANG\"][\"packages\"][\"$package\"] // \"$package\"" "$LOCALES_FILE"
}

# Select language
select_language



# Install Git and useful utilities
install_if_confirmed "git" "git"
install_if_confirmed "curl" "curl"
install_if_confirmed "zsh" "zsh"
install_if_confirmed "ripgrep" "ripgrep"
install_if_confirmed "bat" "bat"
install_if_confirmed "fd" "fd"

# Install Python 3.11
install_if_confirmed "python3" "python3"
if command_exists python3; then
    python3 -m ensurepip --upgrade
fi

# Install Vim and related tools
install_if_confirmed "vim" "vim"
install_if_confirmed "tmux" "tmux"

# Install file management utilities
install_if_confirmed "vifm" "vifm"

# Media utilities
install_if_confirmed "ffmpeg" "ffmpeg"
install_if_confirmed "imagemagick" "imagemagick"

# Other utilities
install_if_confirmed "unzip" "unzip"
install_if_confirmed "wget" "wget"

# Install podman and related tools
install_if_confirmed "podman" "brew install podman"
install_if_confirmed "podman-compose" "brew install podman-compose"

# Install file management and search utilities
install_if_confirmed "dust" "brew install dust"
install_if_confirmed "duf" "brew install duf"

install_if_confirmed "vifmimg" "brew install vifmimg"
install_if_confirmed "gs" "brew install gs"

# Media utilities
install_if_confirmed "mpv" "brew install mpv"
install_if_confirmed "GraphicsMagick" "brew install GraphicsMagick"
install_if_confirmed "ueberzugpp" "brew install jstkdng/programs/ueberzugpp"

# Other utilities for preview
install_if_confirmed "chafa" "brew install chafa"
install_if_confirmed "archive-tools" "brew install unzip 7-zip rar"
install_if_confirmed "document-tools" "brew install docx2txt odt2txt gnumeric exiftool"
install_if_confirmed "media-tools" "brew install cdrtools simple-comic"
install_if_confirmed "wkhtmltopdf" "brew install wkhtmltopdf"
install_if_confirmed "markdown-tools" "brew install glow mdcat"
install_if_confirmed "transmission" "brew install --cask transmission"

# MacPorts installation
install_if_confirmed "macports" "curl -O https://distfiles.macports.org/MacPorts/MacPorts-2.10.0.tar.bz2 && \
tar xf MacPorts-2.10.0.tar.bz2 && \
cd MacPorts-2.10.0/ && \
./configure && \
make && \
sudo make install && \
cd .. && \
rm -rf MacPorts-2.10.0 && \
rm -rf MacPorts-2.10.0.tar.bz2 && \
port install catdoc"

# Install Node Version Manager (NVM)
install_if_confirmed "nvm" "brew install nvm && \
echo 'export NVM_DIR=\"\$HOME/.nvm\"' >> ~/.zshrc && \
echo 'source \$(brew --prefix nvm)/nvm.sh' >> ~/.zshrc"

# Install text editors and terminal tools
install_if_confirmed "alacritty" "brew install alacritty"
install_if_confirmed "vim" "brew install vim"
install_if_confirmed "tmux" "brew install tmux"

# Install TPM
install_if_confirmed "tpm" "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"

# Install fonts
install_if_confirmed "nerd-fonts" "brew tap homebrew/cask-fonts && \
brew install --cask font-meslo-lg-nerd-font && \
brew install --cask font-fira-code-nerd-font"

# Install browsers and applications
install_if_confirmed "w3m" "brew install w3m"
install_if_confirmed "qutebrowser" "brew install --cask qutebrowser"
install_if_confirmed "insomnia" "brew install --cask insomnia"
install_if_confirmed "neofetch" "brew install neofetch"
install_if_confirmed "tree" "brew install tree"

# Install LM Studio
install_if_confirmed "lm-studio" "wget https://releases.lmstudio.ai/mac/arm64/0.2.29/latest/LM-Studio-0.2.29-arm64.dmg && \
~/.cache/lm-studio/bin/lms bootstrap"

install_if_confirmed "open-interpreter" "python3.11 -m pip install open-interpreter"

# Install Oh My Zsh
install_if_confirmed "oh-my-zsh" "sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""

# Install powerlevel10k
install_if_confirmed "powerlevel10k" "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Install Vim plugin manager
install_if_confirmed "vim-plug" "curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Install tiling window manager for Vim
install_if_confirmed "dwm-vim" "mkdir -p ~/.vim/plugin ~/.vim/doc && \
wget -qO ~/.vim/plugin/dwm.vim \
    https://raw.github.com/spolu/dwm.vim/master/plugin/dwm.vim && \
wget -qO ~/.vim/doc/dwm.txt \
    https://raw.github.com/spolu/dwm.vim/master/doc/dwm.txt"

# Install C#
install_if_confirmed "dotnet-sdk" "brew install --cask dotnet-sdk"

# Install C# language server
install_if_confirmed "csharp-ls" "dotnet tool install --global csharp-ls"

# Function to install configurations
install_configs() {
    local str_backup_start=$(get_localized_string "system" "backup_start")
    local str_backup_complete=$(get_localized_string "system" "backup_complete")
    local str_import_start=$(get_localized_string "system" "import_start")
    local str_import_complete=$(get_localized_string "system" "import_complete")

    echo "$str_backup_start"
    
    DOTFILES_BACKUP_PATH=~/.dotfiles-backup
    
    # Create directories for backup
    mkdir -p "$DOTFILES_BACKUP_PATH"
    mkdir -p "$DOTFILES_BACKUP_PATH/.config/lf"
    mkdir -p "$DOTFILES_BACKUP_PATH/.config/vifm"
    mkdir -p "$DOTFILES_BACKUP_PATH/.config/bpytop"
    mkdir -p "$DOTFILES_BACKUP_PATH/.config/tmux"
    mkdir -p "$DOTFILES_BACKUP_PATH/dotfiles/scripts/customs"
    mkdir -p "$DOTFILES_BACKUP_PATH/dotfiles/scripts/lf"
    
    # Backup existing configurations
    [ -f ~/.zshrc ] && mv ~/.zshrc "$DOTFILES_BACKUP_PATH"
    [ -f ~/.vimrc ] && mv ~/.vimrc "$DOTFILES_BACKUP_PATH"
    [ -f ~/.gitignore ] && mv ~/.gitignore "$DOTFILES_BACKUP_PATH"
    [ -f ~/.gitconfig ] && mv ~/.gitconfig "$DOTFILES_BACKUP_PATH"
    [ -f ~/.editorconfig ] && mv ~/.editorconfig "$DOTFILES_BACKUP_PATH"
    [ -f ~/.alacritty.toml ] && mv ~/.alacritty.toml "$DOTFILES_BACKUP_PATH"
    [ -f ~/.tmux.conf ] && mv ~/.tmux.conf "$DOTFILES_BACKUP_PATH"
    [ -f ~/.lfrc ] && mv ~/.lfrc "$DOTFILES_BACKUP_PATH"
    [ -f ~/tmux.sh ] && mv ~/tmux.sh "$DOTFILES_BACKUP_PATH"
    [ -f ~/wallpaper.jpeg ] && mv ~/wallpaper.jpeg "$DOTFILES_BACKUP_PATH"
    [ -d ~/.vscode ] && mv ~/.vscode "$DOTFILES_BACKUP_PATH"
    [ -d ~/.config/lf ] && mv ~/.config/lf "$DOTFILES_BACKUP_PATH/.config/"
    [ -d ~/.config/vifm ] && mv ~/.config/vifm "$DOTFILES_BACKUP_PATH/.config/"
    [ -d ~/.config/bpytop ] && mv ~/.config/bpytop "$DOTFILES_BACKUP_PATH/.config/"
    [ -d ~/.config/tmux ] && mv ~/.config/tmux "$DOTFILES_BACKUP_PATH/.config/"
    [ -d ~/dotfiles/scripts ] && mv ~/dotfiles/scripts "$DOTFILES_BACKUP_PATH/dotfiles/"
    
    echo "$str_backup_complete $DOTFILES_BACKUP_PATH"
    
    echo "$str_import_start"
    
    # Create necessary directories
    mkdir -p ~/.config/lf
    mkdir -p ~/.config/vifm
    mkdir -p ~/.config/bpytop
    mkdir -p ~/.config/tmux
    mkdir -p ~/dotfiles/scripts/customs
    mkdir -p ~/dotfiles/scripts/lf
    
    # Copy new configurations
    CONFIGS_DIR="$(dirname "$SCRIPT_DIR")/configs"
    [ -f "$CONFIGS_DIR/.zshrc" ] && cp "$CONFIGS_DIR/.zshrc" ~/
    [ -f "$CONFIGS_DIR/.vimrc" ] && cp "$CONFIGS_DIR/.vimrc" ~/
    [ -f "$CONFIGS_DIR/.gitignore" ] && cp "$CONFIGS_DIR/.gitignore" ~/
    [ -f "$CONFIGS_DIR/.gitconfig" ] && cp "$CONFIGS_DIR/.gitconfig" ~/
    [ -f "$CONFIGS_DIR/.editorconfig" ] && cp "$CONFIGS_DIR/.editorconfig" ~/
    [ -f "$CONFIGS_DIR/.alacritty.toml" ] && cp "$CONFIGS_DIR/.alacritty.toml" ~/
    [ -f "$CONFIGS_DIR/.tmux.conf" ] && cp "$CONFIGS_DIR/.tmux.conf" ~/
    [ -f "$CONFIGS_DIR/.lfrc" ] && cp "$CONFIGS_DIR/.lfrc" ~/
    [ -f "$CONFIGS_DIR/tmux.sh" ] && cp "$CONFIGS_DIR/tmux.sh" ~/
    [ -f "$CONFIGS_DIR/wallpaper.jpeg" ] && cp "$CONFIGS_DIR/wallpaper.jpeg" ~/
    [ -d "$CONFIGS_DIR/.vscode" ] && cp -r "$CONFIGS_DIR/.vscode" ~/
    [ -d "$CONFIGS_DIR/.config/lf" ] && cp -r "$CONFIGS_DIR/.config/lf" ~/.config/
    [ -d "$CONFIGS_DIR/.config/vifm" ] && cp -r "$CONFIGS_DIR/.config/vifm" ~/.config/
    [ -d "$CONFIGS_DIR/.config/bpytop" ] && cp -r "$CONFIGS_DIR/.config/bpytop" ~/.config/
    [ -d "$CONFIGS_DIR/.config/tmux" ] && cp -r "$CONFIGS_DIR/.config/tmux" ~/.config/
    
    # Copy custom scripts
    [ -d "$SCRIPT_DIR/customs" ] && cp -r "$SCRIPT_DIR/customs/"* ~/dotfiles/scripts/customs/
    [ -d "$SCRIPT_DIR/lf" ] && cp -r "$SCRIPT_DIR/lf/"* ~/dotfiles/scripts/lf/
    [ -f "$SCRIPT_DIR/tmux.sh" ] && cp "$SCRIPT_DIR/tmux.sh" ~/dotfiles/scripts/
    
    # Make scripts executable
    find ~/dotfiles/scripts -type f -name "*.sh" -exec chmod +x {} \;
    
    echo "$str_import_complete ~/"
}

# Function to run post-installation settings
run_post_install() {
    local str_post_start=$(get_localized_string "system" "post_install_start")
    local str_post_complete=$(get_localized_string "system" "post_install_complete")
    
    echo "$str_post_start"
    
    # Install and configure coc.nvim
    if [ -d ~/.vim/plug/coc.nvim ]; then
        cd ~/.vim/plug/coc.nvim
        npm ci
    fi
    
    # Install zsh-autosuggestions
    if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    echo "$str_post_complete"
}

# Ask about installing configurations
read -p "$(get_localized_string "system" "install_configs")? [y/N] " install_configs_response
if [[ "$install_configs_response" =~ ^[Yy]$ ]]; then
    install_configs
fi

# Ask about post-installation
read -p "$(get_localized_string "system" "run_post_install")? [y/N] " post_install_response
if [[ "$post_install_response" =~ ^[Yy]$ ]]; then
    run_post_install
fi

# Ask about VS Code extensions
read -p "$(get_localized_string "system" "vscode_extract")? [y/N] " extract_extensions_response
if [[ "$extract_extensions_response" =~ ^[Yy]$ ]]; then
    extract_vscode_extensions
fi

read -p "$(get_localized_string "system" "vscode_install")? [y/N] " install_extensions_response
if [[ "$install_extensions_response" =~ ^[Yy]$ ]]; then
    install_vscode_extensions
fi

# Add before the final "complete" message
print_summary() {
    local str_summary_header=$(get_localized_string "system" "summary_header")
    local str_installed_header=$(get_localized_string "system" "installed_header")
    local str_skipped_header=$(get_localized_string "system" "skipped_header")
    
    echo
    echo "=== ${str_summary_header} ==="
    echo
    echo "${str_installed_header}:"
    if [ ${#INSTALLATION_SUMMARY["installed"]} -eq 0 ]; then
        echo "  - None"
    else
        for pkg in "${INSTALLATION_SUMMARY["installed"][@]}"; do
            echo "  - $pkg: $(get_description "$pkg")"
        done
    fi
    
    echo
    echo "${str_skipped_header}:"
    if [ ${#INSTALLATION_SUMMARY["skipped"]} -eq 0 ]; then
        echo "  - None"
    else
        for pkg in "${INSTALLATION_SUMMARY["skipped"][@]}"; do
            echo "  - $pkg: $(get_description "$pkg")"
        done
    fi
    echo
}

print_summary
echo "$(get_localized_string "system" "complete")"
