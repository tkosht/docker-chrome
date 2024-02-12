default: all

all: up install

install: poetry-install

poetry-install:
	@docker compose exec app bash -c 'sh bin/poetry_install.sh'


# ==========
# interaction tasks
bash:
	@docker compose exec app bash

poetry:
	@docker compose exec app bash -i -c 'SHELL=/usr/bin/bash ~/.local/bin/poetry shell'

# ==========
# docker compose aliases
up:
	docker compose up -d

ssh:
	docker compose exec app sudo service ssh start

active:
	docker compose up

ps images down:
	docker compose $@

im: images

build:
	docker compose build

build-no-cache:
	docker compose build --no-cache

reup: down up

clean: clean-container clean-venv

clean-container:
	docker compose down --rmi all

clean-venv:
	rm -rf .venv/

