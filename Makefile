# Makefile for building the pgbouncer Docker image

# Default build arguments (from GitHub workflow)
PGBOUNCER_TAG ?= 1_25_0
PGBOUNCER_VERSION ?= 1.25.0
PGBOUNCER_CHECKSUM ?= sha256:290bad449e4580f0174d3677c26c1076d4ce5dd7ca116ae1fca10272ef74d10e
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
