# Makefile for building the pgbouncer Docker image

# Load variables from .env (required)
ifeq (,$(wildcard .env))
$(error .env file is required. Create it with PGBOUNCER_TAG, PGBOUNCER_VERSION, and PGBOUNCER_CHECKSUM)
endif

include .env
export

# Ensure required build arguments are defined
ifndef PGBOUNCER_TAG
$(error PGBOUNCER_TAG is required in .env)
endif
ifndef PGBOUNCER_VERSION
$(error PGBOUNCER_VERSION is required in .env)
endif
ifndef PGBOUNCER_CHECKSUM
$(error PGBOUNCER_CHECKSUM is required in .env)
endif

IMAGE_NAME ?= pgbouncer:$(PGBOUNCER_VERSION)

.PHONY: build
build:
	docker build \
	  --build-arg PGBOUNCER_TAG=$(PGBOUNCER_TAG) \
	  --build-arg PGBOUNCER_VERSION=$(PGBOUNCER_VERSION) \
	  --build-arg PGBOUNCER_CHECKSUM=$(PGBOUNCER_CHECKSUM) \
	  -t $(IMAGE_NAME) .

.PHONY: help
help:
	@echo "Makefile targets:"
	@echo "  build        Build the Docker image (override build args as needed)"
	@echo "    Example: make build PGBOUNCER_VERSION=1.25.0"
