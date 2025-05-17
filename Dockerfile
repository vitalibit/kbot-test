FROM quay.io/projectquay/golang:1.22 AS build

WORKDIR /app
COPY . .

ARG TARGETOS
ARG TARGETARCH

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /tmp/app

FROM scratch
COPY --from=build /tmp/app /app
ENTRYPOINT ["/app"]
