resource "aws_db_instance" "rds_instance" {
  # snapshot_identifier = var.snapshot_id
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true
  # restore_to_point_in_time    = true
  manage_master_user_password = true
  db_subnet_group_name        = var.db_subnet_group_name
  engine                      = var.engine
  engine_version              = var.engine_version
  identifier                  = var.identifier
  instance_class              = var.instance_class
  multi_az                    = var.multi_az
  db_name                     = var.db_name
  parameter_group_name        = aws_db_parameter_group.db_parameter_group.name
  port                        = 5432
  publicly_accessible         = false
  storage_encrypted           = true
  storage_type                = var.storage_type
  username                    = var.username

  vpc_security_group_ids = [aws_security_group.rds_secgroup.id]

  # lifecycle {
  #   ignore_changes = [
  #     snapshot_identifier,
  #   ]
  # }

  tags = {
    app                 = "sample"
    env                 = var.env
    data-classification = var.data_class
  }
}


resource "aws_db_parameter_group" "db_parameter_group" {
  name   = var.paramgroup_name
  family = "postgres16"

  # note: the following are just here as examples for how to set parameters
  #   parameter {
  #     name  = "character_set_server"
  #     value = "utf8"
  #   }

  #   parameter {
  #     name  = "character_set_client"
  # #     value = "utf8"
  #   }
}

resource "aws_security_group" "rds_secgroup" {
  name = var.secgroup_name

  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.cluster_secgroup]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.bastion_secgroup]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}