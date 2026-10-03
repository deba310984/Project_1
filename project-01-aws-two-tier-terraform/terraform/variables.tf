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

# ---------------------------------------------------------------------------
# Application tier / Auto Scaling (Phase 3)
# ---------------------------------------------------------------------------

variable "instance_type" {
  description = "EC2 instance type for app servers (t3.micro = free-tier eligible)."
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum number of app instances."
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of app instances."
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of app instances at steady state."
  type        = number
  default     = 2
}

# ---------------------------------------------------------------------------
# Data tier / RDS (Phase 4)
# ---------------------------------------------------------------------------

variable "db_engine_version" {
  description = "MySQL engine version."
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance class (db.t3.micro = free-tier eligible)."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS storage in GiB (20 is within free-tier)."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name to create."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the database."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password. Supply via TF_VAR_db_password env var or a gitignored .tfvars — NEVER commit it."
  type        = string
  sensitive   = true
  # No default on purpose: Terraform will prompt/fail if it is not provided,
  # which prevents an accidental hardcoded secret.

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "db_password must be at least 8 characters."
  }
}

variable "db_multi_az" {
  description = "true = Multi-AZ standby (HA, costs ~2x). false = single-AZ (demo)."
  type        = bool
  default     = false
}

variable "db_backup_retention_days" {
  description = "Automated backup retention in days (0 disables backups)."
  type        = number
  default     = 1
}
