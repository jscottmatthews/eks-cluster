variable "identifier" {}

# variable "snapshot_id" {}

variable "db_name" {}

variable "engine" {}

variable "engine_version" {}

variable "allocated_storage" {}

variable "max_allocated_storage" {}

variable "username" {}

variable "backup_retention_period" {}

variable "instance_class" {}

variable "multi_az" {}

variable "storage_type" {}

# variable "cidr" {
#     default = "32"
# }

variable "vpc_id" {}

variable "secgroup_name" {}

variable "cluster_secgroup" {}

variable "bastion_secgroup" {}

variable "db_subnet_group_name" {}

# variable "subnet_group_subnet_ids" {}

variable "env" {}

variable "data_class" {}

variable "paramgroup_name" {}