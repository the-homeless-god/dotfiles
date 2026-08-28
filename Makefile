.PHONY: test test-dry-run lint clean install-codex-skills

all: test

interactive:
	@echo "Запуск интерактивного режима..."
	@bash scripts/install-tools.sh --interactive --lang ru

install-codex-skills:
	@bash scripts/install-codex-skills.sh

test:
	@echo "Запуск тестов..."
	@bash scripts/test.sh

test-dry-run:
	@echo "Запуск в режиме dry-run..."
	@bash scripts/install-tools.sh --dry-run --lang ru

test-dry-run-verbose:
	@echo "Запуск в режиме dry-run с подробным выводом..."
	@bash scripts/install-tools.sh --dry-run --verbose --lang ru

lint:
	@echo "Проверка синтаксиса install-tools.sh..."
	@bash -n scripts/install-tools.sh
	@echo "Проверка синтаксиса install-codex-skills.sh..."
	@bash -n scripts/install-codex-skills.sh
	@echo "Проверка синтаксиса test.sh..."
	@bash -n scripts/test.sh
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
	@echo "  make test-dry-run-verbose - запустить install-tools.sh в режиме dry-run с подробным выводом"
	@echo "  make install-codex-skills - установить portable Codex skills"
	@echo "  make lint   - проверить синтаксис скриптов"
	@echo "  make clean  - удалить временные файлы"
	@echo "  make help   - показать эту справку"
