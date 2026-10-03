#!/usr/bin/env bash
# Phase 6 — login as ROOT (sudo -i)
# Focus: searching and inspecting the filesystem.

## 6.1 Find every absolute path where a file named f3 exists
find / -name f3 -type f 2>/dev/null
# 2>/dev/null hides "Permission denied" noise from special dirs like /proc.
# (You deleted /f3 in Phase 5, so this may find nothing — that's a valid result.
#  Re-create one to test: touch /tmp/f3 )

## 6.2 Count the number of files in the directory '/'
# "files in /" = entries directly inside / (not recursive):
ls -A / | wc -l
# If you mean ALL files under / recursively (regular files only):
#   find / -type f 2>/dev/null | wc -l

## 6.3 Print the last line of /etc/passwd
tail -n 1 /etc/passwd
