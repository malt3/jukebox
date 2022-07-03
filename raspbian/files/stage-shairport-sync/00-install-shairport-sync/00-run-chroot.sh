#!/bin/bash -e

systemctl enable nqptp
systemctl enable shairport-sync.service
systemctl enable avahi-daemon.service
rm /etc/ld.so.cache
ldconfig
getent group shairport-sync &>/dev/null || groupadd -r shairport-sync >/dev/null
getent passwd shairport-sync &> /dev/null || useradd -r -M -g shairport-sync -s /usr/bin/nologin -G audio shairport-sync >/dev/null
