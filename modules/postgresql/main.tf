resource "aws_security_group" "postgres" {
  name        = "postgres-sg"
  description = "Allow PostgreSQL from EKS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"

    # Replace with your node security group if available
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "postgres-sg"
  }
}


resource "aws_db_subnet_group" "postgres" {
  name = "postgres-subnets"

  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "postgres-subnets"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "postgres"

  engine         = "postgres"
  engine_version = "16.4"

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port = 5432

  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 7

  deletion_protection = false
  skip_final_snapshot = true

  auto_minor_version_upgrade = true

  apply_immediately = true

  tags = {
    Name = "postgres"
  }
}
