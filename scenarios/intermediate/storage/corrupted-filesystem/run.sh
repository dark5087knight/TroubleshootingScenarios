#!/bin/bash


echo "---------------------------------------------"
echo -e "
Before you start the scenario, make sure to add a new disk to the machine with a size greater than 5 GB.

you had 2 partition one of them is ext4 aand the other is xfs.
suddnely when you run the machine and try to mount partitions you find that you can't mount them and access the data inside because of an error.
Check what is wrong, fix the issue, and read the files inside the recovered partitions.

1.linux filesystems (ext4, xfs)
2.superblock concept
3.inode concept
4.magic numbers
5.fsck.ext4 command
6.dumpe2fs command
7.xfs_info command
8.xfs_repair command
"
echo "---------------------------------------------"
read -p "If you are ready type 'y', if not type 'n': " CHOICE
if [[ "$CHOICE" == "y" ]]; then
        echo "OK lets goooooo"
    else
        echo "OK See you next time."
        exit
fi

#!/bin/bash
set -euo pipefail

DISK=""
MNT="/mnt"

fail() {
    echo "[ERROR] $1"
    exit 1
}

info() {
    echo "[INFO] $1"
}

### ROOT CHECK ###
[[ $EUID -eq 0 ]] || fail "Run this script as root"

### FIND DISK (sdb preferred) ###
if lsblk -dn -o NAME | grep -q "^sdb$"; then
    DISK="/dev/sdb"
elif lsblk -dn -o NAME | grep -q "^sdc$"; then
    DISK="/dev/sdc"
else
    echo "No disk found for the scenario."
    echo "Add a disk and verify it using lsblk."
    exit 1
fi

info "Selected disk: $DISK"

### ENSURE NOT OS DISK ###
ROOT_DISK=$(lsblk -no PKNAME "$(findmnt -n -o SOURCE /)")
[[ "/dev/$ROOT_DISK" != "$DISK" ]] || fail "$DISK is the OS disk. Aborting."

info "$DISK confirmed as non-OS disk"

### WIPE SIGNATURES ###
info "Wiping existing filesystem signatures"
wipefs -a "$DISK"

### PARTITION DISK ###
info "Creating MBR partition table"
parted -s "$DISK" mklabel msdos

info "Creating partitions"
parted -s "$DISK" mkpart primary ext4 1MiB 2GiB
parted -s "$DISK" mkpart primary xfs 2GiB 4GiB

partprobe "$DISK"
sleep 2

P1="${DISK}1"
P2="${DISK}2"

### FORMAT ###
info "Formatting partitions as ext4"
mkfs.ext4 -F "$P1"
mkfs.xfs -f "$P2"


### MOUNT FIRST PARTITION ###
info "Mounting first partition on $MNT"
mount "$P1" "$MNT"
echo "congratulation you solved the problem" > "$MNT/result.txt"
umount "$MNT"

### MOUNT SECOND PARTITION ###
info "Mounting second partition on $MNT"
mount "$P2" "$MNT"
echo "since you finished the problem head to the next keep going" > "$MNT/next.txt"
umount "$MNT"

### WRITE TO MBR ###

dd if=/dev/zero of="${DISK}1" bs=1024 count=4 
dd if=/dev/zero of="${DISK}2" bs=1024 count=4


reboot