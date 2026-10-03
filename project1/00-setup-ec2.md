# Phase 0 — Launch & connect to an EC2 instance

You need a running Linux box before Phase 1. Two options: the AWS Console (clickops, good for learning) or the AWS CLI (faster, repeatable).

## Option A — AWS Console (recommended first time)

1. Sign in to the [AWS Console](https://console.aws.amazon.com/ec2/) → **EC2** → **Launch instance**.
2. **Name:** `devops-project-03-linux`
3. **AMI:** Amazon Linux 2023 (or Ubuntu 22.04) — free-tier eligible.
4. **Instance type:** `t2.micro` or `t3.micro` (free tier).
5. **Key pair:** create/select one and download the `.pem` — you need it to SSH.
6. **Network:** allow **SSH (port 22)** from *My IP* only.
7. **Storage:** default 8 GB root volume is fine. (The extra 5 GB EBS volume comes later, in Phase 7.)
8. **Launch instance**, then note the **Public IPv4 address** and its **Availability Zone** (you'll need the same AZ for the EBS volume in Phase 7).

### Connect

From an SSH client (Windows: PowerShell, Windows Terminal, or the EC2 "Connect" browser console):

```bash
# Amazon Linux
ssh -i /path/to/your-key.pem ec2-user@<PUBLIC_IP>
# Ubuntu
ssh -i /path/to/your-key.pem ubuntu@<PUBLIC_IP>
```

If SSH complains the key is too open, on Windows use the EC2 Instance Connect browser console instead, or fix perms via WSL: `chmod 400 your-key.pem`.

### Become root

Almost every phase says "login as super user / root". After connecting:

```bash
sudo -i        # become root for Phase 1, 6, 8, 10
```

## Option B — AWS CLI (if configured)

```bash
# Pick your key pair name and a security group that allows SSH
aws ec2 run-instances \
  --image-id resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
  --instance-type t3.micro \
  --key-name YOUR_KEY_NAME \
  --security-group-ids sg-xxxxxxxx \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=devops-project-03-linux}]' \
  --count 1
```

Grab the public IP and AZ:

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=devops-project-03-linux" "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].{IP:PublicIpAddress,AZ:Placement.AvailabilityZone,Id:InstanceId}" \
  --output table
```

---

➡️ Once you can run `whoami` on the instance and see `root` after `sudo -i`, go to [`TASKS.md`](TASKS.md) and start Phase 1.
