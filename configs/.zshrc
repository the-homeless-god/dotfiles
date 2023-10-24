ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
ZSH_WEB_SEARCH_ENGINES=(google "https://www.google.com/search?q=")

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="~/.oh-my-zsh"
export VIM_SERVERNAME="God"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  web-search
  copyfile
)

source $ZSH/oh-my-zsh.sh

# always use ls with one column output
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

# for easy navigation
alias projects='cd ~/projects'
alias downloads='cd ~/downloads'

alias git_sync_master='BRANCH=$(git branch --show-current); git checkout master && git pull && git checkout $BRANCH'
alias git_squash="git reset $(git merge-base master $(git branch --show-current))"
alias node_sync="nvm use $(cat .nvmrc)"

eval "$(mcfly init zsh)"

export NVM_DIR=~/.nvm

source $(brew --prefix nvm)/nvm.sh

source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ENV: OS X
# export PATH="/opt/homebrew/opt/texinfo/bin:$PATH"
# PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
