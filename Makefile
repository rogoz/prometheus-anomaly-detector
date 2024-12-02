DOCKER_IMAGE=docker2-granite-release-local.dr-uw2.adobeitc.com/skyops/pad
DOCKER_TAG ?= latest


build:
		docker buildx build --load -f Dockerfile . -t ${DOCKER_IMAGE}:${DOCKER_TAG}


release: build
		docker buildx build --push --platform linux/arm64,linux/amd64 -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
