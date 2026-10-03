#!/usr/bin/env bash
# Phase 10 — login as ROOT (sudo -i)
# Remove users, groups, homes, and unmount/delete the data filesystem.

## 10.1 Delete users  (-r also removes their home dir + mail spool)
for u in user1 user2 user3 user4 user5; do
    userdel -r "$u" 2>/dev/null || echo "$u already gone / no home"
done

## 10.2 Delete groups (only ones not already gone as a user's primary group)
for g in app aws database devops; do
    groupdel "$g" 2>/dev/null || echo "$g already gone"
done

## 10.3 Delete any leftover home directories
rm -rf /home/user1 /home/user2 /home/user3 /home/user4 /home/user5

## 10.4 Unmount /data
umount /data
# If "target is busy": lsof /data  (or  fuser -m /data)  then stop/cd out of it.
# If you added an /etc/fstab line in Phase 8, remove it now.

## 10.5 Delete the /data directory (mountpoint)
rmdir /data                    # or: rm -r /data

df -h | grep -q /data && echo "STILL MOUNTED" || echo "/data cleaned up"

# ➡️ Phase 11 is in AWS — see notes in ../00-setup-ec2.md and below.
#    aws ec2 detach-volume  --volume-id vol-xxxx
#    aws ec2 delete-volume  --volume-id vol-xxxx
#    aws ec2 terminate-instances --instance-ids i-xxxx
#  💰 Confirm in the console that the instance is terminated and the
#     volume is deleted so nothing keeps billing.
