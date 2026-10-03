#!/usr/bin/env bash
# Phase 5 — login as USER2:   su - user2
# Focus: sed, vi, grep-style text processing.

## 5.1 Create file /dir1/f2
touch /dir1/f2

## 5.2 / 5.3 Delete /dir6 and /dir8
rm -r /dir6
rm -r /dir8

## 5.4 Replace "DevOps" -> "devops" in /f3 WITHOUT an editor  (sed in-place)
sed -i 's/DevOps/devops/g' /f3
cat /f3

## 5.5 In vi, copy line 1 and paste it 10 times in /f3
#   vi /f3
#     (cursor on line 1)  yy      -> yank (copy) the line
#     10p                         -> paste it 10 times below
#     :wq                         -> write & quit
#
#   Non-interactive equivalent (for checking), keep line 1, append it 10x:
#   line1=$(head -n1 /f3); for i in $(seq 10); do echo "$line1" >> /f3; done

## 5.6 Replace "Engineer" -> "engineer" in /f3 in a SINGLE command
sed -i 's/Engineer/engineer/g' /f3
cat /f3

## 5.7 Delete /f3
rm /f3
