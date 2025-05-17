APP=golang
REGISTRY=quay.io/projectquay

PLATFORMS=linux/amd64 linux/arm64 darwin/amd64 darwin/arm64 windows/amd64

.PHONY: all clean $(subst /,_,$(PLATFORMS))

$(foreach plat,$(PLATFORMS),$(eval $(subst /,_,${plat}): ; \
	docker buildx build --platform ${plat} \
		--build-arg TARGETOS=$(word 1,$(subst /, ,${plat})) \
		--build-arg TARGETARCH=$(word 2,$(subst /, ,${plat})) \
		-t $(REGISTRY)/$(APP):$(subst /,_,${plat}) \
		--output type=docker \
		--file Dockerfile .))

all: $(subst /,_,${PLATFORMS})

image:
	docker buildx build \
		--platform linux/amd64 \
		--build-arg TARGETOS=linux \
		--build-arg TARGETARCH=amd64 \
		-t $(REGISTRY)/$(APP):linux_amd64 \
		--output type=docker \
		.

clean:
	@rm -rf build/
	@for platform in $(subst /,_,${PLATFORMS}); do \
		docker rmi $(REGISTRY)/$(APP):$$platform 2>/dev/null || true; \
	done
