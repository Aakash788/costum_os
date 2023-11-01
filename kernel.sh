#!/bin/bash
KERNEL_VERSION=5.15.6

KERNEL_MAJOR=$(echo $KERNEL_VERSION | cut -d. -f1)
mkdir src
cd src || exit
# Download kernel source code
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v"$KERNEL_MAJOR".x/linux-"$KERNEL_VERSION".tar.gz
tar -xvf linux-$KERNEL_VERSION.tar.gz
(
  cd linux-$KERNEL_VERSION || exit
  make defconfig
  make -j"$(nproc)" && make modules_install && make install || exit 1
)

