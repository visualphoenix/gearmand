FROM golang:alpine

RUN apk add --no-cache file git gcc libc-dev

ENV CGO_ENABLED=1 BUILD_FLAGS="-v -ldflags '-s -w -linkmode \"external\" -extldflags \"--static\"'"

ARG username
ARG repo
ENV username=${username:-$username} repo=${repo:-$repo}
COPY bench /go/src/github.com/$username/$repo/bench
COPY common /go/src/github.com/$username/$repo/common
COPY server /go/src/github.com/$username/$repo/server
COPY storage /go/src/github.com/$username/$repo/storage
COPY vendor /go/src/github.com/$username/$repo/vendor
COPY gearmand.go /go/src/github.com/$username/$repo/gearmand.go
WORKDIR /go/src/github.com/$username/$repo

ENV username=${username:-$username} repo=${repo:-$repo} GOPATH=/go:/go/src/github.com/$username/$repo/vendor
RUN set -x \
 && eval "GOARCH=amd64 go build $BUILD_FLAGS -o /go/bin/$repo-amd64" \
 && file /go/bin/$repo-amd64

RUN file /go/bin/$repo-*
