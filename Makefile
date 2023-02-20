BIN := pinger
VERSION := $$(make -s show-version)
CURRENT_REVISION := $(shell git rev-parse --short HEAD)
BUILD_LDFLAGS := "-s -w -X main.revision=$(CURRENT_REVISION)"
GOBIN ?= $(shell go env GOPATH)/bin
export GO111MODULE=on

.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: clean build ## clean and build

.PHONY: build
build: ## build
	go build -ldflags=$(BUILD_LDFLAGS) -o $(BIN) .

.PHONY: install
install: ## install
	go install -ldflags=$(BUILD_LDFLAGS) .

.PHONY: show-version
show-version: $(GOBIN)/gobump ## show-version
	@gobump show -r .

$(GOBIN)/gobump:
	@cd && go install github.com/x-motemen/gobump/cmd/gobump

$(GOBIN)/ghch:
	@cd && go install github.com/Songmu/ghch/cmd/ghch

$(GOBIN)/golint:
	@cd && go install golang.org/x/lint/golint

$(GOBIN)/gosec:
	@cd && go install github.com/securego/gosec/v2/cmd/gosec

.PHONY: cross
cross: $(GOBIN)/goxz ## build for cross platforms
	goxz -arch amd64,arm64 -os linux,darwin -n $(BIN) -pv=v$(VERSION) -build-ldflags=$(BUILD_LDFLAGS) -trimpath .
	goxz -arch amd64       -os windows      -n $(BIN) -pv=v$(VERSION) -build-ldflags=$(BUILD_LDFLAGS) -trimpath .

$(GOBIN)/goxz:
	cd && go install github.com/Songmu/goxz/cmd/goxz

.PHONY: test
test: build ## test
	go test -v ./...

.PHONY: lint
lint: $(GOBIN)/golint ## run golint
	golint -set_exit_status ./...

.PHONY: security
security: $(GOBIN)/gosec ## run gosec
	gosec ./...

.PHONY: clean
clean: ## clean
	rm -rf $(BIN) goxz
	go clean

.PHONY: bump
bump: $(GOBIN)/gobump $(GOBIN)/ghch ## release new version
ifneq ($(shell git status --porcelain),)
	$(error git workspace is dirty)
endif
ifneq ($(shell git rev-parse --abbrev-ref HEAD),master)
	$(error current branch is not master)
endif
	@gobump up -w .
	ghch -w -N "v$(VERSION)"
	git commit -am "bump up version to $(VERSION)"
	git tag "v$(VERSION)"
	git push origin master
	git push origin "refs/tags/v$(VERSION)"

.PHONY: upload
upload: $(GOBIN)/ghr ## upload
	ghr "v$(VERSION)" goxz

$(GOBIN)/ghr:
	cd && go install github.com/tcnksm/ghr
