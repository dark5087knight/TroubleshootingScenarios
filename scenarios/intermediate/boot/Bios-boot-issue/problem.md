# GRUB Bootloader Missing / BIOS Cannot Boot Linux

## Overview

Sometimes the BIOS cannot boot an operating system because it cannot find valid boot information.
In Linux systems, this usually happens when the GRUB bootloader is missing or corrupted.
As a result, the BIOS assumes that no operating system exists on the disk, even though Linux is properly installed.

---

## Symptoms

The most common signs of this problem include:

* The BIOS fails to detect a bootable operating system.
* The system stops at the BIOS or boot menu.
* Messages such as *“No bootable device found”* or similar errors appear.

---

## When Can This Problem Happen?

This issue commonly occurs in the following situations:

* The system is forcibly shut down during the boot process.
* The first sector of the boot disk (MBR / boot sector) becomes corrupted.
* Accidental overwriting of bootloader data.
* Disk-related errors or improper disk operations.

---

## Environment

* **Operating System:** Linux (BIOS-based boot systems)
* **Service / Application:** GRUB Bootloader
* **User Privileges Required:**
  No OS-level privileges are required, but **physical access** to the machine is necessary.

---

## Tools Used to Simulate the Problem

The problem can be simulated by erasing the GRUB boot record located in the first **446 bytes** of the boot disk, which contains bootloader code.

**Tools / Commands used:**

* `dd`

---

## Root Cause

The root cause of this issue is the corruption or removal of the GRUB bootloader from the boot disk.
Without GRUB, the BIOS cannot locate instructions to load the operating system kernel, making the disk appear non-bootable.

---

## How to Fix the Problem

Follow these steps to restore the bootloader:

1. Ensure you have **physical access** to the affected machine or server.
2. Obtain a bootable installation image (ISO) of the **same Linux distribution** installed on the system.
3. Boot the system using this image.
4. Enter **Rescue Mode** when prompted.
5. Choose *Continue* or option **1** after the rescue environment finishes loading.
6. Verify that the system root is mounted under `/mnt/sysimg`.
7. Change root into the installed system:

   ```bash
   chroot /mnt/sysimg
   ```
8. Identify the disk containing the `/boot` partition (commonly `/dev/sda`):

   ```bash
   mount
   ```
9. Reinstall GRUB on the correct disk:

   ```bash
   grub2-install /dev/sda
   ```
10. If the installation completes successfully, exit the chroot environment:

    ```bash
    exit
    ```
11. Reboot the system:

    ```bash
    reboot
    ```

---

## Verification

After rebooting:

* The BIOS should successfully detect the operating system.
* GRUB menu should appear.
* The system should boot normally into Linux.

---

## Prevention Tips

* Avoid forcing shutdowns during boot.
* Backup the MBR/boot sector regularly.
* Test new bootloader configurations in a VM before applying.
* Monitor disk health to prevent corruption.
* Document any changes to the bootloader or partitions.

---

## Resources

Helpful references:

* [https://man7.org/linux/man-pages/](https://man7.org/linux/man-pages/)
* [https://www.kernel.org/doc/](https://www.kernel.org/doc/)
* [https://www.gnu.org/software/grub/manual/](https://www.gnu.org/software/grub/manual/)
