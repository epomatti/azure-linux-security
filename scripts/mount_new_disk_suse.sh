#!/bin/bash

mkfs.ext4 /dev/sdc # superfloppy
mkdir -p /data/disk1
#partprobe "${PARTITION}"

UUID=$(blkid /dev/sdc --match-tag UUID --output value)

echo "UUID=$UUID /data/disk1 ext4 defaults,nofail 0 2" >> /etc/fstab

systemctl daemon-reload
mount -a