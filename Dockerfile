FROM golang:1.22 as builder

WORKDIR /usr/src/app
COPY . .
RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /usr/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./kbot" ]
