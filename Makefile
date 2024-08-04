.PHONY:  build run md2pdf check format

IMAGE_NAME = "slide-generator"
CONTAINER_VERSION = "3.12-slim-bullseye"
WORKDIR = "/work"
CUSTOM_THEME = "tohoku-nlp-group"

build: ./Dockerfile ./entrypoint.sh
	docker build . \
	-t $(IMAGE_NAME) \
	--build-arg CONTAINER_VERSION=$(CONTAINER_VERSION) \
	--build-arg WORKDIR=$(WORKDIR)

run:
	docker run -it --rm \
	-e LOCAL_UID=$(shell id -u) \
	-e LOCAL_GID=$(shell id -g) \
	--env-file ./.env \
	--mount type=bind,src=./pyproject.toml,dst=$(WORKDIR)/pyproject.toml \
	--mount type=bind,src=./poetry.lock,dst=$(WORKDIR)/poetry.lock \
	--mount type=bind,src=./README.md,dst=$(WORKDIR)/README.md \
	--mount type=bind,src=./Makefile,dst=$(WORKDIR)/Makefile \
	--mount type=bind,src=./src,dst=$(WORKDIR)/src \
    --mount type=bind,src=./theme,dst=$(WORKDIR)/theme \
    --mount type=bind,src=./samples,dst=$(WORKDIR)/samples \
	$(IMAGE_NAME) bash

md2pdf:
	marp --html --pdf --allow-local-files samples/markdown/test.md -o ./samples/pdf/test.pdf --theme theme/$(CUSTOM_THEME).css

check:
	poetry run ruff check ./src

format:
	poetry run ruff format --diff ./src


