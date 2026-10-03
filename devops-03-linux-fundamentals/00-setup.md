# 00 — Setup: Launch & connect to the EC2 instance

Goal of this file: get you to a Linux shell prompt on a real AWS server. Once you see
`[ec2-user@ip-… ~]$`, you're ready for [TASKS.md](TASKS.md).

---

## A. Accounts & tools you need

| Thing | Why | Notes |
|---|---|---|
| AWS account | Hosts the EC2 Linux server | Free tier covers a `t2.micro`. Needs a credit/debit card for verification. |
| SSH client | Connect from Windows → Linux | **Built into Windows 10/11** (`ssh` in PowerShell). PuTTY optional. |
| A key pair | Authenticates you to the server | You create this in the AWS console during launch. |

You do **not** need Terraform, Docker, or anything else for this project. Just AWS + SSH.

---

## B. Launch the EC2 instance (AWS Console)

> Region tip: pick one region and stay in it (e.g. `ap-south-1` Mumbai or `us-east-1`).
> The extra EBS volume in Phase 7 **must be in the same Availability Zone** as the instance,
> so note which AZ your instance lands in.

1. Console → **EC2** → **Launch instance**.
2. **Name:** `devops-03-linux`.
3. **AMI (the OS image):** *Amazon Linux 2023* (or Ubuntu — either is fine; commands are the
   same except the default login user differs, see section D). Amazon Linux is the simplest.
4. **Instance type:** `t2.micro` (or `t3.micro`) — the free-tier eligible one.
5. **Key pair:** *Create new key pair* → name it `devops-03-key` → type **RSA**, format **.pem**
   → **Download**. Save it somewhere you control, e.g. `C:\DEVOPS\keys\devops-03-key.pem`.
   **You only get to download it once.**
6. **Network settings:** leave defaults, but ensure **Allow SSH traffic (port 22)** is checked.
   For learning, "Anywhere 0.0.0.0/0" is OK; the safer choice is **My IP**.
7. **Storage:** default 8 GB root volume is fine. (The extra 5 GB volume comes later in Phase 7 —
   don't add it now; the assignment wants you to attach it live.)
8. **Launch instance.** Wait until **Instance state = Running** and **Status checks = 2/2**.
9. Click the instance → note its **Public IPv4 address** and its **Availability Zone**
   (e.g. `ap-south-1b`). Write the AZ down — you need it in Phase 7.

---

## C. Fix the key file permissions (Windows)

SSH refuses to use a key file that other Windows users can read. In **PowerShell**, from where
your `.pem` lives:

```powershell
icacls "C:\DEVOPS\keys\devops-03-key.pem" /inheritance:r
icacls "C:\DEVOPS\keys\devops-03-key.pem" /grant:r "$($env:USERNAME):(R)"
```

This removes inherited permissions and grants read-only to just you. If you skip this, `ssh`
will throw an "unprotected private key file" error.

---

## D. Connect over SSH

Default login user depends on the AMI:
- **Amazon Linux:** `ec2-user`
- **Ubuntu:** `ubuntu`

From PowerShell (replace the IP with your instance's Public IPv4):

```powershell
ssh -i "C:\DEVOPS\keys\devops-03-key.pem" ec2-user@<PUBLIC_IP>
```

Type `yes` at the "authenticity of host" prompt the first time. You should land at a shell
prompt like `[ec2-user@ip-172-31-x-x ~]$`.

### Becoming root
Almost every phase starts with "login as root." You don't SSH in as root directly. Instead:

```bash
sudo -i        # become root; prompt changes to ' # '
```

or run individual commands with `sudo <command>`. When a phase says "login as user1", you'll
switch users with `su - user1` (covered in the task teaching).

---

## E. Sanity checks before you start Phase 1

```bash
whoami                 # who am I? (ec2-user)
sudo -i; whoami        # should now say: root
cat /etc/os-release    # confirm the distro
df -h                  # current disk layout (you'll compare after Phase 8)
```

If all of that works, open [TASKS.md](TASKS.md) and start Phase 1.

---

## F. When you're done for the day
- **Finishing the whole project:** run Phases 10 & 11 (teardown), then confirm in the console
  that the instance is **Terminated** and the extra volume is **Deleted**.
- **Pausing mid-project:** you *can* **Stop** (not terminate) the instance to resume later.
  Stopped = no compute charge, tiny EBS storage charge. But your public IP will change on
  restart (use the new one next time). Terminating deletes everything, so only terminate when
  truly done.

⚠️ **Never leave a running instance + extra EBS volume overnight and forget about it.**
