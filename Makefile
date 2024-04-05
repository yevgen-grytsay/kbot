APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY?=yevhenhrytsai
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS?=linux
# TARGETARCH=$(shell dpkg --print-architecture)
# TARGETARCH=arm64
TARGETARCH?=amd64

format:
	gofmt -s -w ./

lint:
	go vet

test:
	go test -v

get:
	go get

#
# Build commands
#
build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

linux-arm64:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -o ./build/linux-arm64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

linux-amd64:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o ./build/linux-amd64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

windows-arm64:
	CGO_ENABLED=0 GOOS=windows GOARCH=arm64 go build -v -o ./build/windows-arm64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

windows-amd64:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o ./build/windows-amd64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

macos-amd64:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o ./build/macos-amd64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

macos-arm64:
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -o ./build/macos-arm64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

build-all: linux-arm64 linux-amd64 windows-arm64 windows-amd64 macos-amd64 macos-arm64

# 
# Docker commands
#
image-tag:
	echo ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

image:
	echo "Selected OS: ${TARGETOS}"
	echo "Selected Arch: ${TARGETARCH}"
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}


#
# Misc
#
clean:
	rm -f kbot
	rm -rf build
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
