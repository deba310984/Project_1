# plan.tftest.hcl — native `terraform test` (Terraform >= 1.6).
# Runs a PLAN (no resources created) and asserts the shape of the
# infrastructure. Requires AWS credentials, because data sources
# (availability zones, the AL2023 AMI parameter) call the AWS API.
#
# Run from the terraform/ directory:   terraform test
#
# A dummy password satisfies the sensitive variable during planning.

variables {
  db_password = "test-password-123"
  environment = "dev"
}

run "network_shape" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected 2 public subnets."
  }

  assert {
    condition     = length(aws_subnet.app) == 2
    error_message = "Expected 2 private app subnets."
  }

  assert {
    condition     = length(aws_subnet.db) == 2
    error_message = "Expected 2 private db subnets."
  }

  assert {
    condition     = aws_db_instance.main.publicly_accessible == false
    error_message = "RDS must NOT be publicly accessible."
  }

  assert {
    condition     = aws_db_instance.main.storage_encrypted == true
    error_message = "RDS storage must be encrypted."
  }
}
