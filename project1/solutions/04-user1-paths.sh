#!/usr/bin/env bash
# Phase 4 — login as USER1:   su - user1
# Focus: relative paths, recursive & bulk delete, writing to a file.

## 4.1 Create directory /home/user2/dir1
mkdir /home/user2/dir1         # may need sudo (user2's home is not user1's)

## 4.2 cd to /dir2/dir1/dir2/dir10, then create /opt/dir14/dir10/f1 via RELATIVE path
cd /dir2/dir1/dir2/dir10
# From here, /opt/dir14/dir10 is: up 4 levels to /, then down into opt/dir14/dir10
touch ../../../../opt/dir14/dir10/f1
#      ^dir2  ^dir1 ^dir2 ^/     (each ../ climbs one level)
ls -l /opt/dir14/dir10/f1      # verify it landed at the absolute path

## 4.3 Move that file to user1's home directory
mv /opt/dir14/dir10/f1 ~       # ~ = /home/user1

## 4.4 Delete /dir4 recursively
rm -r /dir4

## 4.5 Delete ALL children under /opt/dir14 in a single command (keep dir14 itself)
rm -rf /opt/dir14/*

## 4.6 Write the sentence into /f3 and save
echo "Linux assessment for an DevOps Engineer!! Learn with Fun!!" > /f3
cat /f3
