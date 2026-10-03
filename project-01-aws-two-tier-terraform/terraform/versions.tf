# versions.tf
# Pins the Terraform CLI version and the provider versions this project is
# tested against. Pinning prevents "it worked yesterday" drift: a new provider
# release can change defaults or resource behavior, so we constrain the range.

terraform {
  # Require a modern Terraform. The reference project targets >= 1.0.0.
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # ~> 5.0 means ">= 5.0.0 and < 6.0.0": pick up patch/minor fixes,
      # but never a major (6.x) that could introduce breaking changes.
      version = "~> 5.0"
    }
  }

  # Remote state backend is intentionally left as LOCAL state for now.
  # See docs/implementation-notes.md for how to enable an S3 + DynamoDB
  # remote backend (recommended for teams / real environments).
  # backend "s3" { ... }   # enabled later, optionally
}
