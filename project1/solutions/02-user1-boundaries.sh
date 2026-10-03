#!/usr/bin/env bash
# Phase 2 — login as USER1:   su - user1
# Lesson: privilege boundaries. A normal user CANNOT manage users/groups.

## 2.1 / 2.2 — this is EXPECTED TO FAIL:
useradd user4          # -> "Permission denied" (only root/sudo can do this)
useradd user5
groupadd app
groupadd database

# WHY: useradd/groupadd write to /etc/passwd, /etc/shadow, /etc/group — root-only files.
#
# Two ways to actually complete the intent:
#   a) if user1 has sudo rights:      sudo useradd user4
#   b) do it from root instead:        (run these as root)
#        useradd user4 && passwd user4
#        useradd user5 && passwd user5
#        groupadd app
#        groupadd database
#
# 📝 Takeaway: user4/user5 MUST exist before Phase 3, so create them as root
#    if user1 lacks sudo. Note in TASKS.md what happened.
