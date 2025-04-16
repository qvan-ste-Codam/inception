DOCKER_COMPOSE_FILE=srcs/docker-compose.yml
NAME=inception
DATA_DIR=$(HOME)/data

ifeq ($(wildcard $(DATA_DIR)),)
all: build run
else
all: run
endif

run:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(NAME) up

build:
	mkdir -p $(DATA_DIR)/www $(DATA_DIR)/db
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(NAME) build --no-cache

clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down --remove-orphans
	docker system prune -a -f
	docker volume prune -a -f
	rm -rf $(DATA_DIR)

re: clean build all

.PHONY: all build clean re run