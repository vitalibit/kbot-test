# task3.5

## Overview

This repository demonstrates cross-platform building and testing of a Go application using Docker and Makefile for various operating systems and architectures. It also provides publishing to an alternative container registry (such as GitHub Container Registry — ghcr.io).

---

## Repository Structure

- `main.go` — Example application (Hello, World!)
- `Makefile` — Build scripts for different platforms/architectures, Docker image build/push
- `Dockerfile` — Multi-stage Dockerfile for Linux containers with multi-arch support
- `README.md` — This file

---

## Building Binaries for Different Platforms

Makefile targets are implemented to build native binaries for all popular platforms:

- `make linux` — Binary for Linux (amd64)
- `make arm` — Binary for Linux (arm64)
- `make macos-amd` — Binary for macOS (Intel, amd64)
- `make macos-arm` — Binary for macOS (Apple Silicon, arm64)
- `make windows` — Binary for Windows (amd64)

All binaries are saved in the `bin/` directory with appropriate suffixes.

---

## Building Docker Images for Different Architectures

The Dockerfile and Makefile support multi-architecture builds for Linux:

- `make image` — Build Docker image for Linux/amd64
- `make image-arm` — Build Docker image for Linux/arm64

The built image can be run on any Linux system with the corresponding architecture (for example, servers on amd64, Raspberry Pi, MacBook with ARM64 via Docker).

---

## Why Only Linux/amd64 and Linux/arm64 Containers?

Docker officially supports **only Linux containers** on amd64, arm64, and some other architectures.  
Containers for macOS (darwin) or Windows are not supported and do not exist in public registries, even if a binary is built for those platforms.

- **macOS/arm64:** Only a native binary can be built, not a container.
- **Windows:** Only a native binary can be built; containers are only possible on Windows Server with special Docker modes, which are outside the scope of most CI/CD and test workflows.

---

## How to Test on Mac (M1/M2) or Windows?

- **On Mac M1/M2:**  
  Use either the Linux/arm64 Docker image (`make image-arm`), or run the native binary (`make macos-arm`) outside the container.
- **On Windows:**  
  Use the binary (`make windows`) built for Windows/amd64.

---

## Alternative Container Registry

For publishing Docker images, **GitHub Container Registry** (`ghcr.io`) is used  
(any other non-DockerHub registry — quay.io, GCR, etc. — may be used as well).  
This helps avoid DockerHub rate limits and licensing issues.

- In the Makefile, the `REGISTRY` variable defaults to `ghcr.io/yourusername`
- The image tag is set via the `VERSION` variable (default is `latest`)

---

## Key Makefile Commands

```sh
make linux        # build bin/task3-linux-amd64
make arm          # build bin/task3-linux-arm64
make macos-amd    # build bin/task3-darwin-amd64
make macos-arm    # build bin/task3-darwin-arm64
make windows      # build bin/task3-windows-amd64.exe

make image        # build docker image for linux/amd64
make image-arm    # build docker image for linux/arm64

make push         # push docker image (amd64) to ghcr.io
make clean        # remove all binaries and docker images
```

## How to Verify

1. Build the required binary:

```sh
make linux
./bin/task3-linux-amd64
```

2. Build and run the Docker image:

```sh
make image
docker run --rm ghcr.io/yourusername/task3:latest
```

3. For Mac ARM:

```sh
make macos-arm
./bin/task3-darwin-arm64
```

## Cleaning Up

```sh
make clean
# removes all binaries and Docker images to keep your workspace tidy.
```

---

## Important

- **Containers are available only for Linux (amd64, arm64), reflecting real Docker limitations.**
- **macOS and Windows are supported only via native binaries, which must be run outside containers.**
- **Alternative container registries are used for publishing and CI automation.**
