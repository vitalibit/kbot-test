REPO ?= quay.io/projectquay
APP ?= test-app
ARTIFACTS ?= build

PLATFORMS_LIST = linux-amd64 linux-arm64 darwin-amd64 darwin-arm64 windows-amd64

.DEFAULT_GOAL := build-all

.PHONY: build-all clean image $(PLATFORMS_LIST)

build-all: $(PLATFORMS_LIST)

prepare:
	@mkdir -p $(ARTIFACTS)

linux-amd64:
	@$(MAKE) docker-img OS=linux ARCH=amd64

linux-arm64:
	@$(MAKE) docker-img OS=linux ARCH=arm64

darwin-amd64: prepare
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -o $(ARTIFACTS)/$(APP)-darwin-amd64 .

darwin-arm64: prepare
	GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 go build -o $(ARTIFACTS)/$(APP)-darwin-arm64 .

windows-amd64: prepare
	GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o $(ARTIFACTS)/$(APP)-windows-amd64.exe .

docker-img:
	docker buildx build \
		--platform=$(OS)/$(ARCH) \
		--build-arg TARGETOS=$(OS) \
		--build-arg TARGETARCH=$(ARCH) \
		--output type=docker \
		--tag $(REPO)/$(APP):$(OS)_$(ARCH) \
		.

multi-image:
	@for p in $(PLATFORMS_LIST); do \
		os=$${p%-*}; arch=$${p#*-}; \
		docker buildx build \
			--platform=$$os/$$arch \
			--build-arg TARGETOS=$$os \
			--build-arg TARGETARCH=$$arch \
			--output type=docker \
			--tag $(REPO)/$(APP):$$os\_$$arch \
			. ; \
	done

image:
	$(MAKE) multi-image

clean:
	@for p in $(PLATFORMS_LIST); do \
		os=$${p%-*}; arch=$${p#*-}; \
		docker rmi $(REPO)/$(APP):$$os\_$$arch 2>/dev/null || true; \
	done
	rm -rf $(ARTIFACTS)
