output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.id
}

output "priv_subnet1" {
  value = aws_subnet.private_subnet1.id
}

output "priv_subnet2" {
  value = aws_subnet.private_subnet1.id
}

output "priv_subnet3" {
  value = aws_subnet.private_subnet1.id
}

output "eip_pub_ip" {
  value = aws_eip.eip.public_ip
}

output "subnet_group_id" {
  value = aws_db_subnet_group.db_subnet_group.id
}

