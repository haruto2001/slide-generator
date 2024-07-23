.PHONY:  build run check format

IMAGE_NAME = "slide-generator"
CONTAINER_VERSION = "3.13.0b4-slim-bullseye"
CURRENT_DIR = $(shell pwd)
WORK_DIR = "/work"

build: $(CURRENT_DIR)/Dockerfile $(CURRENT_DIR)/entrypoint.sh
	docker build . \
	-t $(IMAGE_NAME) \
	--build-arg CONTAINER_VERSION=$(CONTAINER_VERSION) \
	--build-arg WORKDIR=$(WORK_DIR)

run:
	docker run -it --rm \
	-e LOCAL_UID=$(shell id -u) \
	-e LOCAL_GID=$(shell id -g) \
	--env-file $(CURRENT_DIR)/.env \
	--mount type=bind,src=$(CURRENT_DIR)/pyproject.toml,dst=$(WORK_DIR)/pyproject.toml \
	--mount type=bind,src=$(CURRENT_DIR)/poetry.lock,dst=$(WORK_DIR)/poetry.lock \
	--mount type=bind,src=$(CURRENT_DIR)/README.md,dst=$(WORK_DIR)/README.md \
	--mount type=bind,src=$(CURRENT_DIR)/src,dst=$(WORK_DIR)/src \
    --mount type=bind,src=$(CURRENT_DIR)/theme,dst=$(WORK_DIR)/theme \
    --mount type=bind,src=$(CURRENT_DIR)/samples,dst=$(WORK_DIR)/samples \
	$(IMAGE_NAME) bash

check:
	poetry run ruff check $(CURRENT_DIR)/src

format:
	poetry run ruff format --diff $(CURRENT_DIR)/src


