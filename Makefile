.PHONY: test test-dry-run check-configs check-state lint clean install-skills

all: test

interactive:
	@echo "Запуск интерактивного режима..."
	@bash scripts/install-tools.sh --interactive --lang ru

install-skills:
	@bash scripts/install-skills.sh

test:
	@echo "Запуск тестов..."
	@bash scripts/test.sh

check-configs:
	@echo "Проверка согласованности каталога инструментов..."
	@bash scripts/check-config-consistency.sh

check-state:
	@echo "Самопроверка проверяльщика отчётов о состоянии..."
	@bash scripts/check-state-report.sh --selftest

test-dry-run:
	@echo "Запуск в режиме dry-run..."
	@bash scripts/install-tools.sh --dry-run --lang ru

test-dry-run-verbose:
	@echo "Запуск в режиме dry-run с подробным выводом..."
	@bash scripts/install-tools.sh --dry-run --verbose --lang ru

lint:
	@echo "Проверка синтаксиса install-tools.sh..."
	@bash -n scripts/install-tools.sh
	@echo "Проверка синтаксиса install-skills.sh..."
	@bash -n scripts/install-skills.sh
	@echo "Проверка синтаксиса test.sh..."
	@bash -n scripts/test.sh
	@echo "Проверка синтаксиса workbench-configs.sh..."
	@bash -n scripts/customs/workbench-configs.sh
	@echo "Проверка синтаксиса check-config-consistency.sh..."
	@bash -n scripts/check-config-consistency.sh
	@echo "Проверка синтаксиса check-state-report.sh..."
	@bash -n scripts/check-state-report.sh
	@echo "Все проверки синтаксиса прошли успешно!"

clean:
	@echo "Очистка временных файлов..."
	@find . -name "*.tmp" -delete
	@find . -name "*.log" -delete
	@echo "Временные файлы удалены!"

help:
	@echo "Доступные цели:"
	@echo "  make        - запустить тесты"
	@echo "  make test   - запустить тесты"
	@echo "  make test-dry-run - запустить install-tools.sh в режиме dry-run"
	@echo "  make check-configs - проверить согласованность tools.json, locales.json и install-tools.sh"
	@echo "  make check-state - самопроверка проверяльщика отчётов о состоянии"
	@echo "  make test-dry-run-verbose - запустить install-tools.sh в режиме dry-run с подробным выводом"
	@echo "  make install-skills - установить общие навыки в ~/.ai/skills и связать клиентов"
	@echo "  make lint   - проверить синтаксис скриптов"
	@echo "  make clean  - удалить временные файлы"
	@echo "  make help   - показать эту справку"
