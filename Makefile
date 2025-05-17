# ==== Конфігурація ====
IMAGE_NAME=golang
REGISTRY=quay.io/yourproject
BUILDX=buildx


PLATFORMS=linux/amd64 linux/arm64 darwin/amd64 darwin/arm64 windows/amd64

.PHONY: all clean $(subst /,_,$(PLATFORMS))

$(foreach plat,$(PLATFORMS),$(eval $(subst /,_,${plat}): ; docker buildx build --platform ${plat} \
	--build-arg TARGETOS=$(word 1,$(subst /, ,${plat})) \
	--build-arg TARGETARCH=$(word 2,$(subst /, ,${plat})) \
	--output type=local,dest=build/$(subst /,_,${plat}) \
	--file Dockerfile .))

all: $(subst /,_,${PLATFORMS})

image:
	docker buildx build \
		--platform linux/amd64 \
		--build-arg TARGETOS=linux \
		--build-arg TARGETARCH=amd64 \
		--output type=docker \
		--tag quay.io/your-org/test-app:linux_amd64 \
		.

clean:
	@for platform in $(ALL_PLATFORMS); do \
		docker rmi $(REGISTRY)/$(IMAGE_NAME):$$platform || true; \
	done