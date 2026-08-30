#!/bin/bash

# Проверка согласованности каталога инструментов.
#
# Три источника правды об одном и том же наборе инструментов расходятся молча:
#   configs/tools.json      — что показывает интерактивное меню;
#   scripts/locales.json    — описания, которые печатают меню и итоговая сводка;
#   install-tools.sh        — вызовы install_if_confirmed / confirm_source_tool,
#                             то есть что скрипт вообще умеет ставить.
# Расхождение не ломает синтаксис и не роняет dry-run, поэтому его не ловит ни
# один существующий тест. Здесь оно ловится.
#
# Пути можно переопределить переменными окружения TOOLS_FILE, LOCALES_FILE и
# INSTALL_SCRIPT — так проверку можно натравить на заведомо битый вход и
# убедиться, что она действительно падает.

# Сортировка и сравнение множеств должны быть в одной локали, иначе comm ругается
# на «file is not in sorted order» и молча выдаёт мусор.
export LC_ALL=C

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
TOOLS_FILE="${TOOLS_FILE:-$ROOT_DIR/configs/tools.json}"
LOCALES_FILE="${LOCALES_FILE:-$ROOT_DIR/scripts/locales.json}"
INSTALL_SCRIPT="${INSTALL_SCRIPT:-$ROOT_DIR/scripts/install-tools.sh}"

ERRORS=0

fail() {
    echo -e "${RED}✗ $1${NC}"
    ERRORS=$((ERRORS + 1))
}

ok() {
    echo -e "${GREEN}✓ $1${NC}"
}

list() {
    # печатает список с отступом, чтобы в выводе теста было видно, что именно разошлось
    while IFS= read -r item; do
        [ -n "$item" ] && echo "    - $item"
    done
}

echo -e "${YELLOW}=== Проверка согласованности каталога инструментов ===${NC}"
echo "  tools.json:     $TOOLS_FILE"
echo "  locales.json:   $LOCALES_FILE"
echo "  install-tools:  $INSTALL_SCRIPT"
echo

if ! command -v jq > /dev/null 2>&1; then
    echo -e "${RED}jq не найден — проверку выполнить нечем${NC}"
    exit 2
fi

# 1. tools.json должен быть валидным JSON
if jq -e . "$TOOLS_FILE" > /dev/null 2>&1; then
    ok "$TOOLS_FILE — корректный JSON"
else
    fail "$TOOLS_FILE — некорректный JSON или файл недоступен"
    echo -e "${RED}Дальше сравнивать нечего.${NC}"
    exit 1
fi

if jq -e . "$LOCALES_FILE" > /dev/null 2>&1; then
    ok "$LOCALES_FILE — корректный JSON"
else
    fail "$LOCALES_FILE — некорректный JSON или файл недоступен"
    echo -e "${RED}Дальше сравнивать нечего.${NC}"
    exit 1
fi

if [ ! -f "$INSTALL_SCRIPT" ]; then
    fail "$INSTALL_SCRIPT — файл не найден"
    exit 1
fi

TOOLS=$(jq -r '.categories[].tools[]' "$TOOLS_FILE" | sort -u)

if [ -z "$TOOLS" ]; then
    fail "в $TOOLS_FILE нет ни одного инструмента"
    exit 1
fi

# 2. Каталог инструментов и словарь описаний должны совпадать — в обе стороны.
#    Инструмент без описания печатается в меню голым именем; описание без
#    инструмента — мёртвая строка, которую никто никогда не прочитает.
for lang in $(jq -r 'keys[]' "$LOCALES_FILE"); do
    packages=$(jq -r --arg l "$lang" '.[$l].packages // {} | keys[]' "$LOCALES_FILE" | sort -u)

    missing=$(comm -23 <(echo "$TOOLS") <(echo "$packages"))
    if [ -n "$missing" ]; then
        fail "в tools.json есть инструменты, которых нет в locales.json [$lang]:"
        echo "$missing" | list
    else
        ok "все инструменты tools.json описаны в locales.json [$lang]"
    fi

    extra=$(comm -13 <(echo "$TOOLS") <(echo "$packages"))
    if [ -n "$extra" ]; then
        fail "в locales.json [$lang] есть описания инструментов, которых нет в tools.json:"
        echo "$extra" | list
    else
        ok "в locales.json [$lang] нет описаний без инструмента"
    fi
done

# 3. Всё, что скрипт предлагает поставить, должно быть в каталоге. Иначе в
#    интерактивном режиме is_tool_selected никогда не вернёт истину и инструмент
#    молча не установится ни разу.
CALLS=$(grep -oE '(install_if_confirmed|confirm_source_tool) "[^"]+"' "$INSTALL_SCRIPT" \
        | sed -E 's/^[a-z_]+ "//; s/"$//' | sort -u)

if [ -z "$CALLS" ]; then
    fail "в $INSTALL_SCRIPT не найдено ни одного вызова install_if_confirmed"
else
    unknown=$(comm -23 <(echo "$CALLS") <(echo "$TOOLS"))
    if [ -n "$unknown" ]; then
        fail "install_if_confirmed/confirm_source_tool вызывается для инструментов, которых нет в tools.json:"
        echo "$unknown" | list
    else
        ok "все вызовы install_if_confirmed/confirm_source_tool есть в tools.json"
    fi
fi

echo
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}Каталог инструментов согласован${NC}"
    exit 0
else
    echo -e "${RED}Найдено расхождений: $ERRORS${NC}"
    exit 1
fi
