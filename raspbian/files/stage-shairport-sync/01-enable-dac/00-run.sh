#!/bin/bash -e

install files/asound.conf "${ROOTFS_DIR}/etc/asound.conf"
cat files/config.txt >> "${ROOTFS_DIR}/boot/config.txt"
sed -i 's/dtparam=audio=on//' "${ROOTFS_DIR}/boot/config.txt"
sed -i 's/dtoverlay=vc4-kms-v3d/dtoverlay=vc4-kms-v3d,audio=off,audio1=off/' "${ROOTFS_DIR}/boot/config.txt"
