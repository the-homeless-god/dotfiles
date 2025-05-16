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

# Функция для запуска теста с таймаутом
run_test() {
    local test_name=$1
    local command=$2
    local expected_exit_code=${3:-0}
    local timeout=${4:-5}  # Таймаут в секундах, по умолчанию 5 секунд

    echo -e "${YELLOW}Запуск теста:${NC} $test_name"
    echo -e "${YELLOW}Команда:${NC} $command"
    
    # Создаем временный файл для вывода
    local temp_file=$(mktemp)
    
    # Запускаем команду с таймаутом и перенаправляем вывод
    (
        # Устанавливаем ловушку для SIGALRM
        trap 'exit 124' ALRM
        # Запускаем таймер в фоне, который пришлет SIGALRM через $timeout секунд
        (sleep $timeout && kill -ALRM $$) &
        timer_pid=$!
        
        # Запускаем команду и сохраняем код возврата
        eval "$command" > "$temp_file" 2>&1
        exit_code=$?
        
        # Убиваем таймер, так как команда завершилась
        kill $timer_pid 2>/dev/null || true
        
        exit $exit_code
    )
    local test_exit_code=$?
    
    # Если тест завершился по таймауту
    if [ $test_exit_code -eq 124 ]; then
        echo -e "${RED}✗ Тест не пройден - превышен таймаут ($timeout сек)${NC}"
        echo -e "${RED}Вывод до таймаута:${NC}"
        cat "$temp_file"
        TESTS_TOTAL=$((TESTS_TOTAL + 1))
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        # Читаем вывод из временного файла
        output=$(cat "$temp_file")
        
        TESTS_TOTAL=$((TESTS_TOTAL + 1))
        
        # Проверяем код возврата
        if [ $test_exit_code -eq $expected_exit_code ]; then
            echo -e "${GREEN}✓ Тест пройден${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo -e "${RED}✗ Тест не пройден${NC}"
            echo -e "${RED}Ожидаемый код возврата: $expected_exit_code, Полученный: $test_exit_code${NC}"
            echo -e "${RED}Вывод:${NC}"
            echo "$output"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    fi
    
    # Удаляем временный файл
    rm -f "$temp_file"
    
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
