# rds.tf — Phase 4: managed MySQL database in the private DB subnets.

# A DB subnet group tells RDS which subnets it may place the database in.
# We give it ONLY the private db subnets, so RDS can never land in a public one.
resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = aws_subnet.db[*].id
  tags       = { Name = "${local.name_prefix}-db-subnet-group" }
}

resource "aws_db_instance" "main" {
  identifier     = "${local.name_prefix}-db"
  engine         = "mysql"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true # encryption at rest

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password # sensitive; supplied at apply time, never committed

  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  publicly_accessible     = false # never reachable from the internet
  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention_days

  # Demo-friendly teardown: no final snapshot, no deletion protection.
  # For anything real, set skip_final_snapshot=false and deletion_protection=true.
  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true

  tags = { Name = "${local.name_prefix}-db" }
}
