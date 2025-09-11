# Variables
IMAGE ?= caturro-cafe
TAG ?= latest
CONTAINER ?= caturro-cafe
PORT ?= 5002

.PHONY: build run stop restart logs shell clean status

build:
	@echo "[+] Building $(IMAGE):$(TAG)"
	docker build -t $(IMAGE):$(TAG) .

run: stop
	@echo "[+] Running $(CONTAINER) on http://localhost:$(PORT)"
	docker run -d --name $(CONTAINER) -p $(PORT):80 $(IMAGE):$(TAG)

dev: stop
	@echo "[+] Dev mode (bind mount) on http://localhost:$(PORT)"
	docker run -d --name $(CONTAINER) -p $(PORT):80 \
	  -v $(PWD)/index.html:/usr/share/nginx/html/index.html:ro \
	  -v $(PWD)/styles.css:/usr/share/nginx/html/styles.css:ro \
	  -v $(PWD)/script.js:/usr/share/nginx/html/script.js:ro \
	  -v $(PWD)/assets:/usr/share/nginx/html/assets:ro \
	  $(IMAGE):$(TAG)

stop:
	@echo "[+] Stopping/removing $(CONTAINER) if exists"
	-@docker rm -f $(CONTAINER) 2>/dev/null || true

restart:
	$(MAKE) run

logs:
	docker logs -f $(CONTAINER)

shell:
	docker exec -it $(CONTAINER) sh

status:
	@docker ps --filter name=$(CONTAINER)

clean:
	@echo "[+] Removing image $(IMAGE):$(TAG)"
	-@docker rmi $(IMAGE):$(TAG) 2>/dev/null || true
