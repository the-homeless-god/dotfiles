#!/bin/bash
#
# Сторож тишины Vim: ИИ-помощник не включается сам.
#
# Плагин vim-ollama при загрузке делает три вещи, и все три мешают работать,
# пока модель не запущена: вешает на VimEnter мастер настройки (каждый старт
# упирается в вопрос «Should I help you setting up everything? (Y/n)»),
# забирает <Tab> в режиме вставки у coc и цепляет CursorMovedI, то есть на
# каждое нажатие клавиши планирует запрос к http://localhost:1234. Поэтому в
# .vimrc он помечен `{ 'on': [] }` — зарегистрирован, но не загружен, — а
# включается вручную: \i, :OllamaOn или VIM_OLLAMA=1.
#
# Проверка гоняет НАСТОЯЩИЙ vim с настоящим configs/.vimrc в подставном HOME.
# Настоящего vim-plug и настоящего vim-ollama в репозитории нет и быть не
# должно, поэтому оба подставные:
#   * подставной vim-plug понимает ровно то, что решает вопрос, — `on`/`for`
#     означают «не грузить», всё остальное грузится сразу, как у настоящего;
#   * подставной vim-ollama делает ровно то, чем настоящий мешает жить:
#     объявляется загруженным, заводит ~/vim-ollama.log, забирает <Tab> и
#     заводит группу автокоманд ollama. В сеть он не ходит — и не должен:
#     единственный код, который знает адрес модели, это он сам, и если он не
#     выполнился, обращаться к localhost:1234 некому.
#
# Три прогона, и все три обязательны:
#   1. обычный старт        — плагина быть не должно;
#   2. VIM_OLLAMA=1         — плагин обязан включиться;
#   3. :OllamaOn на ходу    — плагин обязан включиться.
# Без прогонов 2 и 3 проверка сводилась бы к «плагин не грузится никогда» —
# это прошло бы и на выключателе-бутафории.
#
# В первом прогоне заодно проверяется, что дверь на месте: есть команда
# :OllamaOn и \i ведёт на неё. Иначе «плагин не грузится» означало бы просто
# «плагином нельзя пользоваться».
#
# Чужие сообщения (нет схемы digitable, нет команды CocInstall) в подставном
# HOME неизбежны: плагины туда не ставятся. Поэтому проверяется не «vim не
# сказал ничего», а «vim не сказал ничего про ollama» — плюс отсутствие лога,
# флага загрузки, группы автокоманд и захваченного <Tab>.
#
# Ключи:
#   (без ключей)  прогнать проверку
#   --selftest    отрицательный контроль: вернуть в .vimrc жадную загрузку
#                 плагина и убедиться, что проверка ПАДАЕТ

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
VIMRC="${VIMRC:-$REPO_DIR/configs/.vimrc}"
VIM_BIN="${VIM_BIN:-vim}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; NC='\033[0m'

fail=0

note_ok()   { echo -e "${GREEN}✓${NC} $1"; }
note_fail() { echo -e "${RED}✗ $1${NC}"; fail=1; }

# --- отрицательный контроль -------------------------------------------------
if [ "${1:-}" = "--selftest" ]; then
    echo -e "${YELLOW}Отрицательный контроль: возвращаем в .vimrc жадную загрузку плагина${NC}"
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    sed "s|^Plug 'gergap/vim-ollama'.*|Plug 'gergap/vim-ollama'|" "$VIMRC" > "$tmp/.vimrc"
    if grep -q "^Plug 'gergap/vim-ollama'$" "$tmp/.vimrc"; then
        :
    else
        echo -e "${RED}✗ Не нашёл строку Plug 'gergap/vim-ollama' — контроль ничего не проверил${NC}"
        exit 1
    fi
    if VIMRC="$tmp/.vimrc" bash "$SCRIPT_DIR/check-vim-quiet.sh" > "$tmp/out" 2>&1; then
        echo -e "${RED}✗ Проверка прошла на конфиге, который грузит плагин при старте — она ничего не сторожит${NC}"
        cat "$tmp/out"
        exit 1
    fi
    echo -e "${GREEN}✓ Проверка упала, как и должна${NC}"
    exit 0
fi

# --- есть ли чем мерить -----------------------------------------------------
if ! command -v "$VIM_BIN" > /dev/null 2>&1; then
    echo -e "${YELLOW}Тишина Vim: не мерил — на машине нет vim.${NC}"
    echo "Статически: строка загрузки плагина в $VIMRC —"
    grep -n "gergap/vim-ollama" "$VIMRC" || true
    if grep -qE "^Plug 'gergap/vim-ollama', *\{ *'on': *\[\] *\}" "$VIMRC"; then
        echo -e "${GREEN}✓ помечена { 'on': [] }, то есть при старте не грузится${NC}"
        exit 0
    fi
    echo -e "${RED}✗ не помечена { 'on': [] } — плагин грузится при каждом старте${NC}"
    exit 1
fi

# --- песочница --------------------------------------------------------------
SANDBOX="$(mktemp -d)"
trap 'rm -rf "$SANDBOX"' EXIT
mkdir -p "$SANDBOX/.vim/autoload" "$SANDBOX/.vim/colors" \
    "$SANDBOX/.vim/plugged/vim-ollama/plugin" "$SANDBOX/.vim/plugged/vim-which-key/autoload" \
    "$SANDBOX/.vim/plugged/coc.nvim/plugin"
cp "$VIMRC" "$SANDBOX/.vimrc"
cp "$REPO_DIR/configs/.vim/colors/digitable.vim" "$SANDBOX/.vim/colors/" 2>/dev/null || true

cat > "$SANDBOX/.vim/autoload/plug.vim" <<'EOF'
" Подставной vim-plug. Настоящий сюда не кладём: он не наш и в репозитории его
" нет. Здесь воспроизведено ровно то, от чего зависит проверка: плагин с
" опцией 'on' или 'for' при старте НЕ грузится, любой другой грузится сразу,
" а plug#load() грузит по требованию.
let g:plugs = {}
let s:home = ''

function! plug#begin(...) abort
    let g:plugs = {}
    let s:home = a:0 ? a:1 : expand('~/.vim/plugged')
    command! -nargs=+ -bar Plug call s:plug(<args>)
endfunction

function! s:dir(short) abort
    return s:home . '/' . a:short
endfunction

function! s:source(short) abort
    let l:dir = s:dir(a:short)
    if !isdirectory(l:dir)
        return 0
    endif
    execute 'set runtimepath^=' . fnameescape(l:dir)
    for l:file in glob(l:dir . '/plugin/**/*.vim', 0, 1)
        execute 'source' fnameescape(l:file)
    endfor
    return 1
endfunction

function! s:plug(name, ...) abort
    let l:short = substitute(a:name, '^.*/', '', '')
    let l:opts = a:0 ? a:1 : {}
    let g:plugs[l:short] = l:opts
    if has_key(l:opts, 'on') || has_key(l:opts, 'for')
        return
    endif
    call s:source(l:short)
endfunction

function! plug#end() abort
    filetype plugin indent on
    syntax enable
endfunction

function! plug#load(...) abort
    let l:ok = 0
    for l:name in a:000
        let l:short = substitute(l:name, '^.*/', '', '')
        let l:ok = s:source(l:short) || l:ok
    endfor
    return l:ok
endfunction
EOF

cat > "$SANDBOX/.vim/plugged/vim-which-key/autoload/which_key.vim" <<'EOF'
" Заглушка which-key. Она нужна не ради which-key: .vimrc вызывает
" which_key#register() прямо при чтении конфига, и без этой функции vim
" останавливается на «Press ENTER» ещё до VimEnter — мерить было бы нечего.
function! which_key#register(...) abort
endfunction
function! which_key#start(...) abort
endfunction
EOF

cat > "$SANDBOX/.vim/plugged/coc.nvim/plugin/coc.vim" <<'EOF'
" Заглушка coc. Тоже не ради coc: .vimrc на VimEnter зовёт :CocInstall, и без
" этой команды каждый прогон получает лишнее сообщение об ошибке. Два
" сообщения при cmdheight=2 упираются в «Press ENTER», а стоящий на этом
" запросе vim до замеров не доходит.
command! -nargs=* -bar CocInstall
function! coc#config(...) abort
endfunction
EOF

cat > "$SANDBOX/.vim/plugged/vim-ollama/plugin/ollama.vim" <<'EOF'
" Подставной vim-ollama: делает ровно то, чем настоящий мешает жить.
" Если этот файл выполнился, значит на его месте настоящий уже спросил бы про
" мастер настройки и пошёл бы в http://localhost:1234.
if exists('g:loaded_ollama')
    finish
endif
let g:loaded_ollama = 1

" Настоящий плагин всё делает не при загрузке, а на VimEnter: заводит лог
" (его создаёт autoload/ollama/logger.vim при первом же обращении), забирает
" <Tab> у того, кто занял его раньше, и вешает CursorMovedI. Порядок важен:
" если отобрать <Tab> при загрузке, его тут же переназначит сам .vimrc, и
" проверка увидит не то, что видит человек.
function! s:Init() abort
    let g:ollama_init_ran = 1
    call writefile(['плагин загрузился'], expand('~/vim-ollama.log'))
    imap <silent> <Tab> <Plug>(ollama-tab-completion)
    augroup ollama_schedule
        autocmd!
        autocmd CursorMovedI * let g:ollama_asked_model = 1
    augroup END
endfunction

augroup ollama
    autocmd!
    autocmd VimEnter * call s:Init()
augroup END
command! OllamaChat echo 'chat'
EOF

cat > "$SANDBOX/measure.vim" <<'EOF'
" Замеры снимаются на VimEnter — позже автокоманд самого .vimrc, поэтому
" видно итоговое состояние, а не промежуточное.
function! s:Measure(...) abort
    call writefile([
                \ 'loaded=' . get(g:, 'loaded_ollama', 0),
                \ 'init=' . get(g:, 'ollama_init_ran', 0),
                \ 'augroup=' . exists('#ollama'),
                \ 'tab=' . maparg('<Tab>', 'i'),
                \ 'log=' . filereadable(expand('~/vim-ollama.log')),
                \ 'switch_cmd=' . exists(':OllamaOn'),
                \ 'switch_map=' . maparg('\i', 'n'),
                \ 'messages=' . substitute(execute('silent messages'), '\n', ' | ', 'g'),
                \ ], $QUIET_DUMP)
    qa!
endfunction
if $QUIET_TURN_ON !=# ''
    autocmd VimEnter * execute $QUIET_TURN_ON
endif
autocmd VimEnter * call s:Measure()
EOF

# Один прогон vim. $1 — файл замеров, $2 — команда включения (или пусто),
# остальное — переменные окружения для env.
run_vim() {
    local dump="$1"; shift
    local turn_on="$1"; shift
    rm -f "$SANDBOX/vim-ollama.log" "$dump"
    env -i HOME="$SANDBOX" PATH="$PATH" TERM=dumb LANG="${LANG:-C.UTF-8}" \
        QUIET_DUMP="$dump" QUIET_TURN_ON="$turn_on" "$@" \
        timeout 30 "$VIM_BIN" -N -u "$SANDBOX/.vimrc" -c 'set cmdheight=20' \
        -S "$SANDBOX/measure.vim" \
        < /dev/null > "$SANDBOX/vim.out" 2>&1
    if [ ! -f "$dump" ]; then
        note_fail "vim не дошёл до VimEnter — замеров нет"
        sed -e 's/\x1b\[[0-9;?]*[a-zA-Z]//g' "$SANDBOX/vim.out" | tr -s ' \n' ' \n' | tail -5
        return 1
    fi
    return 0
}

field() { sed -n "s/^$2=//p" "$1"; }

# --- 1. обычный старт: плагина быть не должно -------------------------------
echo -e "${YELLOW}1. Обычный старт vim с пустым буфером${NC}"
if run_vim "$SANDBOX/plain.txt" ""; then
    if [ "$(field "$SANDBOX/plain.txt" loaded)" = "0" ]; then
        note_ok "плагин не загружен (g:loaded_ollama не задана)"
    else
        note_fail "плагин загрузился сам — он и спросит про настройку, и пойдёт в сеть"
    fi
    if [ "$(field "$SANDBOX/plain.txt" augroup)" = "0" ]; then
        note_ok "группы автокоманд ollama нет — CursorMovedI не цепляется"
    else
        note_fail "группа автокоманд ollama на месте: запрос к модели на каждое нажатие"
    fi
    if [ "$(field "$SANDBOX/plain.txt" log)" = "0" ]; then
        note_ok "~/vim-ollama.log не появился"
    else
        note_fail "~/vim-ollama.log появился при обычном старте"
    fi
    tab="$(field "$SANDBOX/plain.txt" tab)"
    case "$tab" in
        *ollama*) note_fail "<Tab> в режиме вставки забрал ollama: $tab" ;;
        *)        note_ok "<Tab> в режиме вставки остался хозяину конфига" ;;
    esac
    if [ "$(field "$SANDBOX/plain.txt" switch_cmd)" = "2" ]; then
        note_ok "команда :OllamaOn на месте — включить есть чем"
    else
        note_fail "команды :OllamaOn нет — включать нечем, кроме правки конфига"
    fi
    case "$(field "$SANDBOX/plain.txt" switch_map)" in
        *OllamaOn*) note_ok "\\i в обычном режиме ведёт на :OllamaOn" ;;
        *)          note_fail "\\i не ведёт на :OllamaOn: $(field "$SANDBOX/plain.txt" switch_map)" ;;
    esac
    msgs="$(field "$SANDBOX/plain.txt" messages)"
    if echo "$msgs" | grep -qi 'ollama'; then
        note_fail "vim сказал про ollama при старте: $msgs"
    else
        note_ok "в :messages про ollama ни слова"
    fi
fi

# --- 2. VIM_OLLAMA=1: выключатель обязан работать ---------------------------
echo -e "${YELLOW}2. Старт с VIM_OLLAMA=1${NC}"
if run_vim "$SANDBOX/env.txt" "" VIM_OLLAMA=1; then
    if [ "$(field "$SANDBOX/env.txt" loaded)" = "1" ] && [ "$(field "$SANDBOX/env.txt" init)" = "1" ]; then
        note_ok "плагин включился и прошёл свою инициализацию"
    else
        note_fail "VIM_OLLAMA=1 не включил плагин — выключатель бутафорский"
    fi
fi

# --- 3. :OllamaOn на ходу ---------------------------------------------------
echo -e "${YELLOW}3. Команда :OllamaOn в уже запущенном vim${NC}"
if run_vim "$SANDBOX/cmd.txt" "OllamaOn"; then
    if [ "$(field "$SANDBOX/cmd.txt" loaded)" = "1" ] && [ "$(field "$SANDBOX/cmd.txt" init)" = "1" ]; then
        note_ok "плагин включился и прошёл свою инициализацию"
    else
        note_fail ":OllamaOn не включил плагин — включать нечем"
    fi
fi

echo
if [ "$fail" -eq 0 ]; then
    echo -e "${GREEN}Тишина Vim: ИИ-помощник молчит до просьбы и включается по просьбе.${NC}"
    exit 0
fi
echo -e "${RED}Тишина Vim: проверка не пройдена.${NC}"
exit 1
