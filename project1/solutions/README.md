# Reference solutions

**Attempt each phase yourself first.** These are here to check against, not to copy-paste blindly — the point of the project is building muscle memory.

Files are named by phase and by the user you must be logged in as:

- `01-root-setup.sh` — Phase 1 (root)
- `02-user1-boundaries.sh` — Phase 2 (user1)
- `03-user4-files.sh` — Phase 3 (user4)
- `04-user1-paths.sh` — Phase 4 (user1)
- `05-user2-text.sh` — Phase 5 (user2)
- `06-root-inspect.sh` — Phase 6 (root)
- `08-root-filesystem.sh` — Phase 8 (root)
- `09-user5-cleanup.sh` — Phase 9 (user5)
- `10-root-cleanup.sh` — Phase 10 (root)

Phases 0, 7, and 11 are AWS steps — see [`../00-setup-ec2.md`](../00-setup-ec2.md) and the AWS notes in each cleanup file.

## Switching users

The exercise expects you to *login as* each user. Two ways:

```bash
# Fully switch (loads their environment) — needs their password, set in Phase 1:
su - user1

# Or from root, run a single command as a user without a password:
sudo -u user4 mkdir /dir6/dir4
```

`su - userN` is closest to the "login as" intent and best shows permission boundaries.

## The directory structure (reconstructed)

The original diagram is an image. This tree satisfies every later step:

```
/
├── dir1/            └── f1
├── dir2/dir1/dir2/dir10/
├── dir3/
├── dir4/
├── dir5/
├── dir6/
├── dir7/dir10/
├── dir8/
├── f1
├── f2
└── opt/dir14/dir10/
```
