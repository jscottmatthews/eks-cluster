variable "cluster_name" {}

variable "env" {}

variable "app" {}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_version" {}

variable "ng_version" {}

variable "access_entry_principal_arn" {}

variable "private_subnets" {
  type = list(string)
}

variable "public_ng_disk_size" {}

variable "main_ng_disk_size" {}

variable "main_ng_dsrd_size" {}

variable "main_ng_max" {}

variable "main_ng_min" {}

variable "main_ng_name" {}

variable "public_ng_name" {}

variable "public_access_cidrs" {
  type = list(string)
}

variable "public_ng_dsrd_size" {}

variable "public_ng_max" {}

variable "public_ng_min" {}

variable "main_ng_instance_type" {
  type = list(string)
}

variable "public_ng_instance_type" {
  type = list(string)
}

variable "public_subnet" {
  type = list(string)
}

variable "ami_type" {}

variable "vpc_id" {}


variable "role_arn" {}

variable "main_ng_node_role" {}

variable "public_ng_node_role" {}

variable "log_group_name" {}

variable "log_group_class" {}

variable "retention_in_days" {}

variable "log_env" {}

variable "log_app" {}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}

variable "cni_addon_name" {}

variable "cni_addon_version" {}

variable "cni_addon_config" {}