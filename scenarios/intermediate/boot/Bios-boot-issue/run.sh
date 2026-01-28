#!/bin/bash


echo "---------------------------------------------"
echo -e "
yor machine isn't booting, why?
maybe it didn't startup properly and somthing is wrong with bootloader, dignose and fix it.
But it's Better if you sreach and and learn about these Concepts
1-Linx Booting Process
2-GRUB Bootloader
3-how the operating system devices is structured
4-xxd (command)"
echo "---------------------------------------------"
read -p "If you are ready type 'y', if not type 'n': " CHOICE
if [[ "$CHOICE" == "y" ]]; then
        echo "OK lets goooooo"
    else
        echo "OK See you next time."
        exit
fi
BOOTDEV=$( findmnt -nf /boot | awk '{print $2}' | sed 's/[0-9]*$//' )
dd  if=/dev/zero of=$BOOTDEV bs=446 count=1 >/dev/null
reboot