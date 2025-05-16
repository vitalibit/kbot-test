APP := task3
REGISTRY ?= ghcr.io/bwoogmy
VERSION ?= latest
IMAGE_TAG ?= $(REGISTRY)/$(APP):$(VERSION)

.PHONY: linux arm macos windows image push clean

linux:
	GOOS=linux GOARCH=amd64 go build -o bin/$(APP)-linux-amd64 main.go

arm:
	GOOS=linux GOARCH=arm64 go build -o bin/$(APP)-linux-arm64 main.go

macos-amd:
	GOOS=darwin GOARCH=amd64 go build -o bin/$(APP)-darwin-amd64 main.go

macos-arm:
	GOOS=darwin GOARCH=arm64 go build -o bin/$(APP)-darwin-arm64 main.go

windows:
	GOOS=windows GOARCH=amd64 go build -o bin/$(APP)-windows-amd64.exe main.go

image:
	docker buildx build --platform linux/amd64 \
		--build-arg TARGETOS=linux \
		--build-arg TARGETARCH=amd64 \
		-t $(IMAGE_TAG) .

image-arm:
	docker buildx build --platform linux/arm64 \
		--build-arg TARGETOS=linux \
		--build-arg TARGETARCH=arm64 \
		-t $(IMAGE_TAG)-arm64 .

push:
	docker push $(IMAGE_TAG)

clean:
	@echo "Cleaning binaries and Docker images..."
	@rm -rf bin/
	@docker rmi $(IMAGE_TAG) || true
	@docker rmi $(IMAGE_TAG)-arm64 || true
