SHELL := /bin/bash
IMAGE_NAME ?= gearmand
DOCKER_USERNAME ?= visualphoenix

.PHONY: all clean build builder run

build: Dockerfile build/$(IMAGE_NAME)-amd64
	docker build \
		--build-arg repo=$(IMAGE_NAME) \
		-f Dockerfile \
		-t $(IMAGE_NAME) .

builder: Dockerfile.builder
	docker build \
		--build-arg repo=$(IMAGE_NAME) \
		--build-arg username=$(DOCKER_USERNAME) \
		-f Dockerfile.builder \
		-t $(IMAGE_NAME)-builder .

build/$(IMAGE_NAME)-amd64: builder
	set -x && \
	mkdir -p $(@D) && \
	pushd $(@D) &>/dev/null && \
	docker run \
		--rm $(IMAGE_NAME)-builder \
		sh -c 'cd /go/bin && tar -c $(IMAGE_NAME)*' | tar -xv && \
	popd &>/dev/null && \
	touch $(@)

run:
	docker run -d -p 4730:4730 $(IMAGE_NAME)

clean:
	test -d build && rm -r build || true
