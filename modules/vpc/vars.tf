variable "cidr" {}

variable "vpc_tags" {
  type = map(any)
}

variable "pub_subnet_cidr" {
}

variable "pub_subnet_az" {
}

variable "pub_subnet_name" {
}

variable "priv_sub1_cidr" {}

variable "priv_sub1_az" {}

variable "priv_sub1_name" {}

variable "priv_sub2_cidr" {}

variable "priv_sub2_az" {}

variable "priv_sub2_name" {}

variable "priv_sub3_cidr" {}

variable "priv_sub3_az" {}

variable "priv_sub3_name" {}

variable "eip_name" {}

variable "natgw_name" {}

variable "igw_name" {}

variable "rds_subnet_group_name" {}

