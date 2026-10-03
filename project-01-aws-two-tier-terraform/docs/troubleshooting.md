# Troubleshooting — Project 01

| Symptom | Likely root cause | How to diagnose | Fix |
|---------|-------------------|-----------------|-----|
| `terraform init` fails: can't reach registry | Network/proxy blocks `registry.terraform.io` | `curl -I https://registry.terraform.io` | Run on a network that allows it, or configure a provider mirror |
| `validate`: Missing required provider | `init` didn't download the provider | re-run `terraform init` | Ensure init succeeds first |
| ALB targets **unhealthy** | Health check path/port wrong, or app not up yet | EC2 → Target Group → Targets; check instance HTTP on `app_port` | Confirm `user_data` ran; match health-check `path`/`matcher`; wait for grace period |
| App page times out in browser | ALB SG or app SG misconfigured | Check SG rules: ALB allows 80 from `0.0.0.0/0`; app allows `app_port` from ALB SG | Correct the SG chain |
| Instances can't `dnf update` | No egress route / NAT issue | From the instance (via SSM), `curl https://aws.amazon.com` | Verify app route table → NAT; verify NAT in a public subnet with an EIP |
| Can't connect to RDS from app | DB SG, subnet group, or endpoint wrong | From app instance: `nc -vz <rds-endpoint> 3306` | DB SG must allow 3306 from app SG; use the `rds_endpoint` output |
| SSM "start-session" fails / instance not listed | Missing IAM role, or no egress to SSM endpoints | SSM → Fleet Manager / Managed instances | Confirm instance profile attached; allow outbound 443 (NAT) or add VPC endpoints |
| `apply` error: db_password required | Sensitive var not set | — | `export TF_VAR_db_password=...` before apply |
| `DependencyViolation` on destroy | Ordering (ENIs/NAT/IGW) | read the error's resource | Re-run `terraform destroy`; Terraform resolves order on retry |
| RDS create very slow | Normal | — | RDS can take 5–10+ minutes to provision |

## Useful commands
```bash
# Open a shell on an instance WITHOUT SSH:
aws ssm start-session --target <instance-id>

# Watch ALB target health:
aws elbv2 describe-target-health --target-group-arn <tg-arn>

# Test the DB port from an app instance (via SSM session):
nc -vz <rds-endpoint-host> 3306

# Show outputs (alb_url etc.):
terraform output
terraform output -raw alb_dns_name
```
