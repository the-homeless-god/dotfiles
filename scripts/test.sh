#!/bin/bash

# Скрипт для тестирования install-tools.sh

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Счетчики тестов
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Функция для запуска теста
run_test() {
    local test_name=$1
    local command=$2
    local expected_exit_code=${3:-0}

    echo -e "${YELLOW}Запуск теста:${NC} $test_name"
    echo -e "${YELLOW}Команда:${NC} $command"
    
    # Запускаем команду и сохраняем вывод и код возврата
    output=$(eval "$command" 2>&1)
    exit_code=$?
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    # Проверяем код возврата
    if [ $exit_code -eq $expected_exit_code ]; then
        echo -e "${GREEN}✓ Тест пройден${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ Тест не пройден${NC}"
        echo -e "${RED}Ожидаемый код возврата: $expected_exit_code, Полученный: $exit_code${NC}"
        echo -e "${RED}Вывод:${NC}"
        echo "$output"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    echo
}

# Проверяем синтаксис скрипта
run_test "Проверка синтаксиса" "bash -n ./scripts/install-tools.sh"

# Проверяем флаг --help
run_test "Проверка флага --help" "./scripts/install-tools.sh --help" 0

# Проверяем флаг --dry-run с указанием языка
run_test "Проверка флага --dry-run с указанием языка" "./scripts/install-tools.sh --dry-run --lang ru | head -20 &>/dev/null" 0

# Проверяем наличие локализаций
run_test "Проверка наличия файла локализаций" "[ -f ./scripts/locales.json ]"

# Проверяем задание языка
run_test "Проверка параметра --lang" "./scripts/install-tools.sh --lang ru --help | grep -q 'Использование'" 0

# Проверяем английский язык
run_test "Проверка параметра --lang для английского" "./scripts/install-tools.sh --lang en --help | grep -q 'Usage'" 0

# Проверяем что скрипт корректно обрабатывает неизвестные флаги
run_test "Проверка обработки неизвестных флагов" "./scripts/install-tools.sh --unknown-flag" 1

# Выводим итоги тестирования
echo -e "${YELLOW}=== Итоги тестирования ===${NC}"
echo -e "Всего тестов: $TESTS_TOTAL"
echo -e "${GREEN}Пройдено: $TESTS_PASSED${NC}"
echo -e "${RED}Не пройдено: $TESTS_FAILED${NC}"

# Возвращаем код возврата в зависимости от результатов тестирования
if [ $TESTS_FAILED -eq 0 ]; then
    exit 0
else
    exit 1
fi 