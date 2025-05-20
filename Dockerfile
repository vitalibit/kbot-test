FROM quay.io/projectquay/golang:1.22 AS builder

WORKDIR /app
COPY . .

ARG TARGETOS
ARG TARGETARCH

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /tmp/app

FROM scratch
COPY --from=builder /tmp/app /app
ENTRYPOINT ["/app"]
