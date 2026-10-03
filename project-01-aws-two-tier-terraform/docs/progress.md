# Progress — Project 01: Two-Tier AWS Infrastructure with Terraform

- **Portfolio No.:** 1
- **Original Reference No.:** #11
- **Reference:** https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-11
- **Overall status:** Verified in AWS (38 resources applied, ALB serving, screenshot captured). Destroy owner-confirmed pending.

## Status legend
Planned · In Progress · Blocked · Implemented — Not Yet Verified · Verified Locally · Verified in AWS · Published to GitHub · Completed

## Prerequisites
| Item | Status | Notes |
|------|--------|-------|
| Terraform CLI | Installed in container (v1.9.8) for fmt only | Owner installs locally for init/validate/plan/apply |
| AWS CLI + credentials | Not present in cloud container | Owner provides on their own machine |
| AWS account (free-tier) | Owner-owned | Needed for Phase 6 apply |

## Phases
| Phase | Description | Status |
|-------|-------------|--------|
| 0 | Scaffold & Terraform foundation | Verified Locally (fmt) · Published to GitHub |
| 1 | Networking (VPC, subnets, IGW, NAT, routes) | Implemented — Not Yet Verified · Published |
| 2 | Security groups (ALB → App → DB) | Implemented — Not Yet Verified · Published |
| 3 | Application tier (launch template, ASG, ALB, SSM role) | Implemented — Not Yet Verified · Published |
| 4 | Data tier (RDS + subnet group) | Implemented — Not Yet Verified · Published |
| 5 | Outputs, helper scripts, terraform test | Implemented — Not Yet Verified · Published |
| 6 | (Owner/AWS) apply, test, screenshot, destroy | Verified in AWS — applied (38 res), tested via ALB, screenshot saved; destroy pending owner confirmation |
| 7 | Docs polish, interview sheet | Verified Locally · Published |

## Test results
- `terraform fmt -check -recursive`: PASS (cloud container, 2026-10-03)
- `terraform validate`: BLOCKED in container (egress proxy blocks registry.terraform.io). Run on owner's machine.
- `terraform plan`: not yet run (owner's machine, needs AWS creds)
- `terraform test` (tests/plan.tftest.hcl): authored; run by owner (needs AWS creds)

## Security checks
- No secrets/state committed: enforced via `.gitignore`; verified `terraform.tfvars` ignored, `.example` committed
- db_password: sensitive variable, no default, supplied via TF_VAR_db_password
- SSM instead of public SSH: implemented (iam.tf + instance profile)
- IMDSv2 enforced on launch template; RDS encrypted + not publicly accessible

## Documentation & diagrams
- README.md: full portfolio README (all sections)
- docs/implementation-notes.md, troubleshooting.md, interview-prep.md: written
- architecture/architecture.mmd: created (render to architecture/images/ when ready)
- Screenshots: none yet (produced during Phase 6 by owner; do not include secrets)

## Active cloud resources
- None (nothing applied)

## Cleanup status
- N/A (nothing deployed). Teardown documented: scripts/destroy.sh / `terraform destroy`.

## Git
- Commit status: committed across phases 0–7 on branch claude/keen-einstein-dn6tm7
- GitHub publication: pushed; draft PR https://github.com/deba310984/aws-two-tier-terraform/pull/1

## Remaining for the owner
1. `cd terraform && export TF_VAR_db_password=... && terraform init && terraform validate && terraform plan`
2. Review plan; `terraform apply` (creates PAID resources).
3. `curl $(terraform output -raw alb_dns_name)` to smoke-test; screenshot to architecture/images/.
4. `terraform destroy` (or scripts/destroy.sh) and verify no billable resources remain.
5. Update this file's statuses to Verified in AWS once confirmed.
