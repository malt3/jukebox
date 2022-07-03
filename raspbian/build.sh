#!/bin/bash -xe

BUILDDIR=$(realpath $(pwd)/build)
SHAIRPORT_TAR=$(realpath $(pwd)/../shairport-sync/shairport-sync.tar)
IMAGEPATH=$(realpath $(pwd)/image.zip)
BASE_IMAGE=i386/debian:bullseye

prepare () {
    rm -rf "${BUILDDIR}"
    mkdir -p "${BUILDDIR}"
    git clone --depth 1 https://github.com/RPi-Distro/pi-gen "${BUILDDIR}"
    install -m 644 files/config "${BUILDDIR}"
    cp -r files/stage-shairport-sync "${BUILDDIR}/"
    install -m 644 -D "${SHAIRPORT_TAR}" "${BUILDDIR}/stage-shairport-sync/00-install-shairport-sync/files/shairport-sync.tar"
}

containerimage () {
    cd "${BUILDDIR}" && docker buildx build --build-arg BASE_IMAGE=${BASE_IMAGE} -t pi-gen --load .
}

build () {
    cd "${BUILDDIR}" && ./build-docker.sh
    find "${BUILDDIR}/deploy/" -name "image_*Jukebox.zip" | xargs -I{} cp {} "${IMAGEPATH}"
}

prepare
containerimage
build
