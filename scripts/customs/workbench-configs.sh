#!/usr/bin/env bash
#
# workbench-configs.sh — раскладывает открытые конфиги Digitable Workbench.
#
# Темы Workbench НЕ хранятся в этом репозитории: LICENSE-PERSONAL.md (п. 2) запрещает
# публиковать их в открытом репо. Скрипт тянет их по публичному URL во время установки —
# токен и оплата не нужны.
#
# Совместимость: bash 3.2 (macOS) — без mapfile, ассоциативных массивов и ${var^}.

set -euo pipefail

BASE_URL="${WORKBENCH_BASE_URL:-https://courses.digitable.life/workbench/configs}"
PALETTE="carbon"
DEST="$HOME"
DRY_RUN=false
DO_LIST=false
TARGETS="alacritty,tmux,vim,neovim,zsh,bat,delta,eza,fzf,starship,lazygit,lf,btop"

# Каталог назначения для цели. Индекс Workbench каталога НЕ сообщает, а пути внутри
# JSON относительные и у разных целей совпадают (alacritty и starship — оба
# digitable-focus-carbon.toml), поэтому карту держим здесь.
target_dir() {
    case "$1" in
        vim)    echo ".vim" ;;
        neovim) echo ".config/nvim" ;;
        bat)    echo ".config/bat/themes" ;;
        btop)   echo ".config/btop/themes" ;;
        *)      echo ".config/$1" ;;
    esac
}

usage() {
    cat <<'USAGE'
workbench-configs.sh — разложить открытые конфиги Digitable Workbench.

Использование:
  workbench-configs.sh [флаги]

Флаги:
  --palette carbon|paper|signal   палитра (по умолчанию: carbon)
  --targets a,b,c                 список целей через запятую
  --dest DIR                      корень назначения (по умолчанию: $HOME)
  --list                          показать доступные цели и выйти
  --dry-run                       только показать план, ничего не писать
  --help                          эта справка

Переменные окружения:
  WORKBENCH_BASE_URL              база URL (по умолчанию публичный сайт курсов)

Примеры:
  workbench-configs.sh --list
  workbench-configs.sh --palette paper --targets alacritty,tmux --dry-run
USAGE
}

die() { echo "Ошибка: $*" >&2; exit 1; }

need() {
    command -v "$1" >/dev/null 2>&1 || die "нужна утилита '$1', но её нет в PATH. Установите: $2"
}

fetch() {
    curl -fsSL --max-time 30 "$1" || return 1
}

while [ $# -gt 0 ]; do
    case "$1" in
        --palette) [ $# -ge 2 ] || die "--palette требует значение"; PALETTE="$2"; shift 2 ;;
        --targets) [ $# -ge 2 ] || die "--targets требует значение"; TARGETS="$2"; shift 2 ;;
        --dest)    [ $# -ge 2 ] || die "--dest требует значение"; DEST="$2"; shift 2 ;;
        --list)    DO_LIST=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        --help|-h) usage; exit 0 ;;
        *) echo "Неизвестный флаг: $1" >&2; usage >&2; exit 1 ;;
    esac
done

case "$PALETTE" in
    carbon|paper|signal) ;;
    *) die "палитра '$PALETTE' не поддерживается, допустимы: carbon, paper, signal" ;;
esac

need curl "brew install curl / apt-get install -y curl"
need jq   "brew install jq / apt-get install -y jq"

WORK_DIR=$(mktemp -d 2>/dev/null) || die "не удалось создать временный каталог"
trap 'rm -rf "$WORK_DIR"' EXIT

if [ "$DO_LIST" = true ]; then
    fetch "$BASE_URL/index.json" > "$WORK_DIR/index.json" \
        || die "не удалось получить $BASE_URL/index.json"
    jq -r '.note // empty' "$WORK_DIR/index.json"
    echo "Доступные цели ($(jq -r '.targets | length' "$WORK_DIR/index.json")):"
    jq -r '.targets[] | "  \(.id)  (файлов: \(.files), байт: \(.bytes))"' "$WORK_DIR/index.json"
    exit 0
fi

# Один файл: сравнить, при нужде сделать бэкап, положить новый.
install_file() {
    local target="$1" relpath="$2" src="$3"
    local dest_path dir stamp
    dest_path="$DEST/$(target_dir "$target")/$relpath"
    dir=$(dirname "$dest_path")

    if [ -f "$dest_path" ] && cmp -s "$src" "$dest_path"; then
        echo "  = $dest_path (совпадает, не трогаю)"
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        if [ -f "$dest_path" ]; then
            echo "  [DRY-RUN] обновить $dest_path (старый уйдёт в *.digitable-backup-<UTC>)"
        else
            echo "  [DRY-RUN] создать $dest_path"
        fi
        return 0
    fi

    mkdir -p "$dir"
    if [ -f "$dest_path" ]; then
        stamp=$(date -u +%Y%m%dT%H%M%SZ)
        cp -p "$dest_path" "$dest_path.digitable-backup-$stamp"
        echo "  ~ бэкап: $dest_path.digitable-backup-$stamp"
    fi
    cp "$src" "$dest_path"
    echo "  + $dest_path"
}

FILTER='[ (.shared[]?), (.palettes[]? | select(.id == $p) | .files[]?) ]'
failed=0
handled=0

for target in $(echo "$TARGETS" | tr ',' ' '); do
    [ -n "$target" ] || continue
    echo "== $target ($PALETTE)"

    if ! fetch "$BASE_URL/$target.json" > "$WORK_DIR/$target.json"; then
        echo "  ! не удалось получить $BASE_URL/$target.json — пропускаю" >&2
        failed=$((failed + 1))
        continue
    fi

    if [ "$(jq -r --arg p "$PALETTE" '[.palettes[]?.id] | index($p) // "null"' "$WORK_DIR/$target.json")" = "null" ]; then
        echo "  ! у цели '$target' нет палитры '$PALETTE' — пропускаю" >&2
        failed=$((failed + 1))
        continue
    fi

    count=$(jq -r --arg p "$PALETTE" "$FILTER | length" "$WORK_DIR/$target.json")
    [ "$count" -gt 0 ] 2>/dev/null || { echo "  (файлов нет)"; continue; }

    i=0
    while [ "$i" -lt "$count" ]; do
        relpath=$(jq -r --arg p "$PALETTE" --argjson i "$i" "$FILTER | .[\$i].path" "$WORK_DIR/$target.json")
        # -j, а не -r: сохраняет текст побайтово, без лишнего перевода строки в конце.
        jq -j --arg p "$PALETTE" --argjson i "$i" "$FILTER | .[\$i].text" \
            "$WORK_DIR/$target.json" > "$WORK_DIR/blob"
        install_file "$target" "$relpath" "$WORK_DIR/blob"
        handled=$((handled + 1))
        i=$((i + 1))
    done
done

echo
echo "Готово: файлов обработано $handled, целей пропущено $failed."
if [ "$DRY_RUN" = false ] && [ "$handled" -gt 0 ]; then
    echo "Это файлы тем — их надо подключить в своих конфигах (colorscheme / source / theme)."
fi
[ "$failed" -eq 0 ] || exit 1
