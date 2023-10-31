#!/bin/bash
BUSYBOX_VERSION=1.34.1

cd src

# Download busybox source code
    wget https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2.
    tar -xvf busybox-$BUSYBOX_VERSION.tar.bz2
    cd busybox-$BUSYBOX_VERSION
        make defconfig
        sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
        make -j$(nproc) || exit 1
    cd ..

cd ..