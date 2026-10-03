# securitygroups.tf — Phase 2: the ALB -> App -> DB trust chain.
#
# Uses provider v5 standalone rule resources
# (aws_vpc_security_group_ingress_rule / _egress_rule) instead of inline
# rules. Benefit: each rule is its own addressable resource, and the SG has
# NO implicit rules you didn't write (an empty SG denies everything).

# ---------------------------------------------------------------------------
# 1. ALB security group — the only tier open to the internet
# ---------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "ALB: allow HTTP from the internet"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "${local.name_prefix}-alb-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from anywhere"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound (to reach app instances)"
  ip_protocol       = "-1" # -1 = every protocol/port
  cidr_ipv4         = "0.0.0.0/0"
}

# ---------------------------------------------------------------------------
# 2. App security group — reachable ONLY from the ALB
# ---------------------------------------------------------------------------
resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "App tier: allow traffic only from the ALB SG"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "${local.name_prefix}-app-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id = aws_security_group.app.id
  description       = "App port from the ALB security group only"
  ip_protocol       = "tcp"
  from_port         = var.app_port
  to_port           = var.app_port
  # Source is a SECURITY GROUP, not an IP range: trust the ALB tier itself.
  referenced_security_group_id = aws_security_group.alb.id
}

# Outbound is needed so instances can reach the NAT (OS updates) and the
# AWS SSM endpoints (HTTPS 443) that give us a shell without opening SSH.
resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id
  description       = "Allow all outbound (updates via NAT, SSM over 443)"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# ---------------------------------------------------------------------------
# 3. DB security group — reachable ONLY from the app tier
# ---------------------------------------------------------------------------
resource "aws_security_group" "db" {
  name        = "${local.name_prefix}-db-sg"
  description = "DB tier: allow DB port only from the app SG"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "${local.name_prefix}-db-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  description                  = "DB port from the app security group only"
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
  referenced_security_group_id = aws_security_group.app.id
}

# RDS rarely needs to initiate outbound connections, but leaving a permissive
# egress avoids surprises during managed tasks; tighten if your policy requires.
resource "aws_vpc_security_group_egress_rule" "db_all" {
  security_group_id = aws_security_group.db.id
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
