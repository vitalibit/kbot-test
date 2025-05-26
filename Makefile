REPO      ?= quay.io/projectquay
APP       ?= test-app
BINDIR    ?= build

PLATFORMS = linux-amd64 linux-arm64 darwin-amd64 darwin-arm64 windows-amd64

.DEFAULT_GOAL := all

.PHONY: all clean $(PLATFORMS) image

all: $(PLATFORMS)

$(BINDIR):
	mkdir -p $(BINDIR)

linux-amd64: $(BINDIR)
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o $(BINDIR)/$(APP)-linux-amd64 .

linux-arm64: $(BINDIR)
	GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o $(BINDIR)/$(APP)-linux-arm64 .

darwin-amd64: $(BINDIR)
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -o $(BINDIR)/$(APP)-darwin-amd64 .

darwin-arm64: $(BINDIR)
	GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 go build -o $(BINDIR)/$(APP)-darwin-arm64 .

windows-amd64: $(BINDIR)
	GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o $(BINDIR)/$(APP)-windows-amd64.exe .

image:
	docker buildx build \
		--platform=linux/amd64 \
		--build-arg TARGETOS=linux \
		--build-arg TARGETARCH=amd64 \
		--output type=docker \
		--tag $(REPO)/$(APP):linux_amd64 \
		.
version:
	docker buildx version
clean: version
	rm -rf $(BINDIR)
	docker rmi $(REPO)/$(APP):linux_amd64
