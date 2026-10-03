# Task checklist — DevOps Project 03 (Linux)

Work top to bottom. Each phase notes **which user you must be logged in as**. Attempt from memory, then check [`solutions/`](solutions/).

> Tip: the phases deliberately switch users to make you feel permission boundaries. When a step *fails* with "Permission denied", that's often the lesson — note *why*, then switch to the right user.

---

## Phase 0 — Setup
- [ ] Launch EC2 instance and connect ([`00-setup-ec2.md`](00-setup-ec2.md))
- [ ] Look at the directory diagram in the [source README](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-03)

## Phase 1 — as **root** — foundation
- [ ] Create users `user1`, `user2`, `user3` and set passwords
- [ ] Create groups `devops`, `aws`
- [ ] Change primary group of `user2`, `user3` to `devops`
- [ ] Add `aws` as a **secondary** group of `user1`
- [ ] Build the file/directory structure from the diagram
- [ ] `chgrp devops` on `/dir1`, `/dir7/dir10`, `/f2`
- [ ] `chown user1` on `/dir1`, `/dir7/dir10`, `/f2`

## Phase 2 — as **user1** — privilege boundaries
- [ ] Try to create users `user4`, `user5` and set passwords
- [ ] Try to create groups `app`, `database`
- [ ] 📝 Note whether this works and why (hint: does user1 have sudo?)

## Phase 3 — as **user4**
- [ ] Create directory `/dir6/dir4`
- [ ] Create file `/f3`
- [ ] Move `/dir1/f1` → `/dir2/dir1/dir2`
- [ ] Rename `/f2` → `/f4`

## Phase 4 — as **user1**
- [ ] Create directory `/home/user2/dir1`
- [ ] `cd /dir2/dir1/dir2/dir10`, then create `/opt/dir14/dir10/f1` using a **relative path**
- [ ] Move `/opt/dir14/dir10/f1` → user1's home directory
- [ ] Delete `/dir4` recursively
- [ ] Delete all children under `/opt/dir14` with a **single command**
- [ ] Write `Linux assessment for an DevOps Engineer!! Learn with Fun!!` into `/f3`

## Phase 5 — as **user2** — text processing
- [ ] Create file `/dir1/f2`
- [ ] Delete `/dir6`
- [ ] Delete `/dir8`
- [ ] Replace `DevOps` → `devops` in `/f3` **without an editor** (`sed`)
- [ ] In `vi`, copy line 1 and paste it 10 times in `/f3`
- [ ] Replace pattern `Engineer` → `engineer` in `/f3` with a **single command**
- [ ] Delete `/f3`

## Phase 6 — as **root** — inspection
- [ ] Find every absolute path where a file named `f3` exists
- [ ] Count the number of files in `/`
- [ ] Print the last line of `/etc/passwd`

## Phase 7 — AWS — storage
- [ ] Create a **5 GB EBS volume in the same AZ** as the instance
- [ ] Attach it to the instance

## Phase 8 — as **root** — file system
- [ ] Create a file system on the new EBS volume
- [ ] Mount it on `/data`
- [ ] Verify with `df -h` (must show `/data`)
- [ ] Create file `f1` in `/data`

## Phase 9 — as **user5** — cleanup (files)
- [ ] Delete `/dir1 /dir2 /dir3 /dir5 /dir7`
- [ ] Delete `/f1` and `/f4`
- [ ] Delete `/opt/dir14`

## Phase 10 — as **root** — cleanup (users & fs)
- [ ] Delete users `user1`–`user5`
- [ ] Delete groups `app`, `aws`, `database`, `devops`
- [ ] Delete any leftover home directories
- [ ] Unmount `/data`
- [ ] Delete `/data` directory

## Phase 11 — AWS — teardown 💰
- [ ] Detach the EBS volume from the instance
- [ ] **Delete** the EBS volume
- [ ] **Terminate** the EC2 instance
- [ ] Confirm in the console that nothing is still running/billing

---

✅ **Done?** Still not confident? Repeat the steps! Then move on to **Project 02 — AWS VPC** (next in the roadmap).
