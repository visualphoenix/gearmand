FROM alpine:latest

RUN /usr/sbin/adduser -u 12321 -h /go -s /sbin/nologin -g "Golang User" -D gobot
WORKDIR /go
USER gobot

ARG repo
ENV EXECUTABLE=${repo:-repo}-amd64

ADD build/$EXECUTABLE /go/
CMD ["sh", "-c", "./$EXECUTABLE"]
