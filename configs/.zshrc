# Environment variables
export ZSH="~/.oh-my-zsh"
export VIM_SERVERNAME="God"

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

# Custom aliases
alias ls='exa -a --icons --color=always --group-directories-first -la'
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
alias space='du / -h --max-depth=1 | sort -hr'

# NVM Environment Variables
export NVM_DIR=~/.nvm

# Load Powerlevel10k
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# McFly file history support
eval "$(mcfly init zsh)"

# Import custom Powerlevel10k configuration if it exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Additional settings and aliases
alias projects='cd $HOME/projects'
alias downloads='cd $HOME/downloads'
alias git_sync_master='BRANCH=$(git branch --show-current); git checkout master && git pull && git checkout $BRANCH'
alias git_squash="git reset $(git merge-base master $(git branch --show-current))"
alias node_sync="nvm use $(cat .nvmrc)"
