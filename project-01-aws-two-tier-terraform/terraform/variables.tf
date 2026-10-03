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

# ---------------------------------------------------------------------------
# Networking (Phase 1)
# ---------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC. /16 gives 65,536 addresses to subdivide."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "How many Availability Zones to spread subnets across (2 = HA)."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count must be 2 or 3 for this project."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets (ALB, NAT). One per AZ."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "CIDRs for private application subnets (EC2). One per AZ."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "CIDRs for private database subnets (RDS). One per AZ."
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "single_nat_gateway" {
  description = "true = one shared NAT Gateway (cheaper, demo). false = one per AZ (HA, costlier)."
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------
# Application / database ports (Phase 2)
# ---------------------------------------------------------------------------

variable "app_port" {
  description = "TCP port the app listens on (ALB forwards here)."
  type        = number
  default     = 80
}

variable "db_port" {
  description = "TCP port for the database (3306 = MySQL, 5432 = PostgreSQL)."
  type        = number
  default     = 3306
}
