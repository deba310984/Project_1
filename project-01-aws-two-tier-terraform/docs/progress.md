# Progress — Project 01: Two-Tier AWS Infrastructure with Terraform

- **Portfolio No.:** 1
- **Original Reference No.:** #11
- **Reference:** https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-11
- **Overall status:** In Progress

## Status legend
Planned · In Progress · Blocked · Implemented — Not Yet Verified · Verified Locally · Verified in AWS · Published to GitHub · Completed

## Prerequisites
| Item | Status | Notes |
|------|--------|-------|
| Terraform CLI (local) | Not installed in cloud container | User installs locally, or we install in ephemeral container for fmt/validate |
| AWS CLI + credentials | Not present in cloud container | User provides on their own machine for plan/apply |
| AWS account (free-tier) | User-owned | Needed for Phase 6 apply |

## Phases
| Phase | Description | Status |
|-------|-------------|--------|
| 0 | Scaffold & Terraform foundation (versions, providers, vars, .gitignore, docs, diagram) | Verified Locally (fmt) |
| 1 | Networking (VPC, subnets, IGW, NAT, routes) | Implemented — Not Yet Verified |
| 2 | Security groups (ALB → App → DB) | Planned |
| 3 | Application tier (launch template, ASG, ALB, SSM role) | Planned |
| 4 | Data tier (RDS + subnet group) | Planned |
| 5 | Outputs, fmt, validate, plan | Planned |
| 6 | (User/AWS) apply, test, screenshot, destroy | Planned |
| 7 | Docs polish, interview sheet, commit & PR | Planned |

## Test results
- `terraform fmt -check`: PASS (run in cloud container, 2026-10-03)
- `terraform validate`: BLOCKED in container (egress proxy blocks registry.terraform.io; provider cannot download). Run on user's machine.
- `terraform plan`: not yet run (user's machine, needs AWS creds)

## Security checks
- No secrets/state committed: enforced via `.gitignore` (verify before each commit)
- SSM instead of public SSH: planned (Phase 3)

## Documentation & diagrams
- README.md: scaffolded
- architecture/architecture.mmd: created (not yet rendered to image)
- Screenshots: none yet (produced during Phase 6)

## Active cloud resources
- None (nothing applied)

## Cleanup status
- N/A (nothing deployed)

## Git
- Commit status: not yet committed
- GitHub publication: not yet published
