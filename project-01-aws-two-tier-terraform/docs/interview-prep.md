# Interview Prep & Revision Sheet — Project 01

## 30-second project pitch
"I built a two-tier AWS architecture as Terraform IaC: a VPC across two AZs
with public, private-app, and private-db subnet tiers. An internet-facing ALB
fronts an Auto Scaling Group of EC2 instances in private subnets, which talk to
a private, encrypted RDS MySQL database. Security groups form a one-way
ALB→App→DB trust chain, there's no SSH — access is through SSM — and IMDSv2 is
enforced. It's `fmt`-validated with a native `terraform test` for guardrails."

## Core concepts (know cold)
| Concept | One-liner |
|---------|-----------|
| VPC | Your isolated virtual network in AWS |
| Subnet | An AZ-scoped slice of the VPC |
| Public subnet | Has a route `0.0.0.0/0 → IGW` |
| Private subnet | No direct inbound internet route |
| IGW | VPC's bidirectional internet door (public subnets) |
| NAT Gateway | Outbound-only internet for private subnets (paid) |
| Route table | Rules mapping destination CIDR → target |
| Security group | Stateful instance-level firewall |
| ALB | Layer-7 load balancer with health checks |
| ASG | Keeps N healthy instances, replaces failures |
| Launch template | Blueprint the ASG uses to build instances |
| RDS | Managed relational database |
| IMDSv2 | Token-required instance metadata (anti-SSRF) |

## Q&A with model answers
**Q: What literally makes a subnet "public"?**
A: Its route table has `0.0.0.0/0 → Internet Gateway`. The "public/private"
label is just convention; the route is the real distinction.

**Q: How does the database stay unreachable from the internet?**
A: Two independent layers — it's in a subnet with no internet route at all, and
its security group only allows 3306 from the app security group.

**Q: Why reference a security group as a source instead of an IP range?**
A: Instances get ephemeral IPs and scale in/out. An SG reference means "trust
the app tier," so rules never need editing as instances change.

**Q: NAT Gateway vs Internet Gateway?**
A: IGW is free and bidirectional for public subnets. NAT is paid and
outbound-only, letting private instances fetch updates without being reachable.

**Q: Why enforce IMDSv2?**
A: IMDSv1 is reachable via a simple GET and is exploitable through SSRF to steal
the instance's IAM credentials. IMDSv2 requires a signed token (PUT then GET),
blocking that path.

**Q: Why SSM instead of SSH?**
A: No open port 22, no key-pair management, access is IAM-controlled and logged
in CloudTrail. Smaller attack surface, better audit.

**Q: Where can Terraform leak secrets, and how do you prevent it?**
A: State files and committed `*.tfvars` can hold plaintext secrets. Prevent via
`.gitignore`, `sensitive = true` vars supplied at runtime, remote encrypted
state, and a secrets manager for real workloads.

**Q: What does `terraform plan` give you that applying directly wouldn't?**
A: A reviewable diff of exactly what will be created/changed/destroyed before
anything happens — the core safety mechanism of IaC.

**Q: Single NAT vs one-per-AZ — the trade-off?**
A: Single NAT is cheaper but a single-AZ failure point for egress; one-per-AZ is
HA but roughly doubles NAT cost. I made it a variable toggle.

## Reliability & security lessons
- Spread across AZs; let the ALB's **ELB health check** (not just EC2 status)
  decide instance health so bad app deploys are caught.
- Defense in depth: network isolation **and** security groups, not either alone.
- Make teardown-unsafe settings (`skip_final_snapshot`, `deletion_protection`)
  explicit and obviously demo-only.

## Self-assessment checklist
- [ ] I can explain every resource in the plan without notes.
- [ ] I can trace a packet from browser → ALB → EC2 → RDS and name each SG/route.
- [ ] I can explain why the DB has no internet route.
- [ ] I can justify single vs per-AZ NAT on cost and availability.
- [ ] I can explain how secrets are kept out of git and state.
- [ ] I can describe IMDSv2 and why it matters.
