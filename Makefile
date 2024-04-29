IMAGE_NAME?=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY?=yevhenhrytsai
VERSION_TAG=$(shell git describe --tags --abbrev=0)
VERSION_REV=$(shell git rev-parse --short HEAD)
TARGETOS?=linux
# TARGETARCH=$(shell dpkg --print-architecture)
# TARGETARCH=arm64
TARGETARCH?=amd64

# ALL_OS = linux darwin windows
# ifeq ($(TARGETOS),all)
# 	TARGETOS_LIST=$(ALL_OS)
# else
# 	TARGETOS_LIST=$(TARGETOS)
# endif
# build_jobs := $(foreach os,$(TARGETOS_LIST),build-$(os)-$(TARGETARCH))
# TARGETOS := $(firstword $(TARGETOS_LIST))

# Fail fast
ifndef VERSION_TAG
$(error VERSION_TAG is not set)
endif

ifndef VERSION_REV
$(error VERSION_TAG is not set)
endif

ifndef TARGETOS
$(error TARGETOS is not set)
endif

ifndef TARGETARCH
$(error TARGETARCH is not set)
endif

VERSION=$(VERSION_TAG)-$(VERSION_REV)
IMAGE_FULL_NAME=$(REGISTRY)/$(IMAGE_NAME):$(VERSION)-$(TARGETOS)-$(TARGETARCH)

.DEFAULT_GOAL=build


format:
	gofmt -s -w ./

lint:
	go vet

test:
	go test -v ./...

get:
	go get

#
# Build commands
#
build: format get
	@echo "Selected OS: ${TARGETOS}"
	@echo "Selected Arch: ${TARGETARCH}"
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
		go build -v -o kbot \
		-ldflags="-X="github.com/yevgen-grytsay/kbot/app.AppVersion=${VERSION}

# build: get
# 	@echo "Selected OS: ${TARGETOS_LIST}"
# 	@echo "Selected Arch: ${TARGETARCH}"
# 	$(foreach os, $(TARGETOS_LIST), \
# 		CGO_ENABLED=0 GOOS=${os} GOARCH=${TARGETARCH} go build -v -o build/${os}-${TARGETARCH}/kbot -ldflags="-X="github.com/yevgen-grytsay/kbot/app.AppVersion=${VERSION}; \
# 	)

# @$(foreach os, $(TARGETOS), \
# 	echo $(os); \
# )

# 
# Docker commands
#
image-tag:
	@echo ${IMAGE_FULL_NAME}

image:
	@echo "Selected OS: ${TARGETOS}"
	@echo "Selected Arch: ${TARGETARCH}"
	docker build . -t ${IMAGE_FULL_NAME} --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS}

push:
	docker push ${IMAGE_FULL_NAME}

dive-ci:
	dive --ci --lowestEfficiency=0.9 ${IMAGE_FULL_NAME}

dive:
	dive ${IMAGE_FULL_NAME}

.PHONY: helm
helm:
	helm package ./helm

#
# Misc
#
clean:
	@rm -rf ./build
	@docker rmi -f ${IMAGE_FULL_NAME}
