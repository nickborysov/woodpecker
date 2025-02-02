GO_VERSION=1.12.4
export GO111MODULE=off
GOFILES_NOVENDOR = $(shell find . -type f -name '*.go' -not -path "./vendor/*" -not -path "./.git/*")

DOCKER_RUN?=
_with-docker:
	$(eval DOCKER_RUN=docker run --rm -v $(shell pwd)/../../..:/go/src/ -v $(shell pwd)/build:/build -w / golang:$(GO_VERSION))

all: deps build

deps:
	go get -u golang.org/x/net/context
	go get -u golang.org/x/net/context/ctxhttp
	go get -u github.com/golang/protobuf/proto
	go get -u github.com/golang/protobuf/protoc-gen-go

formatcheck:
	([ -z "$(shell gofmt -d $(GOFILES_NOVENDOR))" ]) || (echo "Source is unformatted"; exit 1)

format:
	@gofmt -w ${GOFILES_NOVENDOR}

test-agent:
	$(DOCKER_RUN) go test -race -timeout 30s github.com/laszlocph/woodpecker/cmd/drone-agent $(go list ./... | grep -v /vendor/)

test-server:
	$(DOCKER_RUN) go test -race -timeout 30s github.com/laszlocph/woodpecker/cmd/drone-server

test-lib:
	$(DOCKER_RUN) go test -race -timeout 30s $(shell go list ./... | grep -v '/cmd/')

test: test-lib test-agent test-server

build-agent:
	$(DOCKER_RUN) go build -o build/drone-agent github.com/laszlocph/woodpecker/cmd/drone-agent

build-server:
	$(DOCKER_RUN) go build -o build/drone-server github.com/laszlocph/woodpecker/cmd/drone-server

build: build-agent build-server

install:
	go install github.com/laszlocph/woodpecker/cmd/drone-agent
	go install github.com/laszlocph/woodpecker/cmd/drone-server