# DevOps Project 03 — Fun with Linux for Cloud & DevOps Engineers

> First project in the learning roadmap. Source: [NotHarshhaa/DevOps-Projects › DevOps-Project-03](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-03)

## What this project teaches

Hands-on Linux fundamentals every DevOps engineer needs, practiced on a real AWS EC2 instance:

- **User & group management** — `useradd`, `groupadd`, `usermod`, `passwd`, `userdel`, `groupdel`
- **Permissions & ownership** — `chown`, `chgrp`, `chmod`
- **Directory structure & navigation** — absolute vs. relative paths
- **File management** — create, move, rename, delete (recursive & bulk)
- **Text processing** — `sed`, `vi`, `grep`
- **File systems / storage** — provision, format, and mount a 5 GB EBS volume

## How to use this workspace

This is a **Windows** machine — the exercise itself runs on a **Linux EC2 instance**. Use these files as your command center:

| File | Purpose |
|------|---------|
| [`00-setup-ec2.md`](00-setup-ec2.md) | Launch the EC2 instance and connect to it |
| [`TASKS.md`](TASKS.md) | The full 11-phase checklist — tick items off as you go |
| [`solutions/`](solutions/) | Reference commands for each phase — **only peek after you've attempted it** |

### Recommended flow

1. Follow [`00-setup-ec2.md`](00-setup-ec2.md) to get a Linux box running.
2. Open [`TASKS.md`](TASKS.md) on one side, your SSH session on the other.
3. Attempt a phase from memory / man pages first.
4. Check yourself against the matching file in [`solutions/`](solutions/).
5. **Tear everything down** (Phase 8–11) so you don't leave AWS resources billing.

## ⚠️ Cost warning

An EC2 instance and an EBS volume cost money while they exist. Use a **free-tier `t2.micro`/`t3.micro`** and **terminate the instance + delete the volume** the moment you finish (Phase 11). Set a billing alarm if you haven't already.

## The directory/file diagram

Step 1.5 ("Create the file and directory structure shown in the above diagram") refers to an **image in the original README** that isn't reproducible as text here. Before starting, open the [source README](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-03) and look at the diagram so you know the exact tree of `/dir1`–`/dir10`, `/dir14`, and `/f1`–`/f4`. [`solutions/01-root-setup.sh`](solutions/01-root-setup.sh) uses a reasonable reconstruction that satisfies every later step.
