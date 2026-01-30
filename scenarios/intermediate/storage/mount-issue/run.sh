#!/bin/bash


echo "---------------------------------------------"
echo -e "
You had a disk that you were using as a storage disk on your machine, but it became corrupted and you removed it.
After that, the machine is not starting up properly.
Read the logs, diagnose the issue, and fix it.
It is recommended that you research and learn about the following concepts beforehand:

1.mount command
2.How mounting works in Linux
3.fstab file
4.Disk UUIDs and labels
"
echo "---------------------------------------------"
read -p "If you are ready type 'y', if not type 'n': " CHOICE
if [[ "$CHOICE" == "y" ]]; then
        echo "OK lets goooooo"
    else
        echo "OK See you next time."
        exit
fi
printf "\n/dev/sdb3   /mnt   ext4   defaults   0 0\n" | sudo tee -a /etc/fstab &> /dev/null
systemctl daemon-reload
reboot