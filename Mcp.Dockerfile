FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git

RUN go install github.com/humio/cli/cmd/humioctl@latest

FROM alpine:3.19 

RUN apk add --no-cache ca-certificates python3 py3-pip

RUN pip install --break-system-packages fastmcp
ENV HUMIO_ADDRESS=http://cloud.humio.com

COPY --from=builder /go/bin/humioctl /usr/local/bin/humioctl

COPY server.py /app/server.py

ENTRYPOINT ["python3", "/app/server.py"]
