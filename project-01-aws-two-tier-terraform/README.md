# Two-Tier AWS Infrastructure with Terraform

> **Status:** Deployed & verified on AWS — `terraform apply` provisioned 38 resources, the ALB served live traffic across two Availability Zones, then the stack was destroyed cleanly.

A classic **two-tier AWS architecture** — a public web/application tier and a
private data tier — provisioned entirely with **Terraform**, spanning two
Availability Zones, with least-privilege networking and SSH-less instance
access via AWS Systems Manager.

## Table of Contents
- [Overview](#overview)
- [Real-world use case](#real-world-use-case)
- [Features](#features)
- [Architecture](#architecture)
- [Architecture explanation](#architecture-explanation)
- [Technology stack](#technology-stack)
- [Repository structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Installation & configuration](#installation--configuration)
- [Deploy](#deploy)
- [Testing & validation](#testing--validation)
- [Security considerations](#security-considerations)
- [Monitoring & troubleshooting](#monitoring--troubleshooting)
- [Execution evidence](#execution-evidence)
- [Known limitations](#known-limitations)
- [Cost considerations](#cost-considerations)
- [Cleanup](#cleanup)
- [Future improvements](#future-improvements)

## Overview
Clicking resources together in the AWS console is slow, error-prone, and not
repeatable. This project describes a complete two-tier stack **as code** so it
can be reviewed, versioned, recreated identically, and destroyed on demand.

## Real-world use case
This is the baseline pattern behind most web applications: a load-balanced,
auto-scaling application tier that talks to a managed database kept fully
private, with neither the app servers nor the database directly exposed to the
internet.

## Features
- One VPC across **2 Availability Zones** for fault tolerance.
- **Three subnet tiers**: public (ALB/NAT), private-app (EC2), private-db (RDS).
- **Application Load Balancer** fronting an **Auto Scaling Group** of EC2 instances.
- **Amazon RDS (MySQL)**, encrypted, private, never internet-reachable.
- **Least-privilege security groups** forming a one-way ALB → App → DB chain.
- **No SSH**: admin shell via **SSM Session Manager** (IAM role, IMDSv2 enforced).
- Zero-downtime rollouts via Auto Scaling **instance refresh**.
- Secrets kept out of git; `terraform fmt` clean; native `terraform test` assertions.

## Architecture
Editable source: [`architecture/architecture.mmd`](architecture/architecture.mmd)

```mermaid
flowchart TB
    user([Internet User])
    subgraph AWS["AWS Region"]
        igw[Internet Gateway]
        subgraph VPC["VPC 10.0.0.0/16"]
            subgraph PUB["Public Subnets (2 AZs)"]
                alb[Application Load Balancer :80]
                nat[NAT Gateway]
            end
            subgraph APP["Private App Subnets (2 AZs)"]
                asg[Auto Scaling Group - EC2 t3.micro]
            end
            subgraph DB["Private DB Subnets (2 AZs)"]
                rds[(RDS MySQL db.t3.micro)]
            end
        end
        ssm[SSM Session Manager]
    end
    user -->|HTTP| igw --> alb -->|forward| asg -->|MySQL 3306| rds
    asg -.->|updates| nat --> igw
    ssm -.->|secure shell| asg
```

## Architecture explanation
1. A user hits the ALB's public DNS name over HTTP (port 80).
2. The **Internet Gateway** admits that traffic to the **ALB** in the public subnets.
3. The ALB forwards to healthy EC2 instances in the **private app subnets**. Those instances have no public IP and cannot be reached directly from the internet.
4. App instances query **RDS** in the **private db subnets** on port 3306. The DB security group accepts connections **only** from the app security group.
5. For outbound needs (OS patches, package installs, SSM endpoints), private instances egress through the **NAT Gateway** — outbound only, never inbound.
6. Administrators get a shell through **SSM Session Manager**, so no SSH port is ever open.

**Two independent isolation layers protect the database:** it sits in a subnet with *no* internet route at all, *and* its security group trusts only the app tier.

## Technology stack
| Tech | Role | Why |
|------|------|-----|
| **Terraform ≥ 1.5** | IaC engine | Declarative plan/apply, state, reproducibility |
| **AWS VPC** | Network | Isolated network with tiered subnets |
| **EC2 + Launch Template + ASG** | App tier | Elastic, self-healing compute |
| **Application Load Balancer** | Traffic | Health-checked HTTP distribution across AZs |
| **Amazon RDS (MySQL)** | Data tier | Managed DB, kept private + encrypted |
| **IAM + SSM** | Access | Least-privilege; shell without exposing SSH |

## Repository structure
```text
.
├── README.md
├── .gitignore
├── architecture/
│   ├── architecture.mmd
│   └── images/
├── terraform/
│   ├── versions.tf              # Terraform + provider version pins
│   ├── providers.tf             # AWS provider + default tags
│   ├── variables.tf             # all input variables (with validation)
│   ├── network.tf               # VPC, subnets, IGW, NAT, routes
│   ├── securitygroups.tf        # ALB -> App -> DB SG chain
│   ├── iam.tf                   # EC2 SSM role + instance profile
│   ├── compute.tf               # launch template, ALB, target group, ASG
│   ├── rds.tf                   # DB subnet group + RDS instance
│   ├── outputs.tf               # ALB URL, endpoints, IDs
│   └── terraform.tfvars.example # safe sample values (no secrets)
├── scripts/
│   ├── user_data.sh             # instance bootstrap (Apache + status page)
│   ├── deploy.sh                # fmt -> init -> validate -> plan
│   └── destroy.sh               # guarded teardown
├── tests/
│   └── plan.tftest.hcl          # native terraform test assertions
└── docs/
    ├── implementation-notes.md
    └── troubleshooting.md
```

## Prerequisites
- Terraform **≥ 1.5.0**
- AWS account + credentials configured (`aws configure`, env vars, or an IAM role)
- An IAM identity allowed to manage VPC / EC2 / ELB / RDS / IAM resources

## Installation & configuration
```bash
git clone https://github.com/deba310984/aws-two-tier-terraform
cd aws-two-tier-terraform/project-01-aws-two-tier-terraform/terraform

# Optional: copy and edit non-secret variables
cp terraform.tfvars.example terraform.tfvars   # terraform.tfvars is gitignored

# Provide the DB password WITHOUT committing it:
export TF_VAR_db_password='choose-a-strong-password'
```

## Deploy
```bash
terraform init          # download the AWS provider, set up state
terraform fmt -check     # formatting gate
terraform validate       # => Success! The configuration is valid.
terraform plan           # review resources; nothing created yet
terraform apply          # CREATES PAID RESOURCES — confirm when prompted
```
Or use the helper: `./scripts/deploy.sh` (does fmt → init → validate → plan).

## Testing & validation
- **Format:** `terraform fmt -check -recursive`
- **Validate:** `terraform validate`
- **Automated test:** `cd terraform && terraform test` runs
  [`tests/plan.tftest.hcl`](tests/plan.tftest.hcl), asserting subnet counts and
  that RDS is private + encrypted (plans only, creates nothing).
- **Post-apply smoke test:**
  ```bash
  curl "$(terraform output -raw alb_dns_name)"
  ```
  Refresh a few times — the instance ID / AZ changes as the ALB load-balances.

## Security considerations
- **No SSH anywhere** — access via SSM Session Manager only.
- **IMDSv2 enforced** (`http_tokens = required`) to block instance-metadata credential theft.
- **RDS**: `publicly_accessible = false`, `storage_encrypted = true`, in private subnets with no internet route.
- **Least-privilege SGs**: each tier trusts only the tier in front of it, by security-group reference (not IP).
- **Secrets**: DB password is a sensitive variable with no default; `.gitignore` blocks state, `*.tfvars`, and keys.
- Run `terraform plan` and review before every apply; never commit `*.tfstate`.

## Monitoring & troubleshooting
- EC2 + ALB + RDS emit metrics to **CloudWatch** by default (CPU, request counts, DB connections).
- ALB **target health** shows whether instances pass the HTTP health check.
- See [`docs/troubleshooting.md`](docs/troubleshooting.md) for common failure modes (unhealthy targets, NAT/egress issues, RDS connectivity, SSM not connecting).

## Execution evidence
Deployed to AWS (`ap-south-1`) with `terraform apply` — **38 resources created, 0 errors**.
The ALB serves the app from an EC2 instance running in a private subnet:

![ALB serving the app from a private EC2 instance](architecture/images/alb-load-balancing.png)

> Served through the public ALB from a private EC2 instance in `ap-south-1b` —
> confirming the internet → ALB → private app flow works end to end. Infrastructure
> was destroyed after verification to avoid ongoing charges.

## Known limitations
- Single NAT Gateway by default (cost over strict HA) — toggle `single_nat_gateway = false` for one-per-AZ.
- RDS is single-AZ by default (`db_multi_az = false`).
- HTTP only (no TLS/ACM/Route 53) — see future improvements.
- `skip_final_snapshot = true` and `deletion_protection = false` for easy demo teardown — unsafe for production.
- Local Terraform state by default; enable a remote backend for teams.

## Cost considerations
| Resource | Free-tier? | Notes |
|----------|-----------|-------|
| EC2 `t3.micro` ×2 | Partly (750 hrs/mo, one instance) | 2 instances may exceed free tier |
| RDS `db.t3.micro` | Yes (12 mo, limits) | single-AZ, 20 GB gp3 |
| **NAT Gateway** | ❌ No | ~$0.045/hr + data — main cost driver |
| **ALB** | ❌ No | hourly + LCU charges |
| EIP (attached) | Free while attached | charged if left unattached |

Estimates only — verify current pricing for your region. **Always destroy when done.**

## Cleanup
```bash
cd terraform
terraform destroy          # or ../scripts/destroy.sh
```
Then confirm in the console that no **NAT Gateway, ALB, EC2, or RDS** remains
(these are the billable resources), and release any unattached EIPs.

## Future improvements
- HTTPS: ACM certificate + 443 listener + HTTP→HTTPS redirect.
- Route 53 hosted zone + alias record to the ALB.
- CloudFront CDN and AWS WAF in front of the ALB.
- S3 bucket for static assets; CloudWatch alarms + dashboards.
- Refactor the tiers into reusable Terraform modules.
- Remote state (S3 + DynamoDB lock) and CI `fmt`/`validate`/`tflint`/`checkov` checks.
