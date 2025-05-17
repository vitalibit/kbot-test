FROM quay.io/projectquay/golang:1.22 AS builder

WORKDIR /src
COPY . .

ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o app main.go

FROM scratch
WORKDIR /
COPY --from=builder /src/app .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./app"]
