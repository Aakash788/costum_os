#!/bin/bash

KERNEL_VERSION=5.15.6
BUSYBOX_VERSION=1.34.1

KERNEL_MAJOR=$(echo $KERNEL_VERSION | cut -d. -f1)
mkdir src
cd src
# Download kernel source code
    wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$KERNEL_MAJOR.x/$KERNEL_VERSION.tar.gz
    tar -xvf linux-$KERNEL_VERSION.tar.gz
    cd linux-$KERNEL_VERSION
        make defconfig
        make -j$(nproc) || exit 1
    cd..

    # Download busybox source code
    wget https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2.
    tar -xvf busybox-$BUSYBOX_VERSION.tar.bz2
    cd busybox-$BUSYBOX_VERSION
        make defconfig
        sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
        make -j$(nproc) || exit 1
    cd ..

cd ..

cp /src/linux-$KERNEL_VERSION/arch/x86_64/boot/bzImage ./
# initrd
mkdir initrd
cd initrd
    mkdir -p bin dev proc sys
        cd bin
            cp ../../src/busybox-$BUSYBOX_VERSION/busybox ./
            for prog in  $(./busybox --list); do
                ln -s /bin/busybox ./$prog
            done            
        cd ..
    echo '#!/bin/sh' > init
    echo 'mount -t sysfs sysfs /sys' >> init
    echo 'mount -t proc proc /proc' >> init
    echo 'mount -t devtmpfs udev /dev' >> init
    echo 'sysctl -w kernel.printk="2 4 1 7"' >> init
    echo 'clear' >> init
    echo 'exec /bin/sh' >> init
    echo 'poweroff -f' >> init
    
    chmod -R 777 .

    find . | cpio -o -H newc > ../initrd.img


cd ..    
    qemu-system-x86_64 -kernel bzImage -initrd initrd.img -append "console=ttyS0" -nographic
