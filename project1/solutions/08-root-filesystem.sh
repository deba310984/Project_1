#!/usr/bin/env bash
# Phase 8 — login as ROOT (sudo -i)
# Prereq: Phase 7 done — a 5GB EBS volume created in the SAME AZ and ATTACHED.
# Focus: block devices, filesystems, mounting.

## First, find the new block device
lsblk                          # look for a ~5G disk with no MOUNTPOINT
                               # e.g. /dev/xvdf (Xen) or /dev/nvme1n1 (Nitro)
DEV=/dev/xvdf                  # <-- change to match lsblk output

## 8.1 Create a file system on the new volume
mkfs -t ext4 "$DEV"            # or: mkfs.xfs "$DEV"

## 8.2 Mount it on /data
mkdir -p /data
mount "$DEV" /data

## 8.3 Verify — must show /data
df -h
df -h /data

## 8.4 Create file f1 in /data
touch /data/f1
ls -l /data

# (Optional) persist across reboots via /etc/fstab using the UUID:
#   blkid "$DEV"
#   echo "UUID=<uuid>  /data  ext4  defaults,nofail  0  2" >> /etc/fstab
# Remember to remove this line in Phase 10 before deleting /data.
