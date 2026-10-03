#!/usr/bin/env bash
# Phase 9 — login as USER5:   su - user5
# Delete the remaining dirs/files. Expect some "Permission denied" on
# root/user1-owned paths — use sudo or do it as the owner/root if blocked.

## 9.1–9.5 Delete directories
rm -r /dir1 /dir2 /dir3 /dir5 /dir7

## 9.6 Delete /f1 and /f4
rm /f1 /f4                      # /f4 is the renamed /f2 from Phase 3.4

## 9.7 Delete /opt/dir14
rm -r /opt/dir14

# If blocked: sudo rm -r <path>   (ownership/permissions lesson again)
# Sanity check nothing is left:
ls -la /  | grep -E 'dir[0-9]|f[0-9]' || echo "clean"
