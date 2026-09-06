#!/bin/bash
#
# Сторож палитры Digitable.
#
# Цветов в дереве шесть файлов: схема Vim, тема bat/delta, alacritty, tmux,
# bpytop. Палитра у них одна, и разъехаться ей нельзя. Раньше числа и замеры
# контраста жили в комментарии к схеме — комментарий ничего не сторожит.
# Теперь источник один: theme/digitable.flang, а этот скрипт сверяет с ним
# дерево.
#
# Проверяется две вещи, и они делятся по сложности счёта:
#   1. ЗДЕСЬ, всегда и без компилятора: каждый цвет в конфигах либо объявлен
#      в спеке, либо является подмесью «цвет N% поверх фона» — арифметика
#      целочисленная, её незачем никуда уносить. И наоборот: объявленный
#      цвет обязан быть где-то использован.
#   2. В flang, если он установлен: контраст по WCAG (там нужна степень 2.4)
#      и пороги. Компилятор доказывает завершение и гоняет примеры с точными
#      числами. Без flang этот пункт не считается пройденным — он честно
#      печатается как «не мерил», а не как «ок».
#
# Ключи:
#   (без ключей)  прогнать проверку
#   --selftest    отрицательный контроль: подсунуть конфигу цвет не из палитры
#                 и убедиться, что проверка ПАДАЕТ

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SPEC="$REPO_DIR/theme/digitable.flang"
# Компилятор языка спеки. Переопределяется переменной окружения FLANG —
# он ставится не из этого репозитория (brew install digitable-lol/tap/flang).
FLANG="${FLANG:-flang}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; NC='\033[0m'

# Файлы, которые красят. Список явный: добавили новый — впишите сюда,
# иначе его цвета никто не сторожит.
PAINTED="configs/.vim/colors/digitable.vim
configs/.alacritty.toml
configs/.gitconfig
configs/.config/tmux/.tmux.conf
configs/.config/bat/themes/digitable.tmTheme
configs/.config/bpytop/themes/digitable.theme"

# Доли подмеси, которыми пользуется палитра: 12% и 30% — панели «получилось» и
# «не получилось», 16% — подсветка совпадения поиска.
RATIOS="0.12 0.16 0.30"

fail=0

hexes_of() { grep -oiE '#[0-9a-f]{6}' "$1" | tr 'A-F' 'a-f' | sort -u; }

# Палитра берётся из спеки — из тела функции «Палитра», а не из всего файла.
# В спеке цвет записан числами (кр/зел/син), шестнадцатеричная запись из них
# считается: у цвета одно место правды. Здесь считается то же самое, чтобы
# сверять дерево можно было и без компилятора.
read_palette() {
    [ -f "$SPEC" ] || { echo -e "${RED}нет спеки $SPEC${NC}" >&2; exit 2; }
    local pal
    pal="$(awk '
        /функция .Палитра./ { on = 1; next }
        on && /запись/ {
            line = $0
            gsub(/"[^"]*"/, "", line)          # имя цвета выкидываем: в нём бывают цифры
            n = 0
            while (match(line, /[0-9]+/)) {
                v[++n] = substr(line, RSTART, RLENGTH)
                line = substr(line, RSTART + RLENGTH)
            }
            if (n >= 3) printf "#%02x%02x%02x\n", v[1], v[2], v[3]
        }
        on && /\]/ { on = 0 }
    ' "$SPEC" | sort -u)"
    if [ -z "$pal" ]; then
        echo -e "${RED}в $SPEC не нашлось тела функции «Палитра» — палитру не с чем сверять${NC}" >&2
        exit 2
    fi
    printf '%s\n' "$pal"
}

# Подмесь: цвет доли a поверх фона. Возвращает 0, если $2 получается из
# какого-нибудь цвета палитры.
is_mix() {
    local target="$1" bg="$2" pal="$3"
    awk -v target="$target" -v bg="$bg" -v ratios="$RATIOS" -v pal="$pal" '
    function v(s, i) { return strtonum("0x" substr(s, 2 + 2 * i, 2)) }
    BEGIN {
        n = split(ratios, R, " "); m = split(pal, P, "\n")
        for (i = 1; i <= n; i++) for (j = 1; j <= m; j++) {
            if (length(P[j]) != 7) continue
            s = "#"
            for (k = 0; k < 3; k++)
                s = s sprintf("%02x", int(R[i] * v(P[j], k) + (1 - R[i]) * v(bg, k) + 0.5))
            if (s == target) { print P[j] " " R[i]; exit 0 }
        }
        exit 1
    }'
}

check_palette() {
    local pal bg0 used_any
    pal="$(read_palette)"
    bg0="#05080d"
    echo -e "${YELLOW}Палитра из спеки: $(printf '%s\n' "$pal" | grep -c .) цветов${NC}"
    used_any=""
    local f
    while IFS= read -r f; do
        [ -f "$REPO_DIR/$f" ] || { echo -e "${RED}  нет файла $f${NC}"; fail=1; continue; }
        local h bad=0
        while IFS= read -r h; do
            [ -z "$h" ] && continue
            used_any="$used_any$h"$'\n'
            if printf '%s\n' "$pal" | grep -qxF "$h"; then continue; fi
            local m; m="$(is_mix "$h" "$bg0" "$pal")"
            if [ -n "$m" ]; then continue; fi
            echo -e "${RED}  $f: $h — не из палитры и не подмесь${NC}"
            bad=1; fail=1
        done < <(hexes_of "$REPO_DIR/$f")
        [ "$bad" -eq 0 ] && echo "  ok  $f"
    done <<< "$PAINTED"

    # Обратная сторона: объявленный цвет, который нигде не используется,
    # — это или опечатка, или забытый файл.
    local c unused=0
    while IFS= read -r c; do
        [ -z "$c" ] && continue
        printf '%s' "$used_any" | grep -qxF "$c" || { echo -e "${RED}  цвет $c объявлен в спеке, но нигде не используется${NC}"; unused=1; fail=1; }
    done <<< "$pal"
    [ "$unused" -eq 0 ] && echo "  ok  каждый объявленный цвет где-то используется"
}

check_contrast() {
    if ! type "$FLANG" &> /dev/null; then
        echo -e "${YELLOW}Контраст: не мерил — flang не установлен."
        echo -e "  Пороги и точные числа лежат в $SPEC и проверяются командой"
        echo -e "  flang check theme/digitable.flang (brew install digitable-lol/tap/flang).${NC}"
        return 0
    fi
    echo -e "${YELLOW}Контраст: $FLANG check${NC}"
    if "$FLANG" check "$SPEC"; then
        echo -e "${GREEN}  ok  контрасты и пороги сходятся${NC}"
    else
        echo -e "${RED}  ✗ спека не прошла проверку${NC}"; fail=1
    fi
}

main() {
    check_palette
    check_contrast
    if [ "$fail" -eq 0 ]; then
        echo -e "${GREEN}✓ палитра сходится${NC}"; return 0
    fi
    echo -e "${RED}✗ палитра разъехалась${NC}"; return 1
}

TMP_DIR=""
cleanup() { [ -n "$TMP_DIR" ] && rm -rf "$TMP_DIR"; }
trap cleanup EXIT

selftest() {
    local tmp; tmp="$(mktemp -d)"; TMP_DIR="$tmp"
    cp -r "$REPO_DIR/configs" "$tmp/configs"
    cp -r "$REPO_DIR/theme" "$tmp/theme"
    cp -r "$REPO_DIR/scripts" "$tmp/scripts"
    local rc=0

    # Случай 1: в конфиге цвет, которого в палитре нет и подмесью он не является.
    local one; one="$tmp/one"; cp -r "$tmp/configs" "$one-configs"
    sed -i 's/#05080d/#123456/' "$tmp/configs/.alacritty.toml"
    echo -e "${YELLOW}Контроль 1: в .alacritty.toml подсунут #123456${NC}"
    if bash "$tmp/scripts/check-theme.sh" > /dev/null 2>&1; then
        echo -e "${RED}  ✗ чужой цвет в конфиге не замечен${NC}"; rc=1
    else
        echo -e "${GREEN}  ✓ падает на цвете не из палитры${NC}"
    fi
    rm -rf "$tmp/configs"; mv "$one-configs" "$tmp/configs"

    # Случай 2: в палитру спеки добавлен цвет, которым ничего не покрашено.
    echo -e "${YELLOW}Контроль 2: в палитру спеки добавлен неиспользуемый #abcdef${NC}"
    sed -i 's/и син равным 91\]/и син равным 91,\n   запись «Цвет» с имя равным "ghost" и кр равным 171 и зел равным 205 и син равным 239]/' "$tmp/theme/digitable.flang"
    if bash "$tmp/scripts/check-theme.sh" > /dev/null 2>&1; then
        echo -e "${RED}  ✗ неиспользуемый цвет в спеке не замечен${NC}"; rc=1
    else
        echo -e "${GREEN}  ✓ падает на объявленном, но неиспользуемом цвете${NC}"
    fi

    [ "$rc" -eq 0 ] && echo -e "${GREEN}✓ проверка умеет падать в обе стороны${NC}"
    return "$rc"
}

if [ "${1:-}" = "--selftest" ]; then selftest; else main; fi
