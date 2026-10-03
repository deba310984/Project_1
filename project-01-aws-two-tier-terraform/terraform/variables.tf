# variables.tf
# Input variables = the "function arguments" of your infrastructure.
# They make the code reusable across regions/environments without editing it.
# Only the GLOBAL identity variables live here for now; networking,
# compute, and database variables are added in their own phases.

variable "aws_region" {
  description = "AWS region to deploy all resources into."
  type        = string
  default     = "ap-south-1" # Mumbai; change to your nearest/cheapest region
}

variable "project_name" {
  description = "Short name used in resource names and tags."
  type        = string
  default     = "two-tier-demo"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod). Used in tags and names."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}
