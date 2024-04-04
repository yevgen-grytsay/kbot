VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=$(shell dpkg --print-architecture)

format:
	gofmt -s -w ./

lint:
	go vet

test:
	go test -v

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf kbot
