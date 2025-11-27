FROM golang:1.22 AS builder

ARG KANIKO_VERSION=v1.23.2
ENV CGO_ENABLED=0

RUN git clone --depth 1 --branch ${KANIKO_VERSION} https://github.com/GoogleContainerTools/kaniko.git /kaniko-src
WORKDIR /kaniko-src

RUN go mod download
RUN go build -o /kaniko/executor ./cmd/executor

FROM busybox:1.36

COPY --from=builder /kaniko/executor /kaniko/executor
RUN mkdir -p /busybox \
  && ln -sf /bin/sh /busybox/sh

ENTRYPOINT ["/busybox/sh", "-c"]
