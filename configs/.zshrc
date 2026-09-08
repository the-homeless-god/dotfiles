# Environment variables

# ── Цвета в палитре Digitable ──────────────────────────────────────────────
# Значения — из theme/digitable.flang, те же, что у схемы Vim; сверяет их
# scripts/check-theme.sh.

# zsh понимает 24-битный цвет как fg=#rrggbb, но только если терминал его
# объявил. На 256-цветном терминале hex без этого модуля отрисуется мимо;
# zsh/nearcolor как раз для этого и есть — он подменяет hex ближайшим цветом
# 256-цветной палитры (zshmodules(1), The zsh/nearcolor Module).
if [[ "$COLORTERM" != (truecolor|24bit) ]]; then
  zmodload zsh/nearcolor 2>/dev/null
fi

# Подсказка ввода (zsh-autosuggestions) — роль «комментарий»: то же, чем
# схема Vim красит Comment. Приглушено намеренно, но 5.30:1 на фоне #05080d
# выше порога 4.5. Было fg=60 — цвет 256-цветной палитры не из нашей.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#718695'

# Тема bat — переменной, а не только алиасом ниже: так её берут и вызовы
# bat из скриптов и предпросмотр lf. Сам файл темы лежит в
# ~/.config/bat/themes, но виден bat только после `bat cache --build`,
# который делает установщик.
export BAT_THEME=digitable

# Цвета списка файлов берутся из того же файла, что читает lf:
# ~/.config/lf/colors. Формат у него ровно LS_COLORS (lf doc.md, раздел
# COLORS), только пары записаны по строкам, а не через двоеточие. Поэтому
# список не пишется здесь второй раз, а собирается из него — двум копиям
# разъехаться негде. Читают LS_COLORS eza (алиас ls ниже), GNU ls и сам lf.
if [[ -r ~/.config/lf/colors ]]; then
  export LS_COLORS="$(awk '{sub(/#.*/, "")} NF >= 2 {printf "%s=%s:", $1, $2}' ~/.config/lf/colors)"
fi

# Столбцы eza (права, размер, владелец, дата, флаги git) LS_COLORS не
# покрывает — у eza для них свой EZA_COLORS с собственными двухбуквенными
# ключами (eza_colors(5)). Роли те же: чтение — сведение, запись — «это
# можно изменить» (Changed), исполнение — Executable, число — Number,
# дата и разделители — Comment, флаги git — как GitGutter в схеме Vim.
export EZA_COLORS="\
ur=38;2;155;170;184:uw=38;2;255;194;71:ux=38;2;124;255;107:ue=38;2;124;255;107:\
gr=38;2;155;170;184:gw=38;2;255;194;71:gx=38;2;124;255;107:\
tr=38;2;155;170;184:tw=38;2;255;194;71:tx=38;2;124;255;107:\
su=38;2;255;138;42:sf=38;2;255;138;42:oc=38;2;113;134;149:xa=38;2;182;92;255:\
sn=38;2;255;138;42:sb=38;2;113;134;149:df=38;2;182;92;255:ds=38;2;182;92;255:\
uu=38;2;0;229;229:uR=1;38;2;255;138;42:un=38;2;155;170;184:\
gu=38;2;0;229;229:gR=1;38;2;255;138;42:gn=38;2;155;170;184:\
lc=38;2;113;134;149:lm=38;2;255;138;42:in=38;2;113;134;149:bl=38;2;113;134;149:\
da=38;2;113;134;149:hd=1;38;2;0;229;229:xx=38;2;113;134;149:\
lp=38;2;0;216;255:bO=38;2;255;91;91:cc=38;2;255;91;91:\
sp=38;2;182;92;255:mp=38;2;0;216;255:\
im=38;2;182;92;255:vi=38;2;182;92;255:mu=38;2;182;92;255:\
ga=38;2;124;255;107:gm=38;2;255;194;71:gd=38;2;255;91;91:gv=38;2;60;169;255:\
gt=38;2;182;92;255:gi=38;2;113;134;149:gc=38;2;255;138;42:\
Gm=38;2;0;229;229:Go=38;2;60;169;255:Gc=38;2;124;255;107:Gd=38;2;255;194;71"

ZSH_WEB_SEARCH_ENGINES=(google "https://www.google.com/search?q=")

eval "$(zoxide init zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export USER_HOME_DIR="/Users/developer"
export ZSH="$USER_HOME_DIR/.oh-my-zsh"
export PATH="$PATH:/root/.cargo/bin"
export VIM_SERVERNAME="God"

export NODE_PATH="$NODE_PATH:`npm root -g`"


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
alias cat='bat -pp --theme=digitable'
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
export PATH="$USER_HOME_DIR/dotfiles/scripts/lf:$PATH"
export PATH="$USER_HOME_DIR/dotfiles/scripts/customs:$PATH"

# Added by LM Studio CLI Tool (lms)
# Только каталог с CLI `lms`: ничего не запускает и сервер модели не поднимает.
# ИИ в Vim включается отдельно и руками — \i, :OllamaOn или VIM_OLLAMA=1 vim.
export PATH="$PATH:$USER_HOME_DIR/.cache/lm-studio/bin"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="/usr/local/opt/bison/bin:$PATH"

# ── Заряд батареи в приглашении p10k ───────────────────────────────────────
# Внизу файла, а не наверху с остальными цветами, — намеренно: приглашение
# подключается строкой `source ~/.p10k.zsh` выше и перекрывает всё, что задано
# до неё. p10k перечитывает POWERLEVEL9K_* на каждом приглашении
# (internal/p10k.zsh, _p9k_must_init), поэтому заданное после подключения
# действует.
#
# Своего цвета у батареи в p10k нет. По умолчанию (internal/p10k.zsh,
# _p9k_battery_states) она красится ИМЕНАМИ ANSI-цветов: LOW — red, CHARGING —
# yellow, CHARGED — green, а «на батарее, заряда хватает» — цветом 7, то есть
# просто белым. Имя достаёт из палитры терминала не тема, а сам терминал: под
# iTerm или чужим профилем это чужие красный и жёлтый. Здесь цвета названы
# шестнадцатеричными числами — p10k их понимает (_p9k_translate_color) — и от
# палитры терминала больше не зависят.
#
# Пороги те же, что у блока батареи в нижней панели tmux. Источник — функция
# «Пороги заряда» в theme/digitable.flang, там же посчитан контраст каждой
# пары. Что три места не разъедутся, сторожит scripts/check-theme.sh.
#
# Массив читается по проценту: p10k берёт из него элемент с номером
# «процент * длина / 100 + 1». При ста элементах номер равен проценту, поэтому
# порог оказывается ровно там, где написан. Короткий массив (скажем, из
# четырёх) резал бы шкалу на четверти — 25/50/75, а это уже другие числа.
#
# Цвет состояния бьёт цвет уровня: _p9k_param ищет
# POWERLEVEL9K_BATTERY_<состояние>_FOREGROUND раньше, чем смотрит на то, что
# сегмент подставил из массива. Мастер p10k такие цвета как раз и пишет в
# ~/.p10k.zsh: 160 — красный, 70 — зелёный, 178 — жёлтый, числа 256-цветной
# палитры, ни одного нашего. Файла этого репозиторий пока не везёт, поэтому
# цвета состояний снимаются здесь — иначе массив ниже не заработает.
unset POWERLEVEL9K_BATTERY_FOREGROUND \
      POWERLEVEL9K_BATTERY_LOW_FOREGROUND \
      POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND \
      POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND \
      POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND

typeset -ga POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND=()
() {
  local -i p
  for (( p = 0; p < 100; p++ )); do
    if   (( p < 20 )); then POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND+='#ff5b5b'
    elif (( p < 30 )); then POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND+='#ff8a2a'
    elif (( p < 60 )); then POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND+='#ffc247'
    else                    POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND+='#7cff6b'
    fi
  done
}

# Ниже этого числа p10k считает состояние LOW. По умолчанию у него 10 — то
# есть красный зажигается позже, чем система успевает предупредить.
typeset -gi POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20

# Питание от сети: цвет говорит не про уровень, а про «не твоя забота».
# Массив из одного элемента — номер всегда 1, процент на цвет не влияет.
typeset -ga POWERLEVEL9K_BATTERY_CHARGING_LEVEL_FOREGROUND=('#00e5e5')
typeset -ga POWERLEVEL9K_BATTERY_CHARGED_LEVEL_FOREGROUND=('#7cff6b')
