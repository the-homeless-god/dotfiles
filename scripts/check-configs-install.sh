#!/bin/bash
#
# Проверяет, что install_configs действительно раскладывает по домашнему
# каталогу КАЖДЫЙ файл из configs/ — а не только те, что кто-то не забыл
# вписать в список копирования руками.
#
# Зачем отдельная проверка. Список копирования в install_configs набран
# построчно, файл за файлом. Любой новый конфиг в configs/ по умолчанию
# НЕ ставится: про него просто забывают. Снаружи это выглядит как «схема
# лежит в репозитории, а на чистой машине её нет».
#
# Как проверяется. Из install-tools.sh берётся сама функция install_configs
# (не копия её логики — иначе проверка проверяла бы себя), запускается с
# подставным HOME, и для каждого файла из configs/ ищется файл с тем же
# содержимым где-нибудь под этим HOME. Сверка по содержимому, а не по пути:
# часть файлов кладётся не туда, где лежала (.config/tmux/.tmux.conf -> ~/.tmux.conf).
#
# Ключи:
#   (без ключей)  прогнать проверку
#   --selftest    отрицательный контроль: выкинуть из списка копирования одну
#                 строку и убедиться, что проверка ПАДАЕТ. Проверка, которая
#                 не умеет падать, ничего не проверяет.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CONFIGS_SRC="$REPO_DIR/configs"
INSTALLER="$SCRIPT_DIR/install-tools.sh"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; NC='\033[0m'

# Файлы configs/, которые НЕ являются dotfile'ами и ставиться не должны:
# это описание каталога инструментов и его README, они нужны самому репозиторию.
NOT_INSTALLED="tools.json
README.md"

# Запускает install_configs из install-tools.sh в подставном HOME.
# $1 — каталог-домик, $2 — «сломать» (имя файла, строку про который выкинуть).
run_install_configs() {
    local fake_home="$1" break_file="${2:-}"
    local fn; fn="$(awk '/^install_configs\(\) \{/,/^\}/' "$INSTALLER")"
    if [ -z "$fn" ]; then
        echo -e "${RED}не удалось выделить install_configs из $INSTALLER${NC}" >&2
        return 2
    fi
    if [ -n "$break_file" ]; then
        fn="$(printf '%s\n' "$fn" | grep -v -F "$break_file")"
    fi
    # XDG-переменные тоже подставные: install_configs зовёт bat cache --build,
    # а bat смотрит на XDG_CACHE_HOME раньше, чем на HOME. Без этого проверка
    # переписала бы настоящий кеш тем пользователя.
    HOME="$fake_home" XDG_CONFIG_HOME="$fake_home/.config" XDG_CACHE_HOME="$fake_home/.cache" bash -c "
        SCRIPT_DIR='$SCRIPT_DIR'
        DRY_RUN=false
        command_exists() { type \"\$1\" &> /dev/null; }
        get_localized_string() { :; }
        $fn
        install_configs
    " > "$fake_home/.install.log" 2>&1
}

# Сверяет, что каждый файл configs/ лежит где-то под $1 с тем же содержимым.
verify() {
    local fake_home="$1" missing=0 checked=0
    local landed; landed="$(find "$fake_home" -type f ! -path '*/.dotfiles-backup/*' -exec md5sum {} + 2>/dev/null | cut -d' ' -f1 | sort -u)"
    while IFS= read -r -d '' src; do
        local rel="${src#"$CONFIGS_SRC"/}"
        printf '%s\n' "$NOT_INSTALLED" | grep -qxF "$rel" && continue
        checked=$((checked + 1))
        local sum; sum="$(md5sum "$src" | cut -d' ' -f1)"
        if ! printf '%s\n' "$landed" | grep -qxF "$sum"; then
            echo -e "${RED}  не поставлен:${NC} configs/$rel"
            missing=$((missing + 1))
        fi
    done < <(find "$CONFIGS_SRC" -type f -print0)
    echo "  проверено файлов: $checked, не доехало: $missing"
    [ "$missing" -eq 0 ]
}

FAKE_HOME=""
cleanup() { [ -n "$FAKE_HOME" ] && rm -rf "$FAKE_HOME"; }
trap cleanup EXIT

main() {
    local fake_home; fake_home="$(mktemp -d)"; FAKE_HOME="$fake_home"
    echo -e "${YELLOW}install_configs в подставном HOME: $fake_home${NC}"
    run_install_configs "$fake_home" || { echo -e "${RED}install_configs упал${NC}"; cat "$fake_home/.install.log"; return 1; }
    if verify "$fake_home"; then
        echo -e "${GREEN}✓ все файлы configs/ доезжают до домашнего каталога${NC}"
        return 0
    fi
    echo -e "${RED}✗ часть файлов configs/ не ставится${NC}"
    return 1
}

selftest() {
    local fake_home; fake_home="$(mktemp -d)"; FAKE_HOME="$fake_home"
    echo -e "${YELLOW}Отрицательный контроль: выкидываем схему Vim из списка копирования${NC}"
    run_install_configs "$fake_home" "colors/digitable.vim" || { echo -e "${RED}install_configs упал${NC}"; return 1; }
    if verify "$fake_home" > /dev/null 2>&1; then
        echo -e "${RED}✗ проверка НЕ заметила пропажу — значит, она ничего не проверяет${NC}"
        return 1
    fi
    echo -e "${GREEN}✓ проверка падает, когда файл не поставлен${NC}"
    return 0
}

if [ "${1:-}" = "--selftest" ]; then selftest; else main; fi
