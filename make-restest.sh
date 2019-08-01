#!/bin/bash
#
# Run this shell script after you have run the command: "buildah unshare"
#
git clone https://github.com/bryonbaker/resttest.git
cd resttest
go build restest.go

container=$(buildah from scratch)
mnt=$(buildah mount $container)
mkdir $mnt/bin
mkdir $mnt/lib64
buildah config --workingdir /bin $container
buildah copy $container restest /bin/restest
buildah copy $container /lib64/libpthread.so.0 /lib64
buildah copy $container /lib64/libc.so.6 /lib64
buildah copy $container /lib64/ld-linux-x86-64.so.2 /lib64
buildah config --port 8000 $container
#
# This step is not working properly.
# Need to run with podman -p 8000:8000 --entrypoint /bin/restest restest:latest
buildah config --entrypoint /bin/restest $container
buildah commit --format docker $container restest:latest