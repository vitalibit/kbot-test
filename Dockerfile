FROM quay.io/projectquay/golang:1.22 AS build

WORKDIR /app
COPY . .

ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o app main.go

FROM scratch
COPY --from=build /app/app /app
ENTRYPOINT ["/app"]
