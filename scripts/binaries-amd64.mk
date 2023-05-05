define DOCKERFILE_AMD64_BINARIES

FROM $(BASE_IMAGE)
RUN apk add --no-cache zip make git tar ca-certificates && \
    update-ca-certificates
WORKDIR /s
COPY go.mod go.sum ./
RUN go mod download
COPY . ./

ENV VERSION $(shell git describe --tags)
ENV CGO_ENABLED 0
RUN rm -rf binaries
RUN mkdir tmp binaries
RUN cp mediamtx.yml LICENSE tmp/

RUN GOOS=linux GOARCH=amd64 go build -ldflags "-X github.com/aler9/mediamtx/internal/core.version=$$VERSION" -o tmp/mediamtx
RUN tar -C tmp -czf binaries/mediamtx_$${VERSION}_linux_amd64.tar.gz --owner=0 --group=0 mediamtx mediamtx.yml LICENSE

endef
export DOCKERFILE_AMD64_BINARIES

binaries-amd64:
	echo "$$DOCKERFILE_AMD64_BINARIES" | DOCKER_BUILDKIT=1 docker build . -f - -t temp
	docker run --rm -v $(PWD):/out \
	temp sh -c "rm -rf /out/binaries && cp -r /s/binaries /out/"
