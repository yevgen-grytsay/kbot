APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY=yevhenhrytsai
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
# TARGETARCH=$(shell dpkg --print-architecture)
# TARGETARCH=arm64
TARGETARCH=amd64

format:
	gofmt -s -w ./

lint:
	go vet

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

image-tag:
	echo ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
