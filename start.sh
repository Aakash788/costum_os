#!/bin/bash
qemu-system-x86_64 -kernel bzImage -initrd initrd.img -append "console=ttyS0" -nographic
