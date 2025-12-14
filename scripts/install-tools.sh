#!/bin/bash

# Переменные для режимов работы
DRY_RUN=false
VERBOSE=false
AUTO_LANG=""
LANG="en"  # Значение по умолчанию
INTERACTIVE=false
SELECTED_TOOLS=()
INSTALLATION_SUMMARY_INSTALLED=""
INSTALLATION_SUMMARY_SKIPPED=""

# Загружаем локализации
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOCALES_FILE="$SCRIPT_DIR/locales.json"
TOOLS_FILE="$(dirname "$SCRIPT_DIR")/configs/tools.json"

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null
}

# Function to check if package is already installed
check_package_installed() {
    local package=$1
    
    echo "DEBUG: Проверка установки пакета $package..." >&2
    
    # Упрощенная проверка - используем только command_exists
    command_exists "$package"
    return $?
}

# Function to get package version
get_package_version() {
    local package=$1
    echo "unknown"  # Возвращаем unknown для всех пакетов, чтобы избежать зависаний
}

# Function to get localized string
get_localized_string() {
    local section=$1
    local key=$2
    jq -r ".[\"$LANG\"][\"$section\"][\"$key\"] // \"$key\"" "$LOCALES_FILE"
}

# Function to get package description
get_description() {
    local package=$1
    jq -r ".[\"$LANG\"][\"packages\"][\"$package\"] // \"$package\"" "$LOCALES_FILE"
}

# Install a package depending on the system
install_package() {
    local package=$1
    if command_exists brew; then
        brew install "$package"
    elif command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y "$package"
    elif command_exists apk; then
        sudo apk add --no-cache "$package"
    elif command_exists yum; then
        sudo yum install -y "$package"
    elif command_exists dnf; then
        sudo dnf install -y "$package"
    elif command_exists pacman; then
        sudo pacman -S --noconfirm "$package"
    else
        echo "Error: Unsupported package manager. Please install $package manually."
        return 1
    fi
}

# Function to install if confirmed in interactive mode or normally otherwise
install_if_confirmed() {
    local package=$1
    local alt_name=${2:-$package}
    
    if [ "$INTERACTIVE" = true ]; then
        if is_tool_selected "$package"; then
            if [ "$DRY_RUN" = true ]; then
                echo "[DRY-RUN] $(get_localized_string "system" "installing") $package"
                INSTALLATION_SUMMARY_INSTALLED="$INSTALLATION_SUMMARY_INSTALLED $package"
            else
                echo "$(get_localized_string "system" "installing") $package..."
                install_package "$alt_name"
                if [ $? -eq 0 ]; then
                    echo "$package $(get_localized_string "system" "installed")"
                    INSTALLATION_SUMMARY_INSTALLED="$INSTALLATION_SUMMARY_INSTALLED $package"
                fi
            fi
        else
            echo "$(get_localized_string "system" "skipping") $package"
            INSTALLATION_SUMMARY_SKIPPED="$INSTALLATION_SUMMARY_SKIPPED $package"
        fi
    else
        read -p "$(get_localized_string "system" "install") $package? [y/N] " install_response
        if [[ "$install_response" =~ ^[Yy]$ ]]; then
            if [ "$DRY_RUN" = true ]; then
                echo "[DRY-RUN] $(get_localized_string "system" "installing") $package"
                INSTALLATION_SUMMARY_INSTALLED="$INSTALLATION_SUMMARY_INSTALLED $package"
            else
                echo "$(get_localized_string "system" "installing") $package..."
                install_package "$alt_name"
                if [ $? -eq 0 ]; then
                    echo "$package $(get_localized_string "system" "installed")"
                    INSTALLATION_SUMMARY_INSTALLED="$INSTALLATION_SUMMARY_INSTALLED $package"
                fi
            fi
        else
            echo "$(get_localized_string "system" "skipping") $package"
            INSTALLATION_SUMMARY_SKIPPED="$INSTALLATION_SUMMARY_SKIPPED $package"
        fi
    fi
}

# Function to check if dialog/whiptail/gum is installed
check_dialog_installed() {
    if command_exists whiptail; then
        DIALOG="whiptail"
        return 0
    elif command_exists dialog; then
        DIALOG="dialog"
        return 0
    elif command_exists gum; then
        DIALOG="gum"
        return 0
    else
        return 1
    fi
}

# Function to ensure dialog tool is installed
ensure_dialog_installed() {
    if check_dialog_installed; then
        return 0
    fi
    
    echo "$(get_localized_string "system" "installing_ui_tools")"
    
    # Try to install whiptail first (widely available)
    if command_exists brew; then
        brew install ncurses
        if ! command_exists whiptail; then
            # On macOS, whiptail comes with ncurses
            if ! command_exists gum; then
                brew install gum
            fi
        fi
    elif command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y whiptail
    elif command_exists apk; then
        sudo apk add --no-cache whiptail
    elif command_exists yum; then
        sudo yum install -y whiptail
    elif command_exists dnf; then
        sudo dnf install -y whiptail
    elif command_exists pacman; then
        sudo pacman -S --noconfirm whiptail
    else
        echo "$(get_localized_string "system" "ui_tools_install_error")"
        exit 1
    fi
    
    # Check if installation was successful
    check_dialog_installed
    return $?
}

# Function to show interactive tool selection
show_interactive_menu() {
    local title_key="title_$LANG"
    local description_key="description_$LANG"
    
    # Determine terminal size
    local term_height=$(tput lines)
    local term_width=$(tput cols)
    local menu_height=$((term_height - 10))
    local menu_width=$((term_width - 20))
    
    # Ensure we have a dialog tool installed
    if ! ensure_dialog_installed; then
        echo "$(get_localized_string "system" "ui_tools_required")"
        echo "$(get_localized_string "system" "ui_tools_install_error")"
        exit 1
    fi
    
    # First, let user select categories
    local categories_temp=$(mktemp)
    local i=1
    local categories_list=""
    
    # Get all categories
    local all_categories=$(jq -r ".categories[].name" "$TOOLS_FILE")
    
    if [ "$DIALOG" = "gum" ]; then
        # For gum, we use a different approach
        echo "$(get_localized_string "system" "category_select_title")"
        echo "$(get_localized_string "system" "category_select_text")"
        
        # Create array for gum choose
        local gum_categories=()
        for category in $all_categories; do
            local title=$(jq -r ".categories[] | select(.name == \"$category\") | .$title_key" "$TOOLS_FILE")
            local desc=$(jq -r ".categories[] | select(.name == \"$category\") | .$description_key" "$TOOLS_FILE")
            gum_categories+=("$category:$title - $desc")
        done
        
        # По умолчанию выбираем все категории
        local selected_categories="$all_categories"
        
        # Спрашиваем пользователя, хочет ли он выбрать все категории
        echo "Выбрать все категории? [Y/n]"
        read -r select_all_cats
        
        # Если пользователь не хочет выбрать все категории, предлагаем индивидуальный выбор
        if [[ "$select_all_cats" =~ ^[Nn]$ ]]; then
            selected_categories=""
            echo "Выберите категории (нажмите Enter после выбора каждой категории, Ctrl+C когда закончите):"
            
            # Loop until user cancels with Ctrl+C
            while true; do
                local choice
                choice=$(printf "%s\n" "${gum_categories[@]}" | gum choose) || break
                local category_name=$(echo "$choice" | cut -d':' -f1)
                
                # Add to selected categories if not already there
                if [[ ! "$selected_categories" =~ "$category_name" ]]; then
                    if [ -z "$selected_categories" ]; then
                        selected_categories="$category_name"
                    else
                        selected_categories="$selected_categories $category_name"
                    fi
                    echo "Выбрано: $category_name"
                fi
            done
        else
            echo "Выбраны все категории"
        fi
        
        if [ -z "$selected_categories" ]; then
            echo "$(get_localized_string "system" "installation_cancelled")"
            exit 0
        fi
        
        # Next, let user select tools from selected categories
        echo "$(get_localized_string "system" "tools_select_title")"
        echo "$(get_localized_string "system" "tools_select_text")"
        
        # Create array for tools and get all available tools from selected categories
        local gum_tools=()
        local all_tools=""
        
        echo "DEBUG: Формирование списка инструментов..." >&2
        
        for category in $selected_categories; do
            # Get tools for this category
            echo "DEBUG: Получение инструментов для категории $category..." >&2
            local tools=$(jq -r ".categories[] | select(.name == \"$category\") | .tools[]" "$TOOLS_FILE")
            
            # Add to all tools list
            if [ -z "$all_tools" ]; then
                all_tools="$tools"
            else
                all_tools="$all_tools $tools"
            fi
            
            # Add to tools list for display with installed status
            for tool in $tools; do
                echo "DEBUG: Добавление инструмента $tool в список..." >&2
                local desc=$(get_description "$tool")
                local status=""
                if check_package_installed "$tool"; then
                    local version=$(get_package_version "$tool")
                    status=" [✓ $version]"
                else
                    status=" [✗]"
                fi
                gum_tools+=("$tool:$desc$status")
            done
        done
        
        # По умолчанию выбираем все инструменты
        SELECTED_TOOLS="$all_tools"
        
        # Check for config updates
        echo "Проверяем наличие обновлений конфигурации..."
        local has_config_updates=false
        local config_updates=""
        
        # Check if any config files were modified compared to installed versions
        if [ -f "$HOME/.zshrc" ] && [ -f "$(dirname "$SCRIPT_DIR")/configs/.zshrc" ]; then
            if ! cmp -s "$HOME/.zshrc" "$(dirname "$SCRIPT_DIR")/configs/.zshrc"; then
                has_config_updates=true
                config_updates+="- .zshrc\n"
            fi
        fi
        
        if [ -f "$HOME/.vimrc" ] && [ -f "$(dirname "$SCRIPT_DIR")/configs/.vimrc" ]; then
            if ! cmp -s "$HOME/.vimrc" "$(dirname "$SCRIPT_DIR")/configs/.vimrc"; then
                has_config_updates=true
                config_updates+="- .vimrc\n"
            fi
        fi
        
        if $has_config_updates; then
            echo "Обнаружены обновленные конфигурационные файлы:"
            echo -e "$config_updates"
        fi
        
        # Спрашиваем пользователя, хочет ли он выбрать все инструменты
        echo "Выбрать все инструменты? [Y/n]"
        read -r select_all_tools
        
        # Если пользователь не хочет выбрать все инструменты, предлагаем индивидуальный выбор
        if [[ "$select_all_tools" =~ ^[Nn]$ ]]; then
            SELECTED_TOOLS=""
            echo "Выберите инструменты (нажмите Enter после выбора каждого инструмента, Ctrl+C когда закончите):"
            
            # Show selected items with a checkmark
            echo "Выбранные инструменты будут помечены при следующем выборе."
            
            # Loop until user cancels with Ctrl+C
            while true; do
                # Update display to show already selected tools
                local display_tools=()
                for item in "${gum_tools[@]}"; do
                    local tool_name=$(echo "$item" | cut -d':' -f1)
                    if [[ "$SELECTED_TOOLS" =~ "$tool_name" ]]; then
                        display_tools+=("✅ $item")
                    else
                        display_tools+=("  $item")
                    fi
                done
                
                local choice
                choice=$(printf "%s\n" "${display_tools[@]}" | gum choose) || break
                
                # Remove potential checkmark prefix
                choice=${choice#"✅ "}
                local tool_name=$(echo "$choice" | cut -d':' -f1)
                
                # Toggle selection
                if [[ "$SELECTED_TOOLS" =~ "$tool_name" ]]; then
                    # Remove from selection
                    SELECTED_TOOLS=$(echo "$SELECTED_TOOLS" | sed "s/$tool_name//g" | tr -s ' ' | sed 's/^ //' | sed 's/ $//')
                    echo "Отменено: $tool_name"
                else
                    # Add to selection
                    if [ -z "$SELECTED_TOOLS" ]; then
                        SELECTED_TOOLS="$tool_name"
                    else
                        SELECTED_TOOLS="$SELECTED_TOOLS $tool_name"
                    fi
                    echo "Выбрано: $tool_name"
                fi
            done
        else
            echo "Выбраны все инструменты"
        fi
        
        if [ -z "$SELECTED_TOOLS" ]; then
            echo "$(get_localized_string "system" "installation_cancelled")"
            exit 0
        fi
        
        # Show confirmation
        echo "$(get_localized_string "system" "confirm_text") [Y/n]"
        read -r confirm
        if [[ "$confirm" =~ ^[Nn]$ ]]; then
            echo "$(get_localized_string "system" "installation_cancelled")"
            exit 0
        fi
    else
        # Build categories list for checklist
        for category in $all_categories; do
            local title=$(jq -r ".categories[] | select(.name == \"$category\") | .$title_key" "$TOOLS_FILE")
            local desc=$(jq -r ".categories[] | select(.name == \"$category\") | .$description_key" "$TOOLS_FILE")
            categories_list="$categories_list $category \"$title - $desc\" ON "
        done
        
        # Display categories checklist
        local category_title="$(get_localized_string "system" "category_select_title")"
        local category_text="$(get_localized_string "system" "category_select_text")"
        
        $DIALOG --title "$category_title" \
            --checklist "$category_text" \
            $menu_height $menu_width $((menu_height - 8)) \
            $categories_list 2> "$categories_temp"
        
        # If user cancels, exit
        if [ $? -ne 0 ]; then
            rm "$categories_temp"
            echo "$(get_localized_string "system" "installation_cancelled")"
            exit 0
        fi
        
        local selected_categories=$(cat "$categories_temp")
        rm "$categories_temp"
        
        # Next, let user select tools from selected categories
        local tools_temp=$(mktemp)
        local tools_list=""
        
        # Build tools list for checklist
        for category in $selected_categories; do
            # Get tools for this category
            local tools=$(jq -r ".categories[] | select(.name == \"$category\") | .tools[]" "$TOOLS_FILE")
            
            # Add to tools list
            for tool in $tools; do
                local desc=$(get_description "$tool")
                tools_list="$tools_list $tool \"$desc\" ON "
            done
        done
        
        # Display tools checklist
        local tools_title="$(get_localized_string "system" "tools_select_title")"
        local tools_text="$(get_localized_string "system" "tools_select_text")"
        
        $DIALOG --title "$tools_title" \
            --checklist "$tools_text" \
            $menu_height $menu_width $((menu_height - 8)) \
            $tools_list 2> "$tools_temp"
        
        # If user cancels, exit
        if [ $? -ne 0 ]; then
            rm "$tools_temp"
            echo "$(get_localized_string "system" "installation_cancelled")"
            exit 0
        fi
        
        # Read selected tools
        SELECTED_TOOLS=$(cat "$tools_temp")
        rm "$tools_temp"
        
        # Show confirmation
        local confirm_title="$(get_localized_string "system" "confirm_title")"
        local confirm_text="$(get_localized_string "system" "confirm_text")"
        
        $DIALOG --title "$confirm_title" \
            --yesno "$confirm_text" \
            10 60
        
        if [ $? -ne 0 ]; then
            echo "$(get_localized_string "system" "installation_cancelled")"
            exit 0
        fi
    fi
}

# Function to check if a tool is selected in interactive mode
is_tool_selected() {
    local tool=$1
    [[ " ${SELECTED_TOOLS[@]} " =~ " $tool " ]]
}

# Function to select language
select_language() {
    # Если язык уже указан через аргумент командной строки
    if [ -n "$AUTO_LANG" ]; then
        case "$AUTO_LANG" in
            ru)
                LANG="ru"
                ;;
            en)
                LANG="en"
                ;;
            *)
                echo "Неподдерживаемый язык: $AUTO_LANG, используется английский"
                LANG="en"
                ;;
        esac
        return
    fi

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

# Функция для обработки аргументов командной строки
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --interactive)
                INTERACTIVE=true
                shift
                ;;
            --lang)
                if [ -n "$2" ] && [[ "$2" != --* ]]; then
                    AUTO_LANG="$2"
                    LANG="$2"  # Устанавливаем язык сразу для справки
                    shift 2
                else
                    echo "$(get_localized_string "system" "error_lang_value")"
                    exit 1
                fi
                ;;
            --help)
                echo "$(get_localized_string "system" "help_usage"): $0 [$(get_localized_string "system" "help_options")]"
                echo "$(get_localized_string "system" "help_options"):"
                echo "  --dry-run      $(get_localized_string "system" "help_dry_run")"
                echo "  --verbose      $(get_localized_string "system" "help_verbose")"
                echo "  --interactive  $(get_localized_string "system" "help_interactive")"
                echo "  --lang ru|en   $(get_localized_string "system" "help_lang")"
                echo "  --help         $(get_localized_string "system" "help_help")"
                exit 0
                ;;
            *)
                echo "$(get_localized_string "system" "error_unknown_arg"): $1"
                echo "$(get_localized_string "system" "error_use_help")"
                exit 1
                ;;
        esac
    done
}

# Обработка аргументов командной строки
parse_args "$@"

# Выбор языка
select_language

# Если выбран интерактивный режим, показать меню
if [ "$INTERACTIVE" = true ]; then
    show_interactive_menu
fi

# Check system and install Homebrew if supported
install_homebrew() {
    if [[ "$(uname)" == "Darwin" ]] || [[ "$(uname -s)" == "Linux" && -f "/etc/debian_version" ]]; then
        if ! command_exists brew; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

# Install Git and useful utilities
install_if_confirmed "git" "git"
install_if_confirmed "curl" "curl"
install_if_confirmed "zsh" "zsh"
install_if_confirmed "ripgrep" "ripgrep"
install_if_confirmed "bat" "bat"
install_if_confirmed "fd" "fd"
install_if_confirmed "zoxide" "zoxide"

# Install Python 3.11
install_if_confirmed "python@3.11"
if command_exists python3; then
    if [ "$DRY_RUN" = false ]; then
        echo "Настройка Python pip с использованием виртуального окружения..."
        # Create virtual environment in user's home directory if it doesn't exist
        if [ ! -d "$HOME/.dotfiles-venv" ]; then
            python3 -m venv "$HOME/.dotfiles-venv"
            echo "Создано виртуальное окружение: $HOME/.dotfiles-venv"
        fi
        
        # Activate virtual environment to install packages
        source "$HOME/.dotfiles-venv/bin/activate"
        
        # Add to shell profile if not already there
        if ! grep -q "dotfiles-venv" "$HOME/.zshrc" 2>/dev/null; then
            echo '# Activate dotfiles virtual environment if it exists' >> "$HOME/.zshrc"
            echo '[ -f "$HOME/.dotfiles-venv/bin/activate" ] && source "$HOME/.dotfiles-venv/bin/activate"' >> "$HOME/.zshrc"
            echo "Добавлена активация виртуального окружения в .zshrc"
        fi
    fi
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
install_if_confirmed "podman"
install_if_confirmed "podman-compose"

# Install file management and search utilities
install_if_confirmed "dust"
install_if_confirmed "duf"

install_if_confirmed "vifmimg"
install_if_confirmed "gs"

# Media utilities
install_if_confirmed "mpv"
install_if_confirmed "GraphicsMagick"
install_if_confirmed "ueberzugpp"

# Other utilities for preview
install_if_confirmed "chafa"
install_if_confirmed "archive-tools"
install_if_confirmed "document-tools"
install_if_confirmed "media-tools"
install_if_confirmed "wkhtmltopdf"
install_if_confirmed "markdown-tools"
install_if_confirmed "transmission"

# MacPorts installation
install_if_confirmed "macports"

# Install Node Version Manager (NVM)
install_if_confirmed "nvm"

# Install text editors and terminal tools
install_if_confirmed "alacritty"
install_if_confirmed "vim"
install_if_confirmed "tmux"

# Install TPM
install_if_confirmed "tpm"

# Install fonts
install_if_confirmed "nerd-fonts"

# Install browsers and applications
install_if_confirmed "w3m"
install_if_confirmed "qutebrowser"
install_if_confirmed "insomnia"
install_if_confirmed "neofetch"
install_if_confirmed "tree"

# Install LM Studio
install_if_confirmed "lm-studio"
if command_exists lms; then
    mkdir -p ~/.cache/lm-studio/bin
    lms bootstrap
fi

# Function to install Open Interpreter
install_open_interpreter() {
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] Установка Open Interpreter"
    else
        echo "Установка Open Interpreter через виртуальное окружение..."
        # Ensure virtual environment is activated
        if [ -d "$HOME/.dotfiles-venv" ]; then
            source "$HOME/.dotfiles-venv/bin/activate"
            pip install open-interpreter
            echo "Open Interpreter установлен в виртуальное окружение"
            
            # Create convenience shell script in ~/bin
            mkdir -p "$HOME/bin"
            cat > "$HOME/bin/interpreter" << 'EOF'
#!/bin/bash
if [ -f "$HOME/.dotfiles-venv/bin/activate" ]; then
    source "$HOME/.dotfiles-venv/bin/activate"
    python -m interpreter "$@"
else
    echo "Error: Virtual environment not found. Please run the dotfiles installer first."
    exit 1
fi
EOF
            chmod +x "$HOME/bin/interpreter"
            
            # Add ~/bin to PATH if not already there
            if ! grep -q "export PATH=\"\$HOME/bin:\$PATH\"" "$HOME/.zshrc" 2>/dev/null; then
                echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.zshrc"
            fi
            
            echo "Создан скрипт запуска: $HOME/bin/interpreter"
        else
            echo "Ошибка: Виртуальное окружение не найдено. Установка пропущена."
        fi
    fi
}

# Установка open-interpreter
if [ "$INTERACTIVE" = true ]; then
    if is_tool_selected "open-interpreter"; then
        install_open_interpreter
        INSTALLATION_SUMMARY_INSTALLED="$INSTALLATION_SUMMARY_INSTALLED open-interpreter"
    else
        echo "$(get_localized_string "system" "skipping") open-interpreter"
        INSTALLATION_SUMMARY_SKIPPED="$INSTALLATION_SUMMARY_SKIPPED open-interpreter"
    fi
else
    read -p "$(get_localized_string "system" "install") open-interpreter? [y/N] " install_response
    if [[ "$install_response" =~ ^[Yy]$ ]]; then
        install_open_interpreter
        INSTALLATION_SUMMARY_INSTALLED="$INSTALLATION_SUMMARY_INSTALLED open-interpreter"
    else
        echo "$(get_localized_string "system" "skipping") open-interpreter"
        INSTALLATION_SUMMARY_SKIPPED="$INSTALLATION_SUMMARY_SKIPPED open-interpreter"
    fi
fi

# Install Oh My Zsh
install_if_confirmed "oh-my-zsh"

# Install powerlevel10k
install_if_confirmed "powerlevel10k"

# Install Vim plugin manager
install_if_confirmed "vim-plug"

# Install tiling window manager for Vim
install_if_confirmed "dwm-vim"

# Install C#
install_if_confirmed "dotnet-sdk"

# Install C# language server
install_if_confirmed "csharp-ls"

# Function to install configurations
install_configs() {
    local str_backup_start=$(get_localized_string "system" "backup_start")
    local str_backup_complete=$(get_localized_string "system" "backup_complete")
    local str_import_start=$(get_localized_string "system" "import_start")
    local str_import_complete=$(get_localized_string "system" "import_complete")

    echo "$str_backup_start"
    
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] Создание резервных копий и установка конфигураций"
        return 0
    fi
    
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

# Function to install Oh My Zsh
install_oh_my_zsh() {
    if ! [ -d "$HOME/.oh-my-zsh" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY-RUN] Установка Oh My Zsh"
        else
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        fi
    fi
}

# Function to install powerlevel10k
install_powerlevel10k() {
    if ! [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY-RUN] Установка Powerlevel10k"
        else
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        fi
    fi
}

# Function to install Vim plugin manager
install_vim_plug() {
    if ! [ -f "$HOME/.vim/autoload/plug.vim" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY-RUN] Установка Vim-plug"
        else
            curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        fi
    fi
}

# Function to install tiling window manager for Vim
install_dwm_vim() {
    if ! [ -f "$HOME/.vim/plugin/dwm.vim" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY-RUN] Установка DWM для Vim"
        else
            mkdir -p ~/.vim/plugin ~/.vim/doc
            wget -qO ~/.vim/plugin/dwm.vim \
                https://raw.github.com/spolu/dwm.vim/master/plugin/dwm.vim
            wget -qO ~/.vim/doc/dwm.txt \
                https://raw.github.com/spolu/dwm.vim/master/doc/dwm.txt
        fi
    fi
}

# Function to install macports
install_macports() {
    if ! command_exists port; then
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY-RUN] Установка MacPorts"
        else
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
        fi
    fi
}

# Function to install NVM
install_nvm() {
    if ! [ -d "$HOME/.nvm" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY-RUN] Установка NVM"
        else
            brew install nvm
            echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
            echo 'source $(brew --prefix nvm)/nvm.sh' >> ~/.zshrc
        fi
    fi
}

# Function to install LM Studio
install_lm_studio() {
    if ! command_exists lms; then
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY-RUN] Установка LM Studio"
        else
            wget https://releases.lmstudio.ai/mac/arm64/0.2.29/latest/LM-Studio-0.2.29-arm64.dmg
            mkdir -p ~/.cache/lm-studio/bin
            # Note: This requires manual installation of the DMG file
            echo "Please manually install LM Studio from the downloaded DMG file"
        fi
    fi
}

# Function to run post-installation settings
run_post_install() {
    local str_post_start=$(get_localized_string "system" "post_install_start")
    local str_post_complete=$(get_localized_string "system" "post_install_complete")
    
    echo "$str_post_start"
    
    # Install and configure special tools
    if [[ "$INSTALLATION_SUMMARY_INSTALLED" == *"oh-my-zsh"* ]]; then
        install_oh_my_zsh
    fi
    
    if [[ "$INSTALLATION_SUMMARY_INSTALLED" == *"powerlevel10k"* ]]; then
        install_powerlevel10k
    fi
    
    if [[ "$INSTALLATION_SUMMARY_INSTALLED" == *"vim-plug"* ]]; then
        install_vim_plug
    fi
    
    if [[ "$INSTALLATION_SUMMARY_INSTALLED" == *"dwm-vim"* ]]; then
        install_dwm_vim
    fi
    
    if [[ "$INSTALLATION_SUMMARY_INSTALLED" == *"macports"* ]]; then
        install_macports
    fi
    
    if [[ "$INSTALLATION_SUMMARY_INSTALLED" == *"nvm"* ]]; then
        install_nvm
    fi
    
    if [[ "$INSTALLATION_SUMMARY_INSTALLED" == *"lm-studio"* ]]; then
        install_lm_studio
    fi
    
    # Install and configure coc.nvim
    if [ -d ~/.vim/plug/coc.nvim ]; then
        cd ~/.vim/plug/coc.nvim
        npm ci
    fi
    
    # Install zsh-autosuggestions
    if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # Install open-interpreter if selected
    if [[ "$INSTALLATION_SUMMARY_INSTALLED" == *"open-interpreter"* ]]; then
        install_open_interpreter
    fi
    
    echo "$str_post_complete"
}

# Ask about installing configurations
if [ "$DRY_RUN" = true ]; then
    install_configs_response="y"
else
    read -p "$(get_localized_string "system" "install_configs")? [y/N] " install_configs_response
fi

if [[ "$install_configs_response" =~ ^[Yy]$ ]]; then
    install_configs
fi

# Ask about post-installation
if [ "$DRY_RUN" = true ]; then
    post_install_response="y"
else
    read -p "$(get_localized_string "system" "run_post_install")? [y/N] " post_install_response
fi

if [[ "$post_install_response" =~ ^[Yy]$ ]]; then
    run_post_install
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
    if [ -z "$INSTALLATION_SUMMARY_INSTALLED" ]; then
        echo "  - None"
    else
        for pkg in $INSTALLATION_SUMMARY_INSTALLED; do
            echo "  - $pkg: $(get_description "$pkg")"
        done
    fi
    
    echo
    echo "${str_skipped_header}:"
    if [ -z "$INSTALLATION_SUMMARY_SKIPPED" ]; then
        echo "  - None"
    else
        for pkg in $INSTALLATION_SUMMARY_SKIPPED; do
            echo "  - $pkg: $(get_description "$pkg")"
        done
    fi
    echo
}

print_summary
echo "$(get_localized_string "system" "complete")"
