#!/bin/bash

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
