APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY?=yevhenhrytsai
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS?=linux
# TARGETARCH=$(shell dpkg --print-architecture)
# TARGETARCH=arm64
TARGETARCH?=amd64

IMAGE_FULL_NAME=${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

.DEFAULT_GOAL=build

tools := go gofmt docker dive

$(tools):
	@which $@ > /dev/null


format: gofmt
	gofmt -s -w ./

lint: go
	go vet

test: go
	go test -v

get: go
	go get

#
# Build commands
#
build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

linux-arm64: go
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -o ./build/linux-arm64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

linux-amd64: go
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o ./build/linux-amd64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

windows-arm64: go
	CGO_ENABLED=0 GOOS=windows GOARCH=arm64 go build -v -o ./build/windows-arm64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

windows-amd64: go
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o ./build/windows-amd64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

macos-amd64: go
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o ./build/macos-amd64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

macos-arm64: go
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -o ./build/macos-arm64/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

build-all: linux-arm64 linux-amd64 windows-arm64 windows-amd64 macos-amd64 macos-arm64

# 
# Docker commands
#
image-tag:
	echo ${IMAGE_FULL_NAME}

image: docker
	echo "Selected OS: ${TARGETOS}"
	echo "Selected Arch: ${TARGETARCH}"
	docker build . -t ${IMAGE_FULL_NAME} --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS}

push: diveci
	docker push ${IMAGE_FULL_NAME}

diveci: dive
	dive --ci --lowestEfficiency=0.9 ${IMAGE_FULL_NAME}

#
# Misc
#
clean:
	@rm -f kbot
	@rm -rf build
	@docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
