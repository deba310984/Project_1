#!/usr/bin/env bash
# Phase 3 — login as USER4:   su - user4
# Note: some of these touch root-owned paths (/f2, /dir1). If you hit
# "Permission denied", that's the permission lesson — see notes at the bottom.

## 3.1 Create directory /dir6/dir4
mkdir /dir6/dir4

## 3.2 Create file /f3
touch /f3                      # needs write perm on /  -> likely done as root or with sudo

## 3.3 Move /dir1/f1 -> /dir2/dir1/dir2
mv /dir1/f1 /dir2/dir1/dir2

## 3.4 Rename /f2 -> /f4
mv /f2 /f4

# --- Permission notes ---
# /f2 and /dir1 are owned by user1 (Phase 1.7), and / is owned by root.
# As user4 you may not be able to write in / or move user1's files.
# Options if blocked:
#   sudo mv /dir1/f1 /dir2/dir1/dir2      # if user4 has sudo
#   # or perform as root / the owning user
# The intent is to SEE that ownership controls who can move/rename what.
