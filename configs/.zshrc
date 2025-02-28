# Environment variables
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
ZSH_WEB_SEARCH_ENGINES=(google "https://www.google.com/search?q=")

eval "$(zoxide init zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export USER_HOME_DIR="/Users/developer"
export ZSH="$USER_HOME_DIR/.oh-my-zsh"
export PATH="$PATH:/root/.cargo/bin"
export VIM_SERVERNAME="God"

export NODE_PATH=$NODE_PATH:`npm root -g`

# Powerlevel10k Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  web-search
  copyfile
)

source $ZSH/oh-my-zsh.sh

# To provide navigate word-by-word an ability using Shift + Arrow keys on Mac OS
bindkey -e

bindkey "^[[1;2C" forward-word
bindkey "^[[1;2D" backward-word

# Custom aliases
alias ls='eza -a --icons --color=always --group-directories-first -la'
alias cat='bat --theme=Dracula'
alias du='dust'
alias df='duf'
alias find='fd'
alias grep='rg'
alias ps='procs'
alias ping='gping'
alias f='floaterm'
alias docker='podman'
alias docker-compose='podman-compose'
alias dev='sh ~/tmux.sh'
alias projects='cd ~/projects'
alias cd='z'

alias downloads='cd ~/downloads'
alias space='du / -h --max-depth=1 | sort -hr'

alias python3='python3.11'

# NVM Environment Variables
export NVM_DIR=~/.nvm

# Load Powerlevel10k
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# McFly file history support
eval "$(mcfly init zsh)"

# Import custom Powerlevel10k configuration if it exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source $(brew --prefix nvm)/nvm.sh

# Additional settings and aliases
alias projects='cd $HOME/projects'
alias downloads='cd $HOME/downloads'
alias git_sync_master='BRANCH=$(git branch --show-current); git checkout master && git pull && git checkout $BRANCH'
alias git_squash='git reset $(git merge-base master $(git branch --show-current))'
alias git_show_conflicts='git merge-tree $(git merge-base HEAD origin/master) origin/master HEAD'
alias gcm='git checkout master'
alias grb='BRANCH=$(git branch --show-current); git checkout master && git branch -D $BRANCH && git fetch --all && git checkout $BRANCH && git pull'
alias node_sync='nvm use $(cat .nvmrc)'
alias convert_video_to_ps5_supported_format=" ffmpeg -i "$file" -vf "scale='if(gt(a,3840/2160),min(iw,3840),iw)':'if(gt(a,3840/2160),min(ih,2160),ih)'" -pix_fmt yuv420p -c:v libx264 -preset slow -profile:v high -level 5.2 -crf 20 -c:a aac -b:a 192k -movflags +faststart "converted/${file%.*}_ps5.mp4"; done"

function devbsd () {
	qemu-system-x86_64 -drive file=$1,format=raw,if=virtio -hda $USER_HOME_DIR/Downloads/NetBSD-10.0-amd64.iso -m $2
}

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/opt/homebrew/opt/texinfo/bin:$PATH"
PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
PATH="/$USER_HOME_DIR/.local/share/bob/nvim-bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export PATH="/opt/homebrew/opt/conan@1/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
export PATH="$USER_HOME_DIR/dotfiles/scripts/lf:$PATH"
export PATH="$USER_HOME_DIR/dotfiles/scripts/customs:$PATH"

# Added by LM Studio CLI Tool (lms)
export PATH="$PATH:$USER_HOME_DIR/.cache/lm-studio/bin"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.asdf/installs/dotnet-core/6.0.418:$PATH"
export PATH="$HOME/.asdf/installs/dotnet-core/9.0.102:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
