variable "ec2_ami" {}

variable "ec2_instance_type" {}

variable "subnet_id" {}

variable "volume_size" {}

variable "volume_type" {}

variable "ec2_name" {}

variable "bastion_secgroup_name" {}

variable "vpc_id" {}

variable "ssh_allowed_ips" {
    type = list(string)
}

variable "env" {}

variable "data_class" {}

variable "key_name" {}

variable "public_key" {}

variable "bastion_eip_name" {}