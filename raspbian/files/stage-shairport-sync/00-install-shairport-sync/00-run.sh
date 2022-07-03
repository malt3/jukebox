#!/bin/bash -e

tar -xvf files/shairport-sync.tar -C "${ROOTFS_DIR}"
mv "${ROOTFS_DIR}/shairport-sync.service" "${ROOTFS_DIR}/usr/local/lib/systemd/system/shairport-sync.service"
