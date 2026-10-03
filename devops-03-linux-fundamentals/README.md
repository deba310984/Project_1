# DevOps Project 03 — Fun with Linux for Cloud & DevOps Engineers

> Source: [NotHarshhaa/DevOps-Projects — DevOps-Project-03](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-03)
> This is **project 1 of 14** in my portfolio path (priority order: 03 → 02 → 05 → 11 → 04 → 17 → 08 → 15 → 18 → 06 → 09 → 24 → 21 → 26).

## What this project is
A pure **Linux fundamentals** assignment run on a real cloud server (an AWS EC2 instance).
You do NOT write code or install app stacks. You practice the day-to-day Linux skills
that every DevOps / Cloud / SRE / DevSecOps engineer uses constantly:

- **User & group management** (`useradd`, `groupadd`, `usermod`, `passwd`, primary vs secondary groups)
- **Permissions & ownership** (`chown`, `chgrp`, `chmod`, the read/write/execute model)
- **Directory structure & navigation** (absolute vs relative paths, the FHS layout)
- **File management** (`touch`, `mv`, `cp`, `rm`, `rm -r`, `find`, `grep`, `sed`, `vi`)
- **File systems & storage** (attach an EBS volume, `mkfs`, `mount`, `/etc/fstab`, `df -h`)

## Why this matters (the real-job angle)
Every server you'll ever touch as a DevOps engineer is Linux. Before Docker, Kubernetes,
Terraform, or CI/CD, you must be fluent at the shell: creating service accounts, fixing
"permission denied", finding a runaway file that filled a disk, mounting a new volume when
storage runs out. This project is the muscle-memory layer everything else sits on.

## What you'll be able to say afterward
See the **"Resume bullet"** section at the very bottom of [TASKS.md](TASKS.md) (filled in when you finish).

---

## ⚠️ COST WARNING — read before you start
This project uses **paid AWS resources**. If you leave them running you WILL be charged.

| Resource | Free-tier friendly? | Notes |
|---|---|---|
| EC2 `t2.micro` / `t3.micro` | ✅ 750 hrs/month first 12 months | Use this instance type. |
| EBS volume (root 8 GB) | ✅ within 30 GB free tier | Comes with the instance. |
| **Extra 5 GB EBS volume (Phase 7)** | ⚠️ counts toward the 30 GB/month free tier | Small, but **delete it** at the end. |
| Data transfer | ✅ minimal here | — |

**Golden rule:** do the whole thing in one or two sittings, then **Phase 10 + 11 tear everything
down** (unmount, detach + delete the volume, terminate the instance). If you stop for the day,
you can leave a `t2.micro` stopped (you're not billed for stopped instance compute, only for its
EBS storage — pennies), but the cleanest habit is to finish and terminate.

There is a **teardown checklist** at the end of [TASKS.md](TASKS.md). Do not skip it.

---

## How to use this workspace
1. **[00-setup.md](00-setup.md)** — do this first. Create the AWS account (if needed), launch the
   EC2 instance, and connect to it from your Windows machine. This is the only "cloud" part of setup.
2. **[TASKS.md](TASKS.md)** — the full assignment as a phase-by-phase checkbox tracker. Work top to bottom.
3. **Attempt each phase yourself first.** Then come back to me (the assistant) and say
   *"check phase N"* or *"explain phase N"*. I'll only teach the concept up front and check your
   work after you try — I won't dump all the answers at once.
4. **[solutions/](solutions/)** — one reference file per phase. These start as gated stubs on purpose.
   When you've attempted a phase and want the reference, ask me to fill in that phase's solution file.
5. **[NOTES.md](NOTES.md)** — your own log. Write what confused you, what you got wrong, and the
   "aha" moments. This is what you'll reread before interviews.

## What runs where (Windows vs cloud)
- **Windows (your laptop):** editing these markdown files, and running the **SSH client** to connect.
  You do NOT run any of the Linux assignment commands on Windows.
- **The EC2 instance (Linux):** every `useradd`, `chmod`, `mount`, etc. runs *there*, over SSH.
- Windows 10/11 ships with OpenSSH built in, so you don't need PuTTY (though you can use it).
  Details in [00-setup.md](00-setup.md).

---
*Teaching flow: concept → why → commands → gotchas → interview angle. Ask me phase by phase.*
