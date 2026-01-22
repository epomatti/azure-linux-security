#!/bin/bash

# lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"
DISK=sdc
PARTITION="/dev/${DISK}1"
MOUNT_PATH=/data/datadrive_ext4

parted "/dev/${DISK}" --script mklabel gpt mkpart primary ext4 0% 100%
mkfs.ext4 "${PARTITION}"
partprobe "${PARTITION}"

mkdir -p "${MOUNT_PATH}"
mount "${PARTITION}" "${MOUNT_PATH}"

cp /etc/fstab /etc/fstab.bak
UUID_VAL=$(blkid -s UUID -o value "${PARTITION}")

echo "UUID=$UUID_VAL  $MOUNT_PATH  ext4  defaults,nofail  0  2" | tee -a /etc/fstab
mount -a
