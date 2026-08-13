ARG GOLANG_VERSION="1.25"

FROM golang:$GOLANG_VERSION-alpine as builder
RUN apk --no-cache add tzdata
WORKDIR /go/src/github.com/serjs/socks5
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-s' -o ./socks5

FROM gcr.io/distroless/static:nonroot
COPY --from=builder /go/src/github.com/serjs/socks5/socks5 /
HEALTHCHECK --interval=30s --timeout=3s --retries=3 --start-period=10s CMD ["/socks5", "--healthcheck"]
ENTRYPOINT ["/socks5"]
