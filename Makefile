CURRENT_REVISION = $(shell git rev-parse --short HEAD)
BUILD_LDFLAGS = "-X github.com/Songmu/goxz.revision=$(CURRENT_REVISION)"
ifdef update
  u=-u
endif

GO ?= GO111MODULE=on go

devel-deps:
	$(GO) get ${u} github.com/golang/lint/golint
	$(GO) get ${u} github.com/mattn/goveralls
	$(GO) get ${u} github.com/motemen/gobump/cmd/gobump
	$(GO) get ${u} github.com/Songmu/goxz/cmd/goxz
	$(GO) get ${u} github.com/Songmu/ghch/cmd/ghch
	$(GO) get ${u} github.com/tcnksm/ghr

test:
	$(GO) test

lint: devel-deps
	$(GO) vet
	golint -set_exit_status

cover: devel-deps
	goveralls

build:
	$(GO) build -ldflags=$(BUILD_LDFLAGS) ./cmd/goxz

crossbuild: devel-deps
	$(eval ver = $(shell gobump show -r))
	GO111MODULE=on goxz -pv=v$(ver) -build-ldflags=$(BUILD_LDFLAGS) \
	  -d=./dist/v$(ver) ./cmd/goxz

release:
	_tools/releng
	_tools/upload_artifacts

.PHONY: test devel-deps lint cover crossbuild release
