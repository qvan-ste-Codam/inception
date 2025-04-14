DOCKER_COMPOSE_FILE=srcs/docker-compose.yml
NAME=inception

all:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(NAME) up

build:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(NAME) build --no-cache

clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down --remove-orphans
	docker system prune -a -f
	docker volume prune -a -f

re: clean build all

.PHONY: all build clean