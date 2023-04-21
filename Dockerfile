FROM alpine:3.17
ADD binaries/mediamtx_v0.22.2_linux_amd64.tar.gz /
ENTRYPOINT [ "/mediamtx" ]
