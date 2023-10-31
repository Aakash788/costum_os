# Custom OS script

---

- first install requirements
    `sudo apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison`
- now alow executions
    `chmod x+ ./`
- then execute file in this order
    -kernel.sh
    -busybox.sh
    -initrd.sh
- for testing first try in virtual environment 

    - installing required pakages for virtuallization

        ` sudo apt install cpu-checker -y`
        `sudo apt-get install qemu-system`

- for making iso of this 
