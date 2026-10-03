# Implementation Notes — Project 01

## Design decisions & trade-offs

### Three subnet tiers (not two)
Although it's a "two-**tier**" *application* (app + data), the network uses
three subnet tiers: public, private-app, private-db. The extra DB tier means
the database subnets can have **no internet route at all**, a stronger
isolation than relying on security groups alone.

### Single NAT Gateway by default
NAT Gateways are the main cost driver (~$32/mo each + data). For a learning
demo, one shared NAT across both AZs is cheaper. `single_nat_gateway = false`
switches to one-per-AZ (removes the single-AZ failure point, ~2× cost). The
route-table wiring adapts automatically via `local.nat_count`.

### Fully private, encrypted RDS
`publicly_accessible = false`, `storage_encrypted = true`, placed in the DB
subnet group (private subnets only). The DB security group accepts 3306 **only**
from the app SG. For the demo, `skip_final_snapshot = true` and
`deletion_protection = false` make teardown painless — both must flip for prod.

### SSM instead of SSH
Instances get an IAM role with `AmazonSSMManagedInstanceCore`, so you open a
shell with `aws ssm start-session` — no key pairs, no port 22, full CloudTrail
auditing. IMDSv2 is enforced on the launch template.

### Standalone SG rule resources
`aws_vpc_security_group_ingress_rule` / `_egress_rule` (provider v5) are used
instead of inline `ingress {}`/`egress {}` blocks, so each rule is an
addressable resource and the SG has only the rules we declare.

### Latest AMI via SSM parameter
`data.aws_ssm_parameter` resolves the newest Amazon Linux 2023 AMI at plan
time, avoiding stale, region-specific hardcoded AMI IDs.

## Remote state (optional, recommended for teams)
State is local by default. To use an S3 backend with DynamoDB locking, create
the bucket + table once, then add to `versions.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket"
    key            = "project-01/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "my-tf-locks"
    encrypt        = true
  }
}
```
Then `terraform init -migrate-state`. Never commit state either way — it can
contain the RDS password in plaintext.

## Verification
- `terraform fmt -check -recursive` and `terraform validate` pass.
- `terraform test` (plan-time assertions) covers subnet counts and that RDS is
  private and encrypted.
- Deployed to AWS (`ap-south-1`): `terraform apply` provisioned 38 resources,
  the ALB served traffic across both AZs, then `terraform destroy` removed
  everything.
