# TASKS — DevOps Project 03 (Fun with Linux)

Work top to bottom. Tick a box when done. **Attempt each phase yourself before asking me to check.**
Concept teaching happens per phase — say *"teach phase N"*, attempt it, then *"check phase N"*.

Legend: `[ ]` todo · `[x]` done · 🧠 = concept you should be able to explain in an interview

---

## ⚠️ The initial file/directory structure (Phase 1.5)

Phase 1 step 5 says *"create the file and directory structure shown in the above diagram."*
That diagram is an **image** in the README, not text — so treat the README's diagram as the
**authoritative** source and cross-check it. Below is the structure **reconstructed from every
path the later phases reference**. It must at minimum contain all of these so nothing breaks later:

```
/                      (root of the filesystem)
├── dir1/
│   └── f1             # moved away in Phase 3
├── dir2/
│   └── dir1/
│       └── dir2/
│           └── dir10/ # you cd into this in Phase 4 (relative-path exercise)
├── dir3/
├── dir4/              # deleted in Phase 4
├── dir5/
├── dir6/              # user4 makes dir6/dir4 inside it in Phase 3
├── dir7/
│   └── dir10/         # group/owner changed in Phase 1
├── dir8/
├── f1                 # NOTE: /dir1/f1 and /f1 are referenced separately — create both
├── f2                 # renamed to /f4 in Phase 3
└── opt/dir14/dir10/   # /opt/dir14/dir10/f1 is used in Phase 4 — must exist beforehand
```

> If the README diagram shows extra dirs (e.g. dir9) or a slightly different nesting, follow the
> diagram — but the tree above guarantees every later step has the paths it needs.
> **Ask me if you want to verify the diagram image itself.**

---

## Phase 1 — Root setup
*Concept focus: 🧠 users vs groups, primary vs secondary group, ownership vs group ownership.*

- [ ] 1.1 Create users **user1, user2, user3** and set passwords
- [ ] 1.2 Create groups **devops**, **aws**
- [ ] 1.3 Change the **primary** group of **user2** and **user3** to **devops**
- [ ] 1.4 Add **aws** as a **secondary** group to **user1**
- [ ] 1.5 Create the file/directory structure (see the tree above / README diagram)
- [ ] 1.6 Change the **group** of `/dir1`, `/dir7/dir10`, `/f2` to **devops**
- [ ] 1.7 Change the **owner** of `/dir1`, `/dir7/dir10`, `/f2` to **user1**

## Phase 2 — Logged in as user1
*Concept focus: 🧠 can a normal user create users? (sudo/privilege) — expect a gotcha here.*

- [ ] 2.1 Create users **user4, user5** and set passwords
- [ ] 2.2 Create groups **app**, **database**

## Phase 3 — Logged in as user4
*Concept focus: 🧠 `mv` for both moving AND renaming; write permission on the parent dir.*

- [ ] 3.1 Create directory `/dir6/dir4`
- [ ] 3.2 Create file `/f3`
- [ ] 3.3 Move the file `/dir1/f1` → `/dir2/dir1/dir2`
- [ ] 3.4 Rename `/f2` → `/f4`

## Phase 4 — Logged in as user1
*Concept focus: 🧠 relative vs absolute paths, `rm -r`, redirect (`>`) to write a file.*

- [ ] 4.1 Create directory `/home/user2/dir1`
- [ ] 4.2 `cd` into `/dir2/dir1/dir2/dir10`, then create `/opt/dir14/dir10/f1` **using a relative path**
- [ ] 4.3 Move `/opt/dir14/dir10/f1` → user1's home directory
- [ ] 4.4 Delete the directory `/dir4` **recursively**
- [ ] 4.5 Delete all child files & directories under `/opt/dir14` **in a single command**
- [ ] 4.6 Write the text `Linux assessment for an DevOps Engineer!! Learn with Fun!!` into `/f3` and save

## Phase 5 — Logged in as user2
*Concept focus: 🧠 `sed` (stream editing) vs `vi`; global replace; text manipulation without an editor.*

- [ ] 5.1 Create file `/dir1/f2`
- [ ] 5.2 Delete `/dir6`
- [ ] 5.3 Delete `/dir8`
- [ ] 5.4 Replace `DevOps` → `devops` in `/f3` **without using an editor** (i.e. `sed`)
- [ ] 5.5 Using **vi**, copy line 1 and paste it 10 times in `/f3`
- [ ] 5.6 Search pattern `Engineer` → replace with `engineer` in `/f3` **in a single command**
- [ ] 5.7 Delete `/f3`

## Phase 6 — Logged in as root
*Concept focus: 🧠 `find` for whole-system search; counting with `wc`; `tail`.*

- [ ] 6.1 Search the whole server for files named `f3`, list all **absolute paths** found
- [ ] 6.2 Show the **count** of files in `/`
- [ ] 6.3 Print the **last line** of `/etc/passwd`

## Phase 7 — AWS: add storage
*Concept focus: 🧠 block storage (EBS) vs a filesystem; AZ affinity.*

- [ ] 7.1 Create a **5 GB EBS volume** in the **same AZ** as your instance
- [ ] 7.2 **Attach** it to the instance
      *(⚠️ this is the paid resource — remember to delete it in Phase 11)*

## Phase 8 — Root: make & mount the filesystem
*Concept focus: 🧠 the raw device → `mkfs` → `mount` → `/data` chain; `lsblk`, `df -h`.*

- [ ] 8.1 Create a **filesystem** on the new EBS volume
- [ ] 8.2 **Mount** it on `/data`
- [ ] 8.3 Verify with `df -h` (must show the `/data` filesystem)
- [ ] 8.4 Create file `f1` inside `/data`

## Phase 9 — Logged in as user5 (cleanup part 1)
*Concept focus: 🧠 who is allowed to delete what (permissions bite you here).*

- [ ] 9.1 Delete `/dir1`
- [ ] 9.2 Delete `/dir2`
- [ ] 9.3 Delete `/dir3`
- [ ] 9.4 Delete `/dir5`
- [ ] 9.5 Delete `/dir7`
- [ ] 9.6 Delete `/f1` and `/f4`
- [ ] 9.7 Delete `/opt/dir14`

## Phase 10 — Root (cleanup part 2)
*Concept focus: 🧠 deleting users/groups cleanly; unmounting.*

- [ ] 10.1 Delete users: user1, user2, user3, user4, user5
- [ ] 10.2 Delete groups: app, aws, database, devops
- [ ] 10.3 Delete home directories of all users if any remain
- [ ] 10.4 **Unmount** the `/data` filesystem
- [ ] 10.5 Delete the `/data` directory

## Phase 11 — AWS: destroy paid resources
*Concept focus: 🧠 detach before delete; terminate vs stop.*

- [ ] 11.1 **Detach** the EBS volume from the instance
- [ ] 11.2 **Delete** the EBS volume
- [ ] 11.3 **Terminate** the EC2 instance

---

## 🔥 TEARDOWN CHECKLIST (do NOT skip — this is what stops billing)
- [ ] `df -h` shows `/data` no longer mounted (Phase 10.4 done)
- [ ] EBS 5 GB volume **detached** AND **deleted** in the console (state: not "in-use", then gone)
- [ ] EC2 instance state = **Terminated** in the console
- [ ] No other running instances left in this region (check the EC2 dashboard)
- [ ] Billing → confirm nothing unexpected is accruing

---

## 📝 Resume bullet (fill in after completion)
> _To be written together at the end — see project brief item 6._

## 📌 Portfolio README checklist (fill in after completion)
> _To be written together at the end — what to put in the repo to make this portfolio-ready._
