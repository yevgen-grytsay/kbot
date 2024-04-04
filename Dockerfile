FROM golang:1.22 as builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /usr/src/app
COPY . .
RUN make build TARGETOS=$TARGETOS TARGETARCH=$TARGETARCH

FROM scratch
WORKDIR /
COPY --from=builder /usr/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./kbot" ]
