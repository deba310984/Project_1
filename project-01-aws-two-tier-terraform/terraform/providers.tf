# providers.tf
# Configures HOW Terraform talks to AWS. Credentials are NOT set here on
# purpose — Terraform reads them from your environment (AWS CLI profile,
# env vars, or an IAM role). Never hardcode access keys in .tf files.

provider "aws" {
  region = var.aws_region

  # default_tags are applied to every taggable resource this provider
  # creates. Consistent tagging is a real-world must: it powers cost
  # allocation, ownership, and cleanup ("delete everything tagged Project=...").
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Portfolio   = "project-01-aws-two-tier-terraform"
    }
  }
}
