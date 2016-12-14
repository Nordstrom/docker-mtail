image_repo := quay.io/nordstrom
image_name := mtail
mtail_path := $(GOPATH)/src/github.com/google/mtail
mtail_version := $(shell git rev-parse --short --git-dir=$(mtail_path) HEAD)
image_version := $(mtail_version)-1

ifdef http_proxy
build_args += --build-arg=http_proxy=$(http_proxy)
build_args += --build-arg=https_proxy=$(http_proxy)
build_args += --build-arg=HTTP_PROXY=$(http_proxy)
build_args += --build-arg=HTTPS_PROXY=$(http_proxy)
endif

image/push: image/tag
	docker push $(image_repo)/$(image_name):$(image_version)

image/tag: image/build
	docker tag $(image_name) $(image_repo)/$(image_name):$(image_version)

image/build: build/mtail
	docker build $(build_args) -t $(image_name) .

build/mtail: $(GOPATH)/src/github.com/google/mtail
	GOOS=linux GOARCH=amd64 go build -o $@ github.com/google/mtail

$(GOPATH)/src/github.com/google/mtail:
	go get -d github.com/google/mtail
	cd $@; make install_deps
	@# go get golang.org/x/tools/cmd/goyacc
