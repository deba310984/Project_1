# Project 01 — Two-Tier AWS Infrastructure with Terraform

> **Portfolio No.:** 1 &nbsp;|&nbsp; **Original Reference No.:** #11
> **Reference:** [NotHarshhaa/DevOps-Projects — DevOps-Project-11](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-11)
> **Status:** 🚧 In Progress (Phase 0 — scaffold complete)

Provision a classic **two-tier AWS architecture** — a public web/application
tier and a private data tier — entirely with **Terraform (Infrastructure as
Code)**, across two Availability Zones, following least-privilege networking
and secure (SSH-less) instance access.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Scope: reference vs. implemented](#scope-reference-vs-implemented)
- [Technology stack](#technology-stack)
- [Repository structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Cost considerations](#cost-considerations)
- [Cleanup](#cleanup)
- [Implementation checklist](#implementation-checklist)

## Overview
**Problem:** Clicking resources together in the AWS console is slow,
error-prone, and not repeatable. **Solution:** describe the whole stack as
code so it can be reviewed, versioned, recreated, and destroyed on demand.

**Real-world use case:** this is the baseline pattern behind most web
applications — a load-balanced, auto-scaling app tier that talks to a managed
database kept private, with no database or app server directly exposed to the
internet.

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

**Traffic flow:** Internet → Internet Gateway → ALB (public subnets) → EC2 app
instances (private app subnets) → RDS (private DB subnets). Instances reach the
internet *outbound only* through a NAT Gateway. Admins connect via **SSM
Session Manager**, so **no SSH port is exposed**.

## Scope: reference vs. implemented
The reference (#11) spans many services. To stay focused and cost-aware, this
build implements the **core two-tier pattern** and documents the rest as
future work.

| Component | This project | Reference #11 |
|-----------|:---:|:---:|
| VPC, subnets, IGW, NAT, route tables | ✅ | ✅ |
| ALB + Auto Scaling Group + EC2 | ✅ | ✅ |
| RDS (MySQL) | ✅ | ✅ |
| Tiered security groups | ✅ | ✅ |
| SSM Session Manager (no SSH) | ✅ | — |
| Route 53 / CloudFront / ACM / WAF / S3 | 📋 future | ✅ |

## Technology stack
| Tech | Why |
|------|-----|
| **Terraform** | Declarative IaC; plan/apply workflow, state, reproducibility |
| **AWS VPC** | Isolated network with public/private subnet tiers |
| **EC2 + Auto Scaling + ALB** | Elastic, load-balanced application tier |
| **Amazon RDS (MySQL)** | Managed database, kept private |
| **IAM + SSM** | Least-privilege access; shell without exposing SSH |

## Repository structure
```text
project-01-aws-two-tier-terraform/
├── README.md
├── .gitignore
├── architecture/
│   ├── architecture.mmd
│   └── images/
├── terraform/
│   ├── versions.tf        # Terraform + provider version pins
│   ├── providers.tf       # AWS provider + default tags
│   ├── variables.tf       # input variables (global for now)
│   └── terraform.tfvars.example  # (added later) safe sample values
├── scripts/
├── tests/
└── docs/
    ├── implementation-notes.md   # (added as we go)
    ├── troubleshooting.md        # (added as we go)
    └── progress.md
```

## Prerequisites
- Terraform **≥ 1.5.0**
- AWS account with programmatic credentials configured (`aws configure` or env vars)
- An IAM identity allowed to create VPC/EC2/ELB/RDS/IAM resources

> This cloud container has neither the AWS CLI nor credentials. `plan`/`apply`
> are run by **you** on a machine with your AWS credentials.

## Cost considerations
- `t3.micro` EC2 and `db.t3.micro` RDS are **free-tier eligible** (12 months, within limits).
- **NAT Gateway and ALB are NOT free** (~$0.045/hr each + data, region-dependent). NAT is the main cost driver; a **single** NAT is used to minimize it.
- Estimates only — confirm against current AWS pricing for your region.
- **Always run cleanup when done.**

## Cleanup
```bash
cd terraform
terraform destroy   # review the plan, then confirm
```
Then verify in the console that no EC2, NAT, ALB, or RDS resources remain.

## Implementation checklist
- [x] Phase 0 — scaffold + Terraform foundation
- [ ] Phase 1 — networking
- [ ] Phase 2 — security groups
- [ ] Phase 3 — application tier
- [ ] Phase 4 — data tier
- [ ] Phase 5 — outputs, fmt, validate, plan
- [ ] Phase 6 — apply, test, screenshot, destroy (your AWS)
- [ ] Phase 7 — docs polish, interview sheet, commit & PR

---
*Part of a DevOps/SRE portfolio. Reference: NotHarshhaa/DevOps-Projects #11.*
