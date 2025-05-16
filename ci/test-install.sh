#!/bin/bash

# Скрипт для автоматизации тестирования установки dotfiles
# Запускается в CI/CD пайплайне для проверки автоматической установки

set -e  # Прерывать выполнение при ошибках

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Запуск тестирования автоматической установки ===${NC}"

# Тестирование установки с опцией --dry-run
echo -e "${YELLOW}Запуск с опцией --dry-run...${NC}"
bash scripts/install-tools.sh --dry-run --lang ru

# Тестирование интерактивного режима с автоматическими ответами "yes"
echo -e "${YELLOW}Запуск интерактивного режима с автоответами...${NC}"
printf "y\ny\ny\ny\ny\n" | bash scripts/install-tools.sh --interactive --lang ru --dry-run

# Проверка целостности скрипта
echo -e "${YELLOW}Проверка целостности скрипта...${NC}"
SCRIPT_ERRORS=$(bash -n scripts/install-tools.sh 2>&1 || true)
if [ -n "$SCRIPT_ERRORS" ]; then
    echo -e "${RED}Обнаружены ошибки синтаксиса в скрипте:${NC}"
    echo "$SCRIPT_ERRORS"
    exit 1
else
    echo -e "${GREEN}Скрипт не содержит синтаксических ошибок${NC}"
fi

# Проверка целостности локализаций
echo -e "${YELLOW}Проверка целостности локализаций...${NC}"
if jq -e . scripts/locales.json > /dev/null 2>&1; then
    echo -e "${GREEN}Файл локализаций содержит корректный JSON${NC}"
else
    echo -e "${RED}Файл локализаций содержит некорректный JSON${NC}"
    exit 1
fi

echo -e "${GREEN}=== Все тесты пройдены успешно! ===${NC}" 
