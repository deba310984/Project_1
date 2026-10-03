# network.tf — Phase 1: VPC, subnets, IGW, NAT, route tables.

# Discover which AZs exist in the chosen region, then take the first N.
# Using a data source (not hardcoded AZ names) keeps the code region-portable.
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  azs         = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  # Number of NAT gateways to create: 1 shared, or one per AZ.
  nat_count = var.single_nat_gateway ? 1 : var.az_count
}

# ---------------------------------------------------------------------------
# VPC + Internet Gateway
# ---------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  # DNS support + hostnames are required for RDS endpoints and SSM to resolve.
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "${local.name_prefix}-vpc" }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${local.name_prefix}-igw" }
}

# ---------------------------------------------------------------------------
# Subnets — three tiers, one subnet per AZ in each tier
# ---------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  # Public-facing: instances launched here get a public IP automatically.
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-${local.azs[count.index]}"
    Tier = "public"
  }
}

resource "aws_subnet" "app" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "${local.name_prefix}-app-${local.azs[count.index]}"
    Tier = "app"
  }
}

resource "aws_subnet" "db" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "${local.name_prefix}-db-${local.azs[count.index]}"
    Tier = "db"
  }
}

# ---------------------------------------------------------------------------
# NAT Gateway(s) — give private app instances OUTBOUND-only internet
# Each NAT needs a static public IP (Elastic IP) and lives in a public subnet.
# ---------------------------------------------------------------------------
resource "aws_eip" "nat" {
  count  = local.nat_count
  domain = "vpc"
  tags   = { Name = "${local.name_prefix}-nat-eip-${count.index}" }
}

resource "aws_nat_gateway" "main" {
  count         = local.nat_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = { Name = "${local.name_prefix}-nat-${count.index}" }

  # The IGW must exist before a NAT can route out.
  depends_on = [aws_internet_gateway.main]
}

# ---------------------------------------------------------------------------
# Route tables
# ---------------------------------------------------------------------------

# Public: default route to the Internet Gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "${local.name_prefix}-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# App (private): default route to a NAT Gateway (outbound only).
# One route table per NAT so each AZ uses its own NAT when single_nat_gateway=false.
resource "aws_route_table" "app" {
  count  = local.nat_count
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  tags = { Name = "${local.name_prefix}-app-rt-${count.index}" }
}

resource "aws_route_table_association" "app" {
  count     = var.az_count
  subnet_id = aws_subnet.app[count.index].id
  # With a single NAT, every app subnet shares route table [0];
  # otherwise each app subnet maps to the NAT in its own AZ.
  route_table_id = var.single_nat_gateway ? aws_route_table.app[0].id : aws_route_table.app[count.index].id
}

# DB (private): NO internet route at all — only the implicit local VPC route.
# The database must never reach or be reached from the internet.
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${local.name_prefix}-db-rt" }
}

resource "aws_route_table_association" "db" {
  count          = var.az_count
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}
