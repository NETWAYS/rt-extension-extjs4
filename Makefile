SHELL				= /bin/bash
DOCKER_COMPOSE		= $(shell command -v docker-compose)
DOCKER_COMPOSE_YML	= docker-compose.yml
DOCKER_BASE_IMAGES	= base library source runtime
DOCKER_PROD_IMAGES	= netways icinga
DOCKER_IMAGE_PREFIX	= rt4netways

all: help

help:
	@echo "Make targets:"
	@echo ""
	@echo "  make base-images"
	@echo ""

$(DOCKER_BASE_IMAGES) $(DOCKER_PROD_IMAGES):
	${DOCKER_COMPOSE} \
			--project-name=${DOCKER_IMAGE_PREFIX} \
			--file=${DOCKER_COMPOSE_YML} \
			build $@

base-images: $(DOCKER_BASE_IMAGES)