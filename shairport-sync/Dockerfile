FROM debian:latest AS builder
RUN apt-get -qq update \
    && apt-get -q install --assume-yes debootstrap
ARG ARCH=armhf
ARG MIRROR=http://mirror.ox.ac.uk/sites/archive.raspbian.org/archive/raspbian/
ARG KEY=9165938D90FDDD2E
ARG SUITE=bullseye
RUN gpg --recv-key --keyserver hkps://keyserver.ubuntu.com "$KEY" && \
    gpg --export > /raspbian.gpg
RUN debootstrap --arch="$ARCH" --keyring=/raspbian.gpg --variant=minbase "$SUITE" /chroot "$MIRROR"
RUN chroot /chroot apt-get -q clean

FROM scratch as raspbian-base
COPY --from=builder /chroot /
CMD ["bash"]

FROM raspbian-base AS buildtools
RUN apt-get -qq update \
    && apt-get -q install --assume-yes --no-install-recommends \
    autoconf \
    automake \
    avahi-daemon \
    build-essential \
    git \
    libasound2-dev \
    libavahi-client-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libconfig-dev \
    libgcrypt-dev \
    libglib2.0-dev \
    libmosquitto-dev \
    libplist-dev \
    libpopt-dev \
    libsndfile1-dev \
    libsodium-dev \
    libsoxr-dev \
    libssl-dev \
    libtool \
    uuid-dev \
    xmltoman \
    xxd \
    && rm -rf /var/lib/apt/lists/*

FROM buildtools as alac
ARG DESTDIR=/dest
WORKDIR /build
RUN git clone https://github.com/mikebrady/alac
WORKDIR /build/alac
RUN autoreconf -fi && \
    ./configure && \
    make && \
    make install

FROM buildtools as nqptp
ARG DESTDIR=/dest
WORKDIR /build
RUN git clone https://github.com/mikebrady/nqptp.git
WORKDIR /build/nqptp
RUN autoreconf -fi && \
    ./configure --with-systemd-startup && \
    make -j && \
    make install

FROM buildtools as shairport-sync
ARG DESTDIR=/dest
COPY --from=alac /dest /
COPY --from=nqptp /dest /
WORKDIR /build
RUN git clone --branch development https://github.com/mikebrady/shairport-sync.git
WORKDIR /build/shairport-sync
RUN autoreconf -fi && \
    ./configure --sysconfdir=/etc \
    --with-alsa --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2  \
    --with-metadata --with-dummy --with-pipe --with-dbus-interface \
    --with-stdout --with-mpris-interface --with-mqtt-client \
    --with-apple-alac --with-convolution && \
    make -j && \
    make install

FROM scratch
COPY --from=alac /dest /
COPY --from=nqptp /dest /
COPY --from=shairport-sync /dest /
