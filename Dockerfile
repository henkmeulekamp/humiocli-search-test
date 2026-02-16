FROM golang:1.21-alpine AS builder

RUN apk add --no-cache unzip

ADD https://github.com/humio/cli/archive/refs/tags/v0.39.0.zip /tmp/cli.zip
RUN unzip /tmp/cli.zip -d /tmp && \
    cd /tmp/cli-0.39.0 && \
    go build -o /usr/local/bin/humioctl ./cmd/humioctl

FROM alpine:3.19

RUN apk add --no-cache ca-certificates

COPY --from=builder /usr/local/bin/humioctl /usr/local/bin/humioctl

ENTRYPOINT ["humioctl", "search", "--repo=ezp_developer"]
