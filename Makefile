VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

build: format
	go build -v -o kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=${VERSION}
