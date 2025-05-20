# task3.5

## Overview

This project demonstrates how to cross-compile a Go application for multiple platforms using Makefile and a multi-stage Dockerfile, as well as how to build minimal Docker images for different Linux architectures. Docker images are built for `linux/amd64` and `linux/arm64` only, and may be published to any custom container registry (for example, `quay.io`).

---

## Repository Structure

- `Makefile` — Build scripts for different platforms/architectures, Docker image build/push
- `Dockerfile` — Multi-stage Dockerfile for Linux containers with multi-arch support
- `README.md` — This file

---

## Building Binaries for Different Platforms

The Makefile supports generating binaries for various operating systems and CPU architectures:

- `make linux-amd64` — Build Linux/amd64 binary: `build/test-app-linux-amd64`
- `make linux-arm64` — Build Linux/arm64 binary: `build/test-app-linux-arm64`
- `make darwin-amd64` — Build macOS (Intel): `build/test-app-darwin-amd64`
- `make darwin-arm64` — Build macOS (Apple Silicon): `build/test-app-darwin-arm64`
- `make windows-amd64` — Build Windows/amd64 binary: `build/test-app-windows-amd64.exe`

All binaries are placed in the `build/` directory.

---

## Building Docker Images

Multi-architecture Docker images are supported for Linux platforms:

- `make image` — Build and tag Docker images for all supported Linux platforms using Buildx.
- By default, images are tagged as `<registry>/<app>:<os>_<arch>`, e.g. `quay.io/projectquay/test-app:linux_amd64`.

To build for all supported platforms:

```sh
make image
```

---

## Building Docker Images

The REPO variable defaults to quay.io/projectquay, but you can override it:

```sh
make image REPO=ghcr.io/yourusername
```

The APP variable defaults to test-app.

---

## Platform Support Notes

`Linux Containers`: Only linux/amd64 and linux/arm64 Docker images are built and supported.

`macOS/Windows`: Only native binaries are generated; you cannot build Docker images for macOS or Windows.

For local testing on Mac M1/M2, use the ARM binary or the ARM Docker image.

---

## Cleaning Up

Remove all built binaries and images:

```sh
make clean
```

---

## Example Usage

Build and run the Linux/amd64 binary:

```sh
make linux-amd64
./build/test-app-linux-amd64
```

Build and run the Linux/amd64 Docker image:

```sh
make image
docker run --rm quay.io/projectquay/test-app:linux_amd64
```

Build the macOS ARM binary:

```sh
make darwin-arm64
./build/test-app-darwin-arm64
```

## Key Points

- Cross-compilation is automated via Makefile targets.
- Docker images are always minimal, using multi-stage builds (`scratch` base).
- Only Linux containers are supported for image builds, matching standard Docker limitations.
- The Makefile can be customized for your own registry and project name.