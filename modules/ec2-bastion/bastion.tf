resource "aws_instance" "ec2_instance" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.bastion_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion_secgroup.id]

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  tags = {
    Name                = var.ec2_name
    env                 = var.env
    data-classification = var.data_class
  }

  # lifecycle {
  #   ignore_changes = [
  #     ami,
  #   ]
  # }
}

resource "aws_key_pair" "bastion_key" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_eip" "bastion_eip" {
  domain   = "vpc"
  instance = aws_instance.ec2_instance.id
  tags = {
    Name = var.bastion_eip_name
  }
}

resource "aws_security_group" "bastion_secgroup" {
  name = var.bastion_secgroup_name

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}