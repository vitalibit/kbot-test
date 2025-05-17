APP      := task3
REGISTRY ?= ghcr.io/bwoogmy
IMAGE    := $(REGISTRY)/$(APP)

PLATFORMS_LIST = linux_amd64 linux_arm64 darwin_amd64 darwin_arm64 windows_amd64

define build_platform
build-$(1):
	docker buildx build \
		--platform $(subst _,/,$(1)) \
		--build-arg TARGETOS=$(word 1,$(subst _, ,$(1))) \
		--build-arg TARGETARCH=$(word 2,$(subst _, ,$(1))) \
		--output type=local,dest=output/$(1) \
		-t $(IMAGE):$(1) .
endef

$(foreach plat,$(PLATFORMS_LIST),$(eval $(call build_platform,$(plat))))

.PHONY: all clean $(addprefix build-,$(PLATFORMS_LIST))

all: $(addprefix build-,$(PLATFORMS_LIST))

# Просто отдельная сборка под linux amd64 и push
image:
	docker buildx build \
		--platform linux/amd64 \
		--build-arg TARGETOS=linux \
		--build-arg TARGETARCH=amd64 \
		-t $(IMAGE):linux_amd64 \
		--output type=docker .

push:
	docker push $(IMAGE):linux_amd64

clean:
	@rm -rf output/
	@for p in $(PLATFORMS_LIST); do docker rmi $(IMAGE):$$p || true; done
