DOCKER_COMPOSE := docker-compose

.PHONY: help build up down restart bash logs clean

help:
	@echo "Доступные команды:"
	@echo "  make build   - собрать Docker образ"
	@echo "  make up      - запустить контейнер в фоне"
	@echo "  make down    - остановить и удалить контейнер"
	@echo "  make restart - перезапустить контейнер"
	@echo "  make bash    - войти в контейнер (интерактивный bash)"
	@echo "  make logs    - смотреть логи контейнера"
	@echo "  make clean   - удалить контейнер и volume с моделями"

build:
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

restart:
	$(DOCKER_COMPOSE) restart whisper

bash:
	$(DOCKER_COMPOSE) exec whisper bash

logs:
	$(DOCKER_COMPOSE) logs -f whisper

clean:
	$(DOCKER_COMPOSE) down
	docker volume rm whisper-docker_whisper-models || true