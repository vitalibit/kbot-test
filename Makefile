APP := task3
REGISTRY ?= ghcr.io/bwoogmy
VERSION ?= latest
IMAGE_TAG ?= $(REGISTRY)/$(APP):$(VERSION)

UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Linux)
	GOOS := linux
else ifeq ($(UNAME_S),Darwin)
	GOOS := darwin
else ifeq ($(findstring MINGW,$(UNAME_S)),MINGW)
	GOOS := windows
else
	GOOS := linux
endif

ifeq ($(UNAME_M),x86_64)
	GOARCH := amd64
else ifeq ($(UNAME_M),arm64)
	GOARCH := arm64
else
	GOARCH := amd64
endif

.PHONY: native linux-amd linux-arm macos-amd macos-arm windows image clean

native:
	@echo "Building for current platform: GOOS=$(GOOS), GOARCH=$(GOARCH)"
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o bin/$(APP)-$(GOOS)-$(GOARCH) main.go

linux-amd:
	GOOS=linux GOARCH=amd64 go build -o bin/$(APP)-linux-amd64 main.go

linux-arm:
	GOOS=linux GOARCH=arm64 go build -o bin/$(APP)-linux-arm64 main.go

macos-amd:
	GOOS=darwin GOARCH=amd64 go build -o bin/$(APP)-darwin-amd64 main.go

macos-arm:
	GOOS=darwin GOARCH=arm64 go build -o bin/$(APP)-darwin-arm64 main.go

windows:
	GOOS=windows GOARCH=amd64 go build -o bin/$(APP)-windows-amd64.exe main.go

image:
	docker buildx build --platform $(GOOS)/$(GOARCH) \
		--build-arg TARGETOS=$(GOOS) \
		--build-arg TARGETARCH=$(GOARCH) \
		-t $(IMAGE_TAG)-$(GOOS)-$(GOARCH) --load .

clean:
	@echo "Cleaning binaries and Docker images..."
	@rm -rf bin/
	@docker rmi $(IMAGE_TAG)-linux-amd64 2>/dev/null || true
	@docker rmi $(IMAGE_TAG)-linux-arm64 2>/dev/null || true
	@docker rmi $(IMAGE_TAG)-darwin-amd64 2>/dev/null || true
	@docker rmi $(IMAGE_TAG)-darwin-arm64 2>/dev/null || true
	@docker rmi $(IMAGE_TAG)-windows-amd64 2>/dev/null || true
	@docker rmi $(IMAGE_TAG)-$(GOOS)-$(GOARCH) 2>/dev/null || true
