#!/bin/bash

# lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"
DISK=sdc
PARTITION="/dev/${DISK}1"
MOUNT_PATH=/mnt/datadrive2

sudo mkdir -p "${MOUNT_PATH}"
sudo mount "${PARTITION}" "/${MOUNT_PATH}"

sudo cp /etc/fstab /etc/fstab.bak
UUID_VAL=$(sudo blkid -s UUID -o value "${PARTITION}")

echo "UUID=$UUID_VAL  $MOUNT_PATH  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab
sudo mount -a
