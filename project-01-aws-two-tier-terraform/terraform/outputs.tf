# outputs.tf — Phase 5: values surfaced after apply.
# Outputs are how one module hands useful facts to you (or to another module).

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer."
  value       = aws_lb.main.dns_name
}

output "alb_url" {
  description = "Open this in a browser to reach the app."
  value       = "http://${aws_lb.main.dns_name}"
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets (ALB, NAT)."
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets."
  value       = aws_subnet.app[*].id
}

output "db_subnet_ids" {
  description = "IDs of the private database subnets."
  value       = aws_subnet.db[*].id
}

output "nat_public_ips" {
  description = "Public IP(s) of the NAT Gateway(s) — the egress IP for private instances."
  value       = aws_eip.nat[*].public_ip
}

output "rds_endpoint" {
  description = "Connection endpoint (host:port) of the RDS instance."
  value       = aws_db_instance.main.endpoint
  sensitive   = true # endpoint is part of the connection detail; keep it quiet
}

output "security_group_ids" {
  description = "The three tier security group IDs."
  value = {
    alb = aws_security_group.alb.id
    app = aws_security_group.app.id
    db  = aws_security_group.db.id
  }
}
