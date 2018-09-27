# start a golang base image, version 1.11
FROM golang:1.11 as builder

#switch to our app directory
RUN mkdir -p /go/src/devdns
WORKDIR /go/src/devdns

#copy the source files
COPY main.go /go/src/devdns

#disable crosscompiling
ENV CGO_ENABLED=0

#compile linux only
ENV GOOS=linux

#build the binary with debug information removed
RUN go get . && go build  -ldflags '-w -s' -a -installsuffix cgo -o devdns

FROM scratch

COPY --from=builder /go/src/devdns/devdns devdns

CMD ["./devdns"]
