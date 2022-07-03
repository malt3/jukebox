# Raspberry Pi / HifiBerry / shaiport-sync (AirPlay 2) Jukebox

## Prerequisites

- docker buildx with arm support
- make

## Build

```shell-session
make
```

## Installation

- Optional: download latest image from GitHub release. Can also be build from scratch.
    ```shell-session
    RASPBIAN_URL=...
    wget -L -O raspbian.zip "${RASPBIAN_URL}"
    unzip raspbian.zip
    unzip image.zip
    ```
- Insert and locate SD card (`/dev/sda` on my system, ensure to choose the correct blockdevice)
- Copy image to sd card
    ```shell-session
    SDCARD=/dev/sda
    find . -name "*Jukebox.img" | xargs -I{} dd if={} of="${SDCARD}" status=progress
    sync
    ```
- Optional: change hostname and soundcard
    ```shell-session
    SDCARD=/dev/sda
    HOSTNAME=myspeaker
    # see https://www.hifiberry.com/docs/software/configuring-linux-3-18-x/
    DTOVERLAY=hifiberry-dac
    # ensure the kernel finds the new partition scheme before mounting
    mkdir -p /mnt/root/
    mount "${SDCARD}2" /mnt/root
    mount "${SDCARD}1" /mnt/root/boot
    echo "${HOSTNAME}" > /mnt/root/etc/hostname
    sed -i "s/127.0.1.1		jukebox/127.0.1.1		${HOSTNAME}/" /mnt/root/etc/hosts
    sed -i "s/dtoverlay=hifiberry-.*/dtoverlay=${DTOVERLAY}/" /mnt/root/boot/config.txt
    umount /mnt/root/boot
    umount /mnt/root
    rmdir /mnt/root
    ```
- Insert SD card into raspberry pi and enjoy 🎧
