SHELL								= /bin/bash
DOCKER_COMPOSE			= $(shell command -v docker-compose)
DOCKER							= $(shell command -v docker)
GIT									= $(shell command -v git)
GIT_EXPORT_FILE			= rt4netways.tgz
DOCKER_COMPOSE_YML	= docker-compose.yml
DOCKER_BASE_IMAGES	= base library source runtime
DOCKER_PROD_IMAGES	= netways icinga
DOCKER_IMAGE_PREFIX	= rt4netways
IMAGES_DANGLING			= $(shell ${DOCKER} images -q -f dangling=true)

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

clean:
	@if [[ ! "z${IMAGES_DANGLING}" -eq "z" ]]; then \
		echo "Delete dangling images"; \
		${DOCKER} rmi ${IMAGES_DANGLING}; \
	else \
		echo "No dangling images to delete"; \
	fi

distclean:
	@${DOCKER_COMPOSE} down --rmi local

export:
	@if [[ -e "${GIT_EXPORT_FILE}" ]]; then \
		echo "Target file exists (${GIT_EXPORT_FILE}), delete"; \
		rm ${GIT_EXPORT_FILE}; \
	fi
	@echo -n "Export git HEAD to ${GIT_EXPORT_FILE} ... "
	@${GIT} archive --format=tar --prefix=rt4netways/ HEAD | gzip -c > ${GIT_EXPORT_FILE}
	@echo "ok"
