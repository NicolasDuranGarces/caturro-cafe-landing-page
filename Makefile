# Variables
IMAGE ?= caturro-cafe
TAG ?= latest
PORT ?= 5002
DEV_PORT ?= 5003
COMPOSE ?= docker compose

.PHONY: build run dev stop restart logs clean status

build:
	@echo "[+] Building production image"
	$(COMPOSE) build app

run:
	@echo "[+] Running production on http://localhost:$(PORT)"
	PORT=$(PORT) IMAGE=$(IMAGE) TAG=$(TAG) $(COMPOSE) up -d --build app

dev:
	@echo "[+] Running development on http://localhost:$(DEV_PORT)"
	DEV_PORT=$(DEV_PORT) $(COMPOSE) --profile dev up -d app-dev

stop:
	@echo "[+] Stopping compose services"
	$(COMPOSE) down --remove-orphans

restart:
	$(MAKE) run

logs:
	$(COMPOSE) logs -f --tail=100

status:
	$(COMPOSE) ps

clean:
	@echo "[+] Removing compose stack and local image cache"
	$(COMPOSE) down --remove-orphans --rmi local
