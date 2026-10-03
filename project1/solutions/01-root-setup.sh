#!/usr/bin/env bash
# Phase 1 — run as ROOT (sudo -i)
# Foundation: users, groups, directory structure, ownership.
set -euo pipefail

## 1.1 Create users + set passwords
for u in user1 user2 user3; do
    useradd "$u"
    echo "Set password for $u:"
    passwd "$u"            # interactive; or: echo "$u:Passw0rd!" | chpasswd
done

## 1.2 Create groups
groupadd devops
groupadd aws

## 1.3 Change PRIMARY group of user2, user3 to devops  (-g)
usermod -g devops user2
usermod -g devops user3

## 1.4 Add aws as a SECONDARY group of user1  (-aG = append)
usermod -aG aws user1

# Verify group membership
id user1; id user2; id user3

## 1.5 Directory / file structure (reconstructed from the diagram)
mkdir -p /dir1 /dir3 /dir4 /dir5 /dir6 /dir8
mkdir -p /dir2/dir1/dir2/dir10
mkdir -p /dir7/dir10
mkdir -p /opt/dir14/dir10
touch /dir1/f1 /f1 /f2

## 1.6 Change GROUP of /dir1, /dir7/dir10, /f2 to devops
chgrp devops /dir1 /dir7/dir10 /f2
# (recursive on the dir if you want its contents too: chgrp -R devops /dir1)

## 1.7 Change OWNER of /dir1, /dir7/dir10, /f2 to user1
chown user1 /dir1 /dir7/dir10 /f2

# Verify
ls -ld /dir1 /dir7/dir10; ls -l /f2
