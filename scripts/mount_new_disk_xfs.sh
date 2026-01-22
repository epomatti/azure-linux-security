#!/bin/bash

# lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"
DISK=sda
PARTITION="/dev/${DISK}1"
MOUNT_PATH=/mnt/datadrive

sudo parted "/dev/${DISK}" --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs "${PARTITION}"
sudo partprobe "${PARTITION}"

sudo mkdir -p "${MOUNT_PATH}"
sudo mount "${PARTITION}" "${MOUNT_PATH}"

sudo cp /etc/fstab /etc/fstab.bak
UUID_VAL=$(sudo blkid -s UUID -o value "${PARTITION}")

echo "UUID=$UUID_VAL  $MOUNT_PATH  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab
sudo mount -a
